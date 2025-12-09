import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';
import '../models/audit_log_model.dart';
import 'audit_service.dart';

class UserManagementService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Get all accounts (admins and users)
  static Future<List<UserModel>> getAllAccounts() async {
    try {
      final adminsSnapshot = await _firestore.collection('admins').get();
      final usersSnapshot = await _firestore.collection('users').get();

      final admins = adminsSnapshot.docs
          .map((doc) {
            try {
              return UserModel.fromJson(doc.data());
            } catch (e) {
              print('⚠️ Error parsing admin doc ${doc.id}: $e');
              return null;
            }
          })
          .whereType<UserModel>()
          .toList();
      
      final users = usersSnapshot.docs
          .map((doc) {
            try {
              return UserModel.fromJson(doc.data());
            } catch (e) {
              print('⚠️ Error parsing user doc ${doc.id}: $e');
              return null;
            }
          })
          .whereType<UserModel>()
          .toList();

      final all = <UserModel>[];
      all.addAll(admins);
      all.addAll(users);

      return all;
    } catch (e) {
      print('❌ Error loading accounts: $e');
      return [];
    }
  }

  /// Get user by ID (checks both collections)
  static Future<UserModel?> getUserById(String userId) async {
    try {
      // Check admins collection first
      final adminDoc = await _firestore.collection('admins').doc(userId).get();
      if (adminDoc.exists) {
        return UserModel.fromJson(adminDoc.data()!);
      }

      // Check users collection
      final userDoc = await _firestore.collection('users').doc(userId).get();
      if (userDoc.exists) {
        return UserModel.fromJson(userDoc.data()!);
      }

      return null;
    } catch (e) {
      print('❌ Error getting user by ID: $e');
      return null;
    }
  }

  /// Search users by name or email
  static Future<List<UserModel>> searchUsers(String query) async {
    try {
      final allAccounts = await getAllAccounts();
      final lowerQuery = query.toLowerCase();
      
      return allAccounts.where((user) {
        return user.name.toLowerCase().contains(lowerQuery) ||
               user.email.toLowerCase().contains(lowerQuery);
      }).toList();
    } catch (e) {
      print('❌ Error searching users: $e');
      return [];
    }
  }

  /// Filter users by status
  static Future<List<UserModel>> filterUsersByStatus(String status) async {
    try {
      final allAccounts = await getAllAccounts();
      return allAccounts.where((user) => user.status == status).toList();
    } catch (e) {
      print('❌ Error filtering users by status: $e');
      return [];
    }
  }

  /// Filter users by role
  static Future<List<UserModel>> filterUsersByRole(UserRole role) async {
    try {
      final allAccounts = await getAllAccounts();
      return allAccounts.where((user) => user.role == role).toList();
    } catch (e) {
      print('❌ Error filtering users by role: $e');
      return [];
    }
  }

  /// Create a new user account (admin function)
  static Future<Map<String, dynamic>> createUser({
    required String email,
    required String password,
    required String name,
    required UserRole role,
    required String adminId,
    required String adminEmail,
    required String adminName,
    String status = 'Active',
  }) async {
    try {
      // Check if email already exists
      final existingUser = await _checkEmailExists(email);
      if (existingUser != null) {
        return {
          'success': false,
          'error': 'Email already exists',
          'userId': null,
        };
      }

      // Create Firebase Auth user
      final userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user == null) {
        return {
          'success': false,
          'error': 'Failed to create Firebase user',
          'userId': null,
        };
      }

      // Update display name
      await user.updateDisplayName(name);

      // Create user model
      final userModel = UserModel(
        uid: user.uid,
        email: email,
        name: name,
        role: role,
        isEmailVerified: false,
        createdAt: DateTime.now(),
        status: status,
        activityCount: 0,
      );

      // Store in appropriate collection
      final collectionName = role == UserRole.admin ? 'admins' : 'users';
      await _firestore
          .collection(collectionName)
          .doc(user.uid)
          .set(userModel.toJson());

      // Log audit trail
      await AuditService.logUserManagement(
        action: AuditAction.adminCreatedUser,
        targetUserId: user.uid,
        targetUserName: name,
        actorId: adminId,
        actorName: adminName,
        changes: {
          'email': email,
          'role': role.toString().split('.').last,
          'status': status,
          'createdBy': adminEmail,
        },
      );

      print('✅ Created user: $email with role ${role.toString().split('.').last}');
      
      return {
        'success': true,
        'error': null,
        'userId': user.uid,
        'userModel': userModel,
      };
    } on FirebaseAuthException catch (e) {
      print('❌ Firebase Auth Error creating user: ${e.code} - ${e.message}');
      return {
        'success': false,
        'error': _getFirebaseErrorMessage(e.code),
        'userId': null,
      };
    } catch (e) {
      print('❌ Error creating user: $e');
      return {
        'success': false,
        'error': 'Failed to create user: ${e.toString()}',
        'userId': null,
      };
    }
  }

  /// Check if email exists in either collection
  static Future<UserModel?> _checkEmailExists(String email) async {
    try {
      // Check admins collection
      final adminsQuery = await _firestore
          .collection('admins')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();
      
      if (adminsQuery.docs.isNotEmpty) {
        return UserModel.fromJson(adminsQuery.docs.first.data());
      }

      // Check users collection
      final usersQuery = await _firestore
          .collection('users')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();
      
      if (usersQuery.docs.isNotEmpty) {
        return UserModel.fromJson(usersQuery.docs.first.data());
      }

      return null;
    } catch (e) {
      print('❌ Error checking email existence: $e');
      return null;
    }
  }

  /// Update user status (Active/Inactive)
  static Future<bool> updateUserStatus({
    required String targetUserId,
    required bool isAdmin,
    required String newStatus,
    required String adminId,
    required String adminEmail,
    required String adminName,
  }) async {
    try {
      final collectionName = isAdmin ? 'admins' : 'users';
      final docRef = _firestore.collection(collectionName).doc(targetUserId);
      
      // Get current user data for audit trail
      final currentDoc = await docRef.get();
      if (!currentDoc.exists) {
        print('❌ User document not found: $targetUserId');
        return false;
      }

      final currentData = currentDoc.data()!;
      final oldStatus = currentData['status'] ?? 'Unknown';

      // Update status
      await docRef.update({
        'status': newStatus,
      });

      // Log audit trail
      await AuditService.logUserManagement(
        action: AuditAction.userStatusChanged,
        targetUserId: targetUserId,
        targetUserName: currentData['name'] ?? 'Unknown',
        actorId: adminId,
        actorName: adminName,
        changes: {
          'oldStatus': oldStatus,
          'newStatus': newStatus,
        },
      );

      print('✅ Updated user status for $targetUserId from $oldStatus to $newStatus');
      return true;
    } catch (e) {
      print('❌ Error updating user status: $e');
      return false;
    }
  }

  /// Update user role (promote/demote)
  static Future<bool> updateUserRole({
    required String targetUserId,
    required bool currentIsAdmin,
    required bool makeAdmin,
    required String adminId,
    required String adminEmail,
    required String adminName,
  }) async {
    try {
      if (currentIsAdmin == makeAdmin) {
        return true; // No change needed
      }

      final fromCollection = currentIsAdmin ? 'admins' : 'users';
      final toCollection = makeAdmin ? 'admins' : 'users';

      final docRef = _firestore.collection(fromCollection).doc(targetUserId);
      final doc = await docRef.get();
      
      if (!doc.exists) {
        print('❌ User document not found in $fromCollection: $targetUserId');
        return false;
      }

      final data = doc.data() ?? {};
      final userName = data['name'] ?? 'Unknown';
      final oldRole = data['role'] ?? 'unknown';

      // Update role in data
      data['role'] = makeAdmin ? 'admin' : 'user';

      // Move to new collection
      await _firestore.collection(toCollection).doc(targetUserId).set(data);
      await docRef.delete();

      // Log audit trail
      await AuditService.logUserManagement(
        action: AuditAction.userRoleChanged,
        targetUserId: targetUserId,
        targetUserName: userName,
        actorId: adminId,
        actorName: adminName,
        changes: {
          'oldRole': oldRole,
          'newRole': data['role'],
          'fromCollection': fromCollection,
          'toCollection': toCollection,
        },
      );

      print(
        '✅ Moved user $targetUserId from $fromCollection to $toCollection with role ${data['role']}',
      );

      return true;
    } catch (e) {
      print('❌ Error updating user role: $e');
      return false;
    }
  }

  /// Update user details (name, email)
  static Future<bool> updateUserDetails({
    required String targetUserId,
    required bool isAdmin,
    required String? name,
    required String? email,
    required String adminId,
    required String adminEmail,
    required String adminName,
  }) async {
    try {
      final collectionName = isAdmin ? 'admins' : 'users';
      final docRef = _firestore.collection(collectionName).doc(targetUserId);
      
      // Get current user data for audit trail
      final currentDoc = await docRef.get();
      if (!currentDoc.exists) {
        print('❌ User document not found: $targetUserId');
        return false;
      }

      final currentData = currentDoc.data()!;
      final changesBefore = <String, dynamic>{};
      final changesAfter = <String, dynamic>{};
      final updateData = <String, dynamic>{};

      // Prepare updates
      if (name != null && name != currentData['name']) {
        changesBefore['name'] = currentData['name'];
        changesAfter['name'] = name;
        updateData['name'] = name;
      }

      if (email != null && email != currentData['email']) {
        // Check if new email already exists
        final existingUser = await _checkEmailExists(email);
        if (existingUser != null && existingUser.uid != targetUserId) {
          print('❌ Email already exists: $email');
          return false;
        }

        changesBefore['email'] = currentData['email'];
        changesAfter['email'] = email;
        updateData['email'] = email;

        // Update Firebase Auth email if needed
        try {
          final firebaseUser = await _auth.currentUser;
          if (firebaseUser?.uid == targetUserId) {
            await firebaseUser!.updateEmail(email);
          }
        } catch (e) {
          print('⚠️ Could not update Firebase Auth email: $e');
        }
      }

      if (updateData.isEmpty) {
        return true; // No changes to make
      }

      // Update Firestore
      await docRef.update(updateData);

      // Log audit trail
      await AuditService.logUserManagement(
        action: AuditAction.adminUpdatedUser,
        targetUserId: targetUserId,
        targetUserName: currentData['name'] ?? 'Unknown',
        actorId: adminId,
        actorName: adminName,
        changes: {
          'changesBefore': changesBefore,
          'changesAfter': changesAfter,
        },
      );

      print('✅ Updated user details for $targetUserId');
      return true;
    } catch (e) {
      print('❌ Error updating user details: $e');
      return false;
    }
  }

  /// Delete user account
  static Future<bool> deleteUser({
    required String targetUserId,
    required bool isAdmin,
    required String adminId,
    required String adminEmail,
    required String adminName,
  }) async {
    try {
      final collectionName = isAdmin ? 'admins' : 'users';
      final docRef = _firestore.collection(collectionName).doc(targetUserId);
      
      // Get user data for audit trail before deletion
      final doc = await docRef.get();
      if (!doc.exists) {
        print('❌ User document not found: $targetUserId');
        return false;
      }

      final userData = doc.data()!;
      final userName = userData['name'] ?? 'Unknown';
      final userEmail = userData['email'] ?? 'Unknown';

      // Delete Firestore document
      await docRef.delete();

      // Try to delete Firebase Auth user (may fail if not current user)
      try {
        final firebaseUser = await _auth.currentUser;
        if (firebaseUser?.uid == targetUserId) {
          await firebaseUser!.delete();
        } else {
          // Admin deleting another user - would need Admin SDK for this
          print('⚠️ Cannot delete Firebase Auth user from client SDK');
        }
      } catch (e) {
        print('⚠️ Could not delete Firebase Auth user: $e');
      }

      // Log audit trail
      await AuditService.logUserManagement(
        action: AuditAction.adminDeletedUser,
        targetUserId: targetUserId,
        targetUserName: userName,
        actorId: adminId,
        actorName: adminName,
        changes: {
          'deletedEmail': userEmail,
          'deletedRole': userData['role'] ?? 'unknown',
        },
      );

      print('✅ Deleted user: $targetUserId');
      return true;
    } catch (e) {
      print('❌ Error deleting user: $e');
      return false;
    }
  }

  /// Get user statistics
  static Future<Map<String, int>> getUserStatistics() async {
    try {
      final allAccounts = await getAllAccounts();
      
      return {
        'total': allAccounts.length,
        'active': allAccounts.where((u) => u.status == 'Active').length,
        'inactive': allAccounts.where((u) => u.status == 'Inactive').length,
        'admins': allAccounts.where((u) => u.role == UserRole.admin).length,
        'users': allAccounts.where((u) => u.role == UserRole.user).length,
      };
    } catch (e) {
      print('❌ Error getting user statistics: $e');
      return {
        'total': 0,
        'active': 0,
        'inactive': 0,
        'admins': 0,
        'users': 0,
      };
    }
  }

  /// Helper: Get Firebase error message
  static String _getFirebaseErrorMessage(String code) {
    switch (code) {
      case 'email-already-in-use':
        return 'Email is already registered';
      case 'invalid-email':
        return 'Invalid email address';
      case 'weak-password':
        return 'Password is too weak';
      case 'operation-not-allowed':
        return 'Operation not allowed';
      default:
        return 'An error occurred: $code';
    }
  }
}
