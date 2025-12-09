import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../services/audit_service.dart';
import '../models/audit_log_model.dart';

/// Service for managing user profile updates
class UserProfileService {
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Update user's display name
  static Future<Map<String, dynamic>> updateUserName({
    required String userId,
    required String newName,
    required bool isAdmin,
  }) async {
    try {
      if (newName.trim().isEmpty) {
        return {
          'success': false,
          'error': 'Name cannot be empty',
        };
      }

      final collectionName = isAdmin ? 'admins' : 'users';
      final docRef = _firestore.collection(collectionName).doc(userId);

      // Get current data
      final doc = await docRef.get();
      if (!doc.exists) {
        return {
          'success': false,
          'error': 'User not found',
        };
      }

      final currentData = doc.data()!;
      final oldName = currentData['name'] ?? '';

      if (oldName == newName.trim()) {
        return {
          'success': false,
          'error': 'Name is the same',
        };
      }

      // Update Firestore
      await docRef.update({
        'name': newName.trim(),
      });

      // Update Firebase Auth display name
      try {
        final user = _auth.currentUser;
        if (user != null && user.uid == userId) {
          await user.updateDisplayName(newName.trim());
        }
      } catch (e) {
        print('⚠️ Could not update Firebase Auth display name: $e');
      }

      // Log audit trail
      await AuditService.log(
        action: AuditAction.userAccountUpdated,
        description: 'User updated display name from "$oldName" to "${newName.trim()}"',
        actorId: userId,
        actorEmail: currentData['email'] ?? '',
        actorName: oldName,
        actorType: isAdmin ? 'admin' : 'user',
        category: 'user_profile',
        riskLevel: RiskLevel.low,
        success: true,
        changesBefore: {'name': oldName},
        changesAfter: {'name': newName.trim()},
      );

      print('✅ Updated user name: $userId');
      return {
        'success': true,
        'message': 'Name updated successfully',
      };
    } catch (e) {
      print('❌ Error updating user name: $e');
      return {
        'success': false,
        'error': 'Failed to update name: ${e.toString()}',
      };
    }
  }

  /// Update user's email address
  static Future<Map<String, dynamic>> updateUserEmail({
    required String userId,
    required String newEmail,
    required bool isAdmin,
  }) async {
    try {
      if (newEmail.trim().isEmpty || !newEmail.contains('@')) {
        return {
          'success': false,
          'error': 'Invalid email address',
        };
      }

      final collectionName = isAdmin ? 'admins' : 'users';

      // Check if email already exists
      final emailQuery = await _firestore
          .collection(collectionName)
          .where('email', isEqualTo: newEmail.trim())
          .limit(1)
          .get();

      if (emailQuery.docs.isNotEmpty && emailQuery.docs.first.id != userId) {
        return {
          'success': false,
          'error': 'Email already in use',
        };
      }

      // Also check the other collection
      final otherCollection = isAdmin ? 'users' : 'admins';
      final otherEmailQuery = await _firestore
          .collection(otherCollection)
          .where('email', isEqualTo: newEmail.trim())
          .limit(1)
          .get();

      if (otherEmailQuery.docs.isNotEmpty) {
        return {
          'success': false,
          'error': 'Email already in use',
        };
      }

      final docRef = _firestore.collection(collectionName).doc(userId);

      // Get current data
      final doc = await docRef.get();
      if (!doc.exists) {
        return {
          'success': false,
          'error': 'User not found',
        };
      }

      final currentData = doc.data()!;
      final oldEmail = currentData['email'] ?? '';

      if (oldEmail.toLowerCase() == newEmail.trim().toLowerCase()) {
        return {
          'success': false,
          'error': 'Email is the same',
        };
      }

      // Update Firestore
      await docRef.update({
        'email': newEmail.trim().toLowerCase(),
      });

      // Update Firebase Auth email
      try {
        final user = _auth.currentUser;
        if (user != null && user.uid == userId) {
          await user.updateEmail(newEmail.trim().toLowerCase());
        }
      } catch (e) {
        print('⚠️ Could not update Firebase Auth email: $e');
        // If email update fails, revert Firestore change
        await docRef.update({'email': oldEmail});
        return {
          'success': false,
          'error': 'Failed to update email. Please re-authenticate.',
        };
      }

      // Log audit trail
      await AuditService.log(
        action: AuditAction.userAccountUpdated,
        description: 'User updated email from "$oldEmail" to "${newEmail.trim()}"',
        actorId: userId,
        actorEmail: oldEmail,
        actorName: currentData['name'] ?? '',
        actorType: isAdmin ? 'admin' : 'user',
        category: 'user_profile',
        riskLevel: RiskLevel.medium,
        success: true,
        changesBefore: {'email': oldEmail},
        changesAfter: {'email': newEmail.trim().toLowerCase()},
      );

      print('✅ Updated user email: $userId');
      return {
        'success': true,
        'message': 'Email updated successfully',
      };
    } catch (e) {
      print('❌ Error updating user email: $e');
      return {
        'success': false,
        'error': 'Failed to update email: ${e.toString()}',
      };
    }
  }

  /// Update user's password
  static Future<Map<String, dynamic>> updateUserPassword({
    required String userId,
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      if (newPassword.length < 6) {
        return {
          'success': false,
          'error': 'Password must be at least 6 characters',
        };
      }

      final user = _auth.currentUser;
      if (user == null || user.uid != userId) {
        return {
          'success': false,
          'error': 'User not authenticated',
        };
      }

      // Re-authenticate user with current password
      try {
        final credential = EmailAuthProvider.credential(
          email: user.email!,
          password: currentPassword,
        );
        await user.reauthenticateWithCredential(credential);
      } catch (e) {
        return {
          'success': false,
          'error': 'Current password is incorrect',
        };
      }

      // Update password
      await user.updatePassword(newPassword);

      // Log audit trail
      await AuditService.log(
        action: AuditAction.userAccountUpdated,
        description: 'User updated password',
        actorId: userId,
        actorEmail: user.email ?? '',
        actorName: user.displayName ?? '',
        actorType: 'user',
        category: 'user_profile',
        riskLevel: RiskLevel.high,
        success: true,
        metadata: {
          'passwordChangedAt': DateTime.now().toIso8601String(),
        },
      );

      print('✅ Updated user password: $userId');
      return {
        'success': true,
        'message': 'Password updated successfully',
      };
    } catch (e) {
      print('❌ Error updating password: $e');
      return {
        'success': false,
        'error': 'Failed to update password: ${e.toString()}',
      };
    }
  }

  /// Update user's profile photo URL
  static Future<Map<String, dynamic>> updateUserPhotoUrl({
    required String userId,
    required String photoUrl,
    required bool isAdmin,
  }) async {
    try {
      final collectionName = isAdmin ? 'admins' : 'users';
      final docRef = _firestore.collection(collectionName).doc(userId);

      // Get current data
      final doc = await docRef.get();
      if (!doc.exists) {
        return {
          'success': false,
          'error': 'User not found',
        };
      }

      final currentData = doc.data()!;
      final oldPhotoUrl = currentData['photoUrl'];

      // Update Firestore
      await docRef.update({
        'photoUrl': photoUrl,
      });

      // Update Firebase Auth photo URL
      try {
        final user = _auth.currentUser;
        if (user != null && user.uid == userId) {
          await user.updatePhotoURL(photoUrl);
        }
      } catch (e) {
        print('⚠️ Could not update Firebase Auth photo URL: $e');
      }

      // Log audit trail
      await AuditService.log(
        action: AuditAction.userAccountUpdated,
        description: 'User updated profile photo',
        actorId: userId,
        actorEmail: currentData['email'] ?? '',
        actorName: currentData['name'] ?? '',
        actorType: isAdmin ? 'admin' : 'user',
        category: 'user_profile',
        riskLevel: RiskLevel.low,
        success: true,
        changesBefore: {'photoUrl': oldPhotoUrl},
        changesAfter: {'photoUrl': photoUrl},
      );

      print('✅ Updated user photo URL: $userId');
      return {
        'success': true,
        'message': 'Profile photo updated successfully',
      };
    } catch (e) {
      print('❌ Error updating photo URL: $e');
      return {
        'success': false,
        'error': 'Failed to update photo: ${e.toString()}',
      };
    }
  }

  /// Get user profile data
  static Future<UserModel?> getUserProfile({
    required String userId,
    required bool isAdmin,
  }) async {
    try {
      final collectionName = isAdmin ? 'admins' : 'users';
      final doc = await _firestore.collection(collectionName).doc(userId).get();

      if (!doc.exists) {
        return null;
      }

      return UserModel.fromJson(doc.data()!);
    } catch (e) {
      print('❌ Error getting user profile: $e');
      return null;
    }
  }
}

