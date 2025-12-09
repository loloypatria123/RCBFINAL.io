import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_model.dart';
import '../models/audit_log_model.dart';
import '../services/email_service.dart';
import '../services/fallback_email_service.dart';
import '../services/audit_service.dart';
import '../services/security_service.dart';
import '../services/storage_service.dart';
import '../services/google_signin_service.dart';
import '../services/facebook_signin_service.dart';
import '../services/user_profile_service.dart';

class AuthProvider extends ChangeNotifier {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  BuildContext? _context;

  User? _user;
  UserModel? _userModel;
  bool _isLoading = false;
  String? _errorMessage;
  String? _verificationCode;
  String? _pendingEmail;

  User? get user => _user;
  UserModel? get userModel => _userModel;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _user != null;
  UserRole? get userRole => _userModel?.role;
  bool get isAdmin => _userModel?.role == UserRole.admin;
  bool get isEmailVerified => _userModel?.isEmailVerified ?? false;
  String? get verificationCode => _verificationCode;
  String? get pendingEmail => _pendingEmail;

  AuthProvider({BuildContext? context}) {
    _context = context;
    _initializeUser();
    _checkAutoLogin();
  }

  void setContext(BuildContext context) {
    _context = context;
  }

  void _initializeUser() {
    _user = _firebaseAuth.currentUser;
    if (_user != null) {
      _loadUserModel();
    }
    _firebaseAuth.authStateChanges().listen((User? user) {
      _user = user;
      if (user != null) {
        _loadUserModel();
      } else {
        _userModel = null;
      }
      notifyListeners();
    });
  }

  /// Check if user has enabled "Remember Me" and auto-login
  Future<void> _checkAutoLogin() async {
    try {
      final hasCredentials = await StorageService.hasStoredCredentials();
      final isAutoLoginEnabled = await StorageService.isAutoLoginEnabled();
      
      if (hasCredentials && isAutoLoginEnabled && _user != null) {
        print('✅ Auto-login: User already authenticated');
        // User is already signed in with Firebase
        await _loadUserModel();
      }
    } catch (e) {
      print('⚠️ Auto-login check error: $e');
    }
  }

  /// Check if user should be auto-logged in (for navigation)
  Future<bool> shouldAutoLogin() async {
    try {
      final hasCredentials = await StorageService.hasStoredCredentials();
      final isAutoLoginEnabled = await StorageService.isAutoLoginEnabled();
      return hasCredentials && isAutoLoginEnabled && _user != null;
    } catch (e) {
      print('⚠️ Error checking auto-login: $e');
      return false;
    }
  }

  Future<void> _loadUserModel() async {
    if (_user == null) {
      print('⚠️ Cannot load user model: _user is null');
      return;
    }

    try {
      print('🔍 Attempting to load user model for UID: ${_user!.uid}');

      // Try to load from admins collection first using UID as document ID
      var doc = await _firestore.collection('admins').doc(_user!.uid).get();

      if (doc.exists) {
        final data = doc.data();
        if (data == null) {
          print('⚠️ Admin document exists but data is null');
          _userModel = null;
          return;
        }
        print('📝 Raw admin data from Firestore: $data');
        print('📝 Role field value: ${data['role']}');
        print('📝 Status field value: ${data['status']}');
        _userModel = UserModel.fromJson(data);
        print('✅ Loaded admin from admins collection');
        print('✅ Parsed role: ${_userModel?.role}');
        print('✅ Parsed status: ${_userModel?.status}');
        print('✅ Is admin check: ${_userModel?.role == UserRole.admin}');
      } else {
        // If not found in admins, try users collection by UID
        print('🔍 Not found in admins, checking users collection by UID...');
        doc = await _firestore.collection('users').doc(_user!.uid).get();
        if (doc.exists) {
          final data = doc.data();
          if (data == null) {
            print('⚠️ User document exists but data is null');
            _userModel = null;
            return;
          }
          print('📝 Raw user data from Firestore: $data');
          print('📝 Role field value: ${data['role']}');
          print('📝 Status field value: ${data['status']}');
          _userModel = UserModel.fromJson(data);
          print('✅ Loaded user from users collection (by UID)');
          print('✅ Parsed role: ${_userModel?.role}');
          print('✅ Parsed status: ${_userModel?.status}');
        } else {
          // Fallback: some existing accounts may use auto-generated document IDs.
          // In that case, search by email in both collections.
          print(
            '🔍 User not found by UID; searching by email in admins/users...',
          );

          final email = _user!.email;

          if (email == null) {
            print(
              '⚠️ Current Firebase user has no email; cannot search by email',
            );
            _userModel = null;
          } else {
            // Search in admins by email
            final adminsQuery = await _firestore
                .collection('admins')
                .where('email', isEqualTo: email)
                .limit(1)
                .get();

            if (adminsQuery.docs.isNotEmpty) {
              final data = adminsQuery.docs.first.data();
              print('📝 Found admin document by email: $data');
              _userModel = UserModel.fromJson(data);
              print('✅ Loaded admin from admins collection (by email)');
              print('✅ Parsed role: ${_userModel?.role}');
              print('✅ Parsed status: ${_userModel?.status}');
            } else {
              // If not in admins, search in users by email
              final usersQuery = await _firestore
                  .collection('users')
                  .where('email', isEqualTo: email)
                  .limit(1)
                  .get();

              if (usersQuery.docs.isNotEmpty) {
                final data = usersQuery.docs.first.data();
                print('📝 Found user document by email: $data');
                _userModel = UserModel.fromJson(data);
                print('✅ Loaded user from users collection (by email)');
                print('✅ Parsed role: ${_userModel?.role}');
                print('✅ Parsed status: ${_userModel?.status}');
              } else {
                print(
                  '⚠️ User not found in admins or users collection, even when searching by email',
                );
                _userModel = null;
              }
            }
          }
        }
      }
      notifyListeners();
    } catch (e) {
      print('❌ Error loading user model: $e');
      print('❌ Stack trace: ${StackTrace.current}');
      _userModel = null;
      notifyListeners();
    }
  }

  Future<bool> signUpWithRole({
    required String email,
    required String password,
    required String name,
    required UserRole role,
  }) async {
    try {
      print('🔐 Starting sign up for: $email');
      print('🔐 Role: ${role.toString()}');

      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      final user = userCredential.user;
      if (user == null) throw Exception('User creation failed');

      print('✅ Firebase user created: ${user.uid}');

      await user.updateDisplayName(name);
      print('✅ Display name updated: $name');

      // Generate verification code
      final verificationCode = EmailService.generateVerificationCode();
      _verificationCode = verificationCode;
      _pendingEmail = email;

      print('🔢 Generated verification code: $verificationCode');

      // Send verification email with fallback
      try {
        await EmailService.sendVerificationCode(
          email: email,
          verificationCode: verificationCode,
          userName: name,
        );
      } catch (e) {
        print('⚠️ Email.js failed, using fallback: $e');
        // Show verification code in dialog as fallback
        if (_context != null) {
          FallbackEmailService.showVerificationCodeDialog(
            context: _context!,
            email: email,
            verificationCode: verificationCode,
            userName: name,
          );
        }
      }

      // Create user document in Firestore
      _userModel = UserModel(
        uid: user.uid,
        email: email,
        name: name,
        role: role,
        isEmailVerified: false,
        verificationCode: verificationCode,
        verificationCodeExpiry: DateTime.now().add(const Duration(minutes: 10)),
        createdAt: DateTime.now(),
      );

      print('📝 Creating Firestore document...');

      // Store in appropriate collection based on role
      final collectionName = role == UserRole.admin ? 'admins' : 'users';
      await _firestore
          .collection(collectionName)
          .doc(user.uid)
          .set(_userModel!.toJson());
      print('✅ Firestore document created in $collectionName collection!');

      _user = user;
      
      // Log user account creation
      await AuditService.log(
        action: AuditAction.userAccountCreated,
        description: 'New ${role == UserRole.admin ? 'admin' : 'user'} account created: $name',
        actorId: user.uid,
        actorEmail: email,
        actorName: name,
        actorType: role == UserRole.admin ? 'admin' : 'user',
        metadata: {
          'role': role.toString().split('.').last,
          'createdAt': DateTime.now().toIso8601String(),
        },
      );
      
      _isLoading = false;
      notifyListeners();
      print('✅ Sign up completed successfully!');
      return true;
    } on FirebaseAuthException catch (e) {
      print('❌ Firebase Auth Error: ${e.code} - ${e.message}');
      _errorMessage = _getErrorMessage(e.code);
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      print('❌ General Error during sign up: $e');
      _errorMessage = 'Sign up failed: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> verifyEmail(String code) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      print('🔐 Verifying email with code: $code');
      print('🔐 In-memory verification code: $_verificationCode');
      print('🔐 User model verification code: ${_userModel?.verificationCode}');

      // First, reload user model from Firestore to get latest verification code
      if (_user != null) {
        print('📝 Reloading user model from Firestore...');
        await _loadUserModel();
        print('📝 User model reloaded');
        print(
          '🔐 Updated user model verification code: ${_userModel?.verificationCode}',
        );
      }

      // Check against both in-memory and Firestore stored codes
      final storedCode = _verificationCode ?? _userModel?.verificationCode;

      print('🔐 Final stored code to compare: $storedCode');
      print('🔐 User entered code: $code');

      if (storedCode == null) {
        print('❌ ERROR: No verification code found in system!');
        _errorMessage =
            'Verification code not found. Please request a new one.';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      if (storedCode != code) {
        print('❌ Code mismatch! Expected: $storedCode, Got: $code');
        _errorMessage = 'Invalid verification code';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      print('✅ Code matches!');

      if (_userModel?.verificationCodeExpiry?.isBefore(DateTime.now()) ??
          false) {
        print('❌ Verification code expired');
        _errorMessage = 'Verification code has expired';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      print('✅ Code not expired');

      // Update user in Firestore
      print('📝 Updating Firestore with verified status...');

      // Determine which collection to update based on role
      final collectionName = _userModel?.role == UserRole.admin
          ? 'admins'
          : 'users';

      // Use FieldValue.delete() to remove null fields instead of setting them to null
      await _firestore.collection(collectionName).doc(_user!.uid).update({
        'isEmailVerified': true,
        'verificationCode': FieldValue.delete(),
        'verificationCodeExpiry': FieldValue.delete(),
      });

      // Update local model
      _userModel = _userModel!.copyWith(
        isEmailVerified: true,
        verificationCode: null,
        verificationCodeExpiry: null,
      );

      print('✅ Firestore updated successfully!');

      _verificationCode = null;
      _pendingEmail = null;
      _isLoading = false;
      notifyListeners();

      print('✅ Email verification completed successfully!');
      return true;
    } catch (e) {
      print('❌ Verification error: $e');
      _errorMessage = 'Verification failed: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> signIn({
    required String email,
    required String password,
    bool rememberMe = false,
  }) async {
    try {
      print('🔐 Starting sign in for: $email');
      print('📌 Remember Me: $rememberMe');
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      // 🔒 SECURITY CHECK 1: Check if account is locked
      final isLocked = await SecurityService.isAccountLocked(email);
      if (isLocked) {
        final timeRemaining = await SecurityService.getLockoutTimeRemaining(email);
        final minutes = timeRemaining?.inMinutes ?? 15;
        
        print('🔒 Account is locked');
        _errorMessage = 'Account temporarily locked due to multiple failed login attempts. Please try again in $minutes minutes.';
        
        // Log lockout attempt
        await AuditService.log(
          action: AuditAction.userLoggedIn,
          description: 'Login attempt blocked - account locked: $email',
          actorEmail: email,
          actorName: 'Unknown',
          actorType: 'user',
          category: 'security',
          riskLevel: RiskLevel.high,
          success: false,
          errorMessage: 'Account locked',
          metadata: {
            'reason': 'account_locked',
            'remainingMinutes': minutes,
          },
        );
        
        _isLoading = false;
        notifyListeners();
        return false;
      }

      // 🔒 SECURITY CHECK 2: Check for suspicious activity patterns
      final isSuspicious = await SecurityService.detectSuspiciousActivity(
        email: email,
      );
      
      if (isSuspicious) {
        print('⚠️ Suspicious activity detected');
        await AuditService.log(
          action: AuditAction.systemWarning,
          description: 'Suspicious login pattern detected for: $email',
          actorEmail: email,
          actorName: 'Security Monitor',
          actorType: 'system',
          category: 'security',
          riskLevel: RiskLevel.high,
          metadata: {
            'suspiciousActivity': true,
            'reason': 'rapid_fire_attempts',
          },
        );
      }

      // Attempt Firebase authentication
      final UserCredential userCredential = await _firebaseAuth
          .signInWithEmailAndPassword(email: email, password: password);

      _user = userCredential.user;
      print('✅ Firebase sign in successful: ${_user?.uid}');

      print('📝 Loading user model from Firestore...');
      await _loadUserModel();
      print('📝 User model loaded');
      print('👤 User role: ${_userModel?.role}');
      print('👤 User name: ${_userModel?.name}');
      print('👤 User status: ${_userModel?.status}');
      print('👤 Is admin: ${_userModel?.role == UserRole.admin}');

      // Check if user data exists
      if (_userModel == null) {
        print('⛔ User data not found in Firestore');
        _errorMessage =
            'User account not found. Please contact the administrator.';

        // Record failed attempt (account not found)
        await SecurityService.recordFailedAttempt(
          email: email,
          errorCode: 'user-not-found-in-firestore',
        );

        // Sign out the Firebase user and clear local state
        await _firebaseAuth.signOut();
        _user = null;
        _isLoading = false;
        notifyListeners();
        return false;
      }

      // Block inactive accounts from signing in
      if (_userModel!.status != 'Active') {
        print('⛔ User account is inactive. Status: ${_userModel!.status}');
        _errorMessage =
            'Your account is ${_userModel!.status.toLowerCase()}. Please contact the administrator.';

        // Record failed attempt (inactive account)
        await SecurityService.recordFailedAttempt(
          email: email,
          errorCode: 'account-inactive',
        );

        // Sign out the Firebase user and clear local state
        await _firebaseAuth.signOut();
        _user = null;
        _userModel = null;
        _isLoading = false;
        notifyListeners();
        return false;
      }

      // ✅ SUCCESS - Clear any previous failed attempts
      await SecurityService.recordSuccessfulLogin(email: email);

      // Update last login
      if (_userModel != null) {
        print('📝 Updating last login...');
        _userModel = _userModel!.copyWith(lastLogin: DateTime.now());

        // Update in the correct collection based on role
        final collectionName = _userModel!.role == UserRole.admin
            ? 'admins'
            : 'users';
        await _firestore.collection(collectionName).doc(_user!.uid).update({
          'lastLogin': DateTime.now().toIso8601String(),
        });
        print('✅ Last login updated');
        
        // Log the login action with success
        await AuditService.log(
          action: _userModel!.role == UserRole.admin 
              ? AuditAction.adminLoggedIn 
              : AuditAction.userLoggedIn,
          description: 'Successful login: ${_userModel!.email}',
          actorId: _userModel!.uid,
          actorEmail: _userModel!.email,
          actorName: _userModel!.name,
          actorType: _userModel!.role == UserRole.admin ? 'admin' : 'user',
          category: 'authentication',
          riskLevel: RiskLevel.low,
          success: true,
          metadata: {
            'loginTime': DateTime.now().toIso8601String(),
            'role': _userModel!.role.toString().split('.').last,
          },
        );
      }

      // 💾 Save credentials if Remember Me is enabled
      if (rememberMe && _user != null) {
        await StorageService.saveCredentials(
          email: email,
          userId: _user!.uid,
        );
        await StorageService.setRememberMe(true);
        print('💾 Remember Me: Credentials saved');
      } else {
        // Clear any existing credentials if Remember Me is not checked
        await StorageService.clearCredentials();
        print('🗑️ Remember Me: Credentials cleared');
      }

      _isLoading = false;
      notifyListeners();
      print('✅ Sign in completed successfully');
      return true;
    } on FirebaseAuthException catch (e) {
      print('❌ Firebase Auth Error: ${e.code} - ${e.message}');
      _errorMessage = _getErrorMessage(e.code);
      
      // 🔒 Record failed authentication attempt
      await SecurityService.recordFailedAttempt(
        email: email,
        errorCode: e.code,
      );
      
      // Log failed login attempt
      await AuditService.log(
        action: AuditAction.userLoggedIn,
        description: 'Failed login attempt: $email',
        actorEmail: email,
        actorName: 'Unknown',
        actorType: 'user',
        category: 'authentication',
        riskLevel: RiskLevel.medium,
        success: false,
        errorMessage: e.message,
        metadata: {
          'errorCode': e.code,
          'attemptTime': DateTime.now().toIso8601String(),
        },
      );
      
      // Check if this failure will cause a lockout
      final failedCount = await SecurityService.getFailedAttemptCount(email);
      if (failedCount >= SecurityService.maxFailedAttempts - 1) {
        _errorMessage = _errorMessage! + 
            '\n\nWarning: Account will be locked after ${SecurityService.maxFailedAttempts - failedCount} more failed attempt(s).';
      }
      
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      print('❌ Sign in error: $e');
      _errorMessage = 'An unexpected error occurred';
      
      // Record unexpected error
      await SecurityService.recordFailedAttempt(
        email: email,
        errorCode: 'unexpected-error',
      );
      
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> signOut() async {
    try {
      _isLoading = true;
      notifyListeners();
      
      // Log the logout action before clearing user data
      if (_userModel != null) {
        await AuditService.logUserLogout(_userModel!);
      }
      
      // Clear saved credentials (Remember Me data)
      await StorageService.clearCredentials();
      print('🗑️ Sign out: Cleared saved credentials');
      
      // Sign out from Google if signed in with Google
      try {
        await GoogleSignInService.signOut();
      } catch (e) {
        print('⚠️ Google sign out error (may not be signed in with Google): $e');
      }
      
      await _firebaseAuth.signOut();
      _user = null;
      _userModel = null;
      _verificationCode = null;
      _pendingEmail = null;
      _errorMessage = null;
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _errorMessage = 'Failed to sign out';
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Sign in with Google
  Future<bool> signInWithGoogle({bool rememberMe = false}) async {
    try {
      print('🔐 Starting Google Sign-In...');
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      // Trigger Google Sign-In flow
      final UserCredential? userCredential =
          await GoogleSignInService.signInWithGoogle();

      // If user cancelled
      if (userCredential == null) {
        print('⚠️ Google Sign-In cancelled');
        _errorMessage = 'Google Sign-In was cancelled';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      _user = userCredential.user;
      
      if (_user == null) {
        print('❌ No user returned from Google Sign-In');
        _errorMessage = 'Failed to get user information from Google';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      print('✅ Google Sign-In successful: ${_user!.email}');
      print('   UID: ${_user!.uid}');
      print('   Display Name: ${_user!.displayName}');

      // Check if this is a new user or existing user
      final bool isNewUser = userCredential.additionalUserInfo?.isNewUser ?? false;
      
      if (isNewUser) {
        print('🆕 New user - Creating Firestore document...');
        // Create new user document in Firestore
        await _createGoogleUserDocument();
      } else {
        print('👤 Existing user - Loading from Firestore...');
      }

      // Load user model from Firestore
      await _loadUserModel();

      // If user model doesn't exist, create it
      if (_userModel == null && _user != null) {
        print('⚠️ User model not found - Creating now...');
        await _createGoogleUserDocument();
        await _loadUserModel();
      }

      // Check user status
      if (_userModel != null && _userModel!.status != 'Active') {
        print('⛔ User account is ${_userModel!.status}');
        _errorMessage =
            'Your account is ${_userModel!.status.toLowerCase()}. Please contact the administrator.';
        await signOut();
        _isLoading = false;
        notifyListeners();
        return false;
      }

      // Update last login
      if (_userModel != null) {
        final collectionName = _userModel!.role == UserRole.admin
            ? 'admins'
            : 'users';
        await _firestore.collection(collectionName).doc(_user!.uid).update({
          'lastLogin': DateTime.now().toIso8601String(),
        });

        // Log the login action
        await AuditService.log(
          action: _userModel!.role == UserRole.admin
              ? AuditAction.adminLoggedIn
              : AuditAction.userLoggedIn,
          description: 'Successful Google Sign-In: ${_userModel!.email}',
          actorId: _userModel!.uid,
          actorEmail: _userModel!.email,
          actorName: _userModel!.name,
          actorType: _userModel!.role == UserRole.admin ? 'admin' : 'user',
          category: 'authentication',
          riskLevel: RiskLevel.low,
          success: true,
          metadata: {
            'loginTime': DateTime.now().toIso8601String(),
            'provider': 'google',
            'role': _userModel!.role.toString().split('.').last,
          },
        );
      }

      // Save credentials if Remember Me is enabled
      if (rememberMe && _user != null) {
        await StorageService.saveCredentials(
          email: _user!.email ?? '',
          userId: _user!.uid,
        );
        await StorageService.setRememberMe(true);
        print('💾 Remember Me: Google credentials saved');
      }

      _isLoading = false;
      notifyListeners();
      print('✅ Google Sign-In completed successfully!');
      return true;
    } catch (e) {
      print('❌ Google Sign-In error: $e');
      _errorMessage = 'Failed to sign in with Google: ${e.toString()}';
      
      // Log failed Google sign-in attempt
      await AuditService.log(
        action: AuditAction.userLoggedIn,
        description: 'Failed Google Sign-In attempt',
        actorEmail: _user?.email ?? 'Unknown',
        actorName: 'Unknown',
        actorType: 'user',
        category: 'authentication',
        riskLevel: RiskLevel.medium,
        success: false,
        errorMessage: e.toString(),
        metadata: {
          'provider': 'google',
          'attemptTime': DateTime.now().toIso8601String(),
        },
      );
      
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Sign in with Facebook
  Future<bool> signInWithFacebook({bool rememberMe = false}) async {
    try {
      print('🔐 Starting Facebook Sign-In...');
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      // Trigger Facebook Sign-In flow
      final UserCredential? userCredential =
          await FacebookSignInService.signInWithFacebook();

      // If user cancelled
      if (userCredential == null) {
        print('⚠️ Facebook Sign-In cancelled');
        _errorMessage = 'Facebook Sign-In was cancelled';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      _user = userCredential.user;
      
      if (_user == null) {
        print('❌ No user returned from Facebook Sign-In');
        _errorMessage = 'Failed to get user information from Facebook';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      print('✅ Facebook Sign-In successful: ${_user!.email}');
      print('   UID: ${_user!.uid}');
      print('   Display Name: ${_user!.displayName}');

      // Check if this is a new user or existing user
      final bool isNewUser = userCredential.additionalUserInfo?.isNewUser ?? false;
      
      if (isNewUser) {
        print('🆕 New user - Creating Firestore document...');
        // Create new user document in Firestore
        await _createFacebookUserDocument();
      } else {
        print('👤 Existing user - Loading from Firestore...');
      }

      // Load user model from Firestore
      await _loadUserModel();

      // If user model doesn't exist, create it
      if (_userModel == null && _user != null) {
        print('⚠️ User model not found - Creating now...');
        await _createFacebookUserDocument();
        await _loadUserModel();
      }

      // Check user status
      if (_userModel != null && _userModel!.status != 'Active') {
        print('⛔ User account is ${_userModel!.status}');
        _errorMessage =
            'Your account is ${_userModel!.status.toLowerCase()}. Please contact the administrator.';
        await signOut();
        _isLoading = false;
        notifyListeners();
        return false;
      }

      // Update last login
      if (_userModel != null) {
        final collectionName = _userModel!.role == UserRole.admin
            ? 'admins'
            : 'users';
        await _firestore.collection(collectionName).doc(_user!.uid).update({
          'lastLogin': DateTime.now().toIso8601String(),
        });

        // Log the login action
        await AuditService.log(
          action: _userModel!.role == UserRole.admin
              ? AuditAction.adminLoggedIn
              : AuditAction.userLoggedIn,
          description: 'Successful Facebook Sign-In: ${_userModel!.email}',
          actorId: _userModel!.uid,
          actorEmail: _userModel!.email,
          actorName: _userModel!.name,
          actorType: _userModel!.role == UserRole.admin ? 'admin' : 'user',
          category: 'authentication',
          riskLevel: RiskLevel.low,
          success: true,
          metadata: {
            'loginTime': DateTime.now().toIso8601String(),
            'provider': 'facebook',
            'role': _userModel!.role.toString().split('.').last,
          },
        );
      }

      // Save credentials if Remember Me is enabled
      if (rememberMe && _user != null) {
        await StorageService.saveCredentials(
          email: _user!.email ?? '',
          userId: _user!.uid,
        );
        await StorageService.setRememberMe(true);
        print('💾 Remember Me: Facebook credentials saved');
      }

      _isLoading = false;
      notifyListeners();
      print('✅ Facebook Sign-In completed successfully!');
      return true;
    } catch (e) {
      print('❌ Facebook Sign-In error: $e');
      _errorMessage = 'Failed to sign in with Facebook: ${e.toString()}';
      
      // Log failed Facebook sign-in attempt
      await AuditService.log(
        action: AuditAction.userLoggedIn,
        description: 'Failed Facebook Sign-In attempt',
        actorEmail: _user?.email ?? 'Unknown',
        actorName: 'Unknown',
        actorType: 'user',
        category: 'authentication',
        riskLevel: RiskLevel.medium,
        success: false,
        errorMessage: e.toString(),
        metadata: {
          'provider': 'facebook',
          'attemptTime': DateTime.now().toIso8601String(),
        },
      );
      
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Create Firestore document for Facebook Sign-In user
  Future<void> _createFacebookUserDocument() async {
    if (_user == null) return;

    try {
      print('📝 Creating Firestore document for Facebook user...');

      // Determine role based on email (you can customize this logic)
      final email = _user!.email ?? '';
      final role = _determineRoleFromEmail(email);
      final collection = role == UserRole.admin ? 'admins' : 'users';

      print('📧 Email: $email');
      print('👤 Assigned Role: $role');
      print('📁 Collection: $collection');

      final userData = UserModel(
        uid: _user!.uid,
        email: email,
        name: _user!.displayName ?? 'Facebook User',
        role: role,
        isEmailVerified: _user!.emailVerified,
        createdAt: DateTime.now(),
        lastLogin: DateTime.now(),
        photoUrl: _user!.photoURL,
      );

      // Store in appropriate collection based on role
      await _firestore
          .collection(collection)
          .doc(_user!.uid)
          .set(userData.toJson());

      print('✅ Firestore document created successfully!');

      // Log user account creation
      await AuditService.log(
        action: userData.role == UserRole.admin
            ? AuditAction.userAccountCreated
            : AuditAction.userAccountCreated,
        description: 'New ${userData.role == UserRole.admin ? "admin" : "user"} account created via Facebook Sign-In: ${userData.name}',
        actorId: _user!.uid,
        actorEmail: userData.email,
        actorName: userData.name,
        actorType: userData.role == UserRole.admin ? 'admin' : 'user',
        metadata: {
          'provider': 'facebook',
          'role': userData.role.toString().split('.').last,
          'createdAt': DateTime.now().toIso8601String(),
        },
      );

      _userModel = userData;
    } catch (e) {
      print('❌ Error creating Facebook user document: $e');
      rethrow;
    }
  }

  /// Create Firestore document for Google Sign-In user
  Future<void> _createGoogleUserDocument() async {
    if (_user == null) return;

    try {
      print('📝 Creating Firestore document for Google user...');

      // Determine role based on email (you can customize this logic)
      final email = _user!.email ?? '';
      final role = _determineRoleFromEmail(email);
      final collection = role == UserRole.admin ? 'admins' : 'users';

      print('📧 Email: $email');
      print('👤 Assigned Role: $role');
      print('📁 Collection: $collection');

      final userData = UserModel(
        uid: _user!.uid,
        email: email,
        name: _user!.displayName ?? 'Google User',
        role: role,
        isEmailVerified: _user!.emailVerified,
        createdAt: DateTime.now(),
        lastLogin: DateTime.now(),
        photoUrl: _user!.photoURL,
      );

      // Store in appropriate collection based on role
      await _firestore
          .collection(collection)
          .doc(_user!.uid)
          .set(userData.toJson());

      print('✅ Firestore document created successfully!');

      // Log user account creation
      await AuditService.log(
        action: userData.role == UserRole.admin
            ? AuditAction.userAccountCreated
            : AuditAction.userAccountCreated,
        description: 'New ${userData.role == UserRole.admin ? "admin" : "user"} account created via Google Sign-In: ${userData.name}',
        actorId: _user!.uid,
        actorEmail: userData.email,
        actorName: userData.name,
        actorType: userData.role == UserRole.admin ? 'admin' : 'user',
        metadata: {
          'provider': 'google',
          'role': userData.role.toString().split('.').last,
          'createdAt': DateTime.now().toIso8601String(),
        },
      );

      _userModel = userData;
    } catch (e) {
      print('❌ Error creating Google user document: $e');
      rethrow;
    }
  }

  /// Determine user role based on email address
  /// Customize this method to match your admin email requirements
  UserRole _determineRoleFromEmail(String email) {
    // Option 1: Check specific admin emails
    final adminEmails = [
      'loloypatriabukog123@gmail.com', // Your admin email
      'admin@robocleanerbuddy.com',
      // Add more admin emails here
    ];

    if (adminEmails.contains(email.toLowerCase())) {
      print('✅ Admin email detected: $email');
      return UserRole.admin;
    }

    // Option 2: Check email domain (uncomment if needed)
    // if (email.endsWith('@yourdomain.com')) {
    //   print('✅ Admin domain detected: $email');
    //   return UserRole.admin;
    // }

    // Option 3: Check if email contains 'admin' (uncomment if needed)
    // if (email.toLowerCase().contains('admin')) {
    //   print('✅ Admin keyword detected: $email');
    //   return UserRole.admin;
    // }

    // Default: regular user
    print('👤 Regular user: $email');
    return UserRole.user;
  }

  Future<bool> resetPassword(String email) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      await _firebaseAuth.sendPasswordResetEmail(email: email);

      _isLoading = false;
      notifyListeners();
      return true;
    } on FirebaseAuthException catch (e) {
      _errorMessage = _getErrorMessage(e.code);
      _isLoading = false;
      notifyListeners();
      return false;
    } catch (e) {
      _errorMessage = 'An unexpected error occurred';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Send password reset code to user's email
  Future<bool> sendPasswordResetCode(String email) async {
    try {
      print('🔐 Sending password reset code to: $email');
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      // Check if user exists in Firestore
      bool userExists = false;
      String? userName;
      String? collection;

      // Check in admins collection
      var adminQuery = await _firestore
          .collection('admins')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (adminQuery.docs.isNotEmpty) {
        userExists = true;
        userName = adminQuery.docs.first.data()['name'] ?? 'User';
        collection = 'admins';
      } else {
        // Check in users collection
        var userQuery = await _firestore
            .collection('users')
            .where('email', isEqualTo: email)
            .limit(1)
            .get();

        if (userQuery.docs.isNotEmpty) {
          userExists = true;
          userName = userQuery.docs.first.data()['name'] ?? 'User';
          collection = 'users';
        }
      }

      if (!userExists) {
        print('⚠️ No account found for: $email');
        _errorMessage = 'No account found with this email address.';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      // Generate password reset code
      final resetCode = EmailService.generateVerificationCode();

      print('🔢 Generated password reset code: $resetCode');

      // Send password reset email with fallback
      try {
        await EmailService.sendPasswordResetCode(
          email: email,
          verificationCode: resetCode,
          userName: userName ?? 'User',
        );
      } catch (e) {
        print('⚠️ Email service failed, using fallback: $e');
        // Show verification code in dialog as fallback
        if (_context != null) {
          FallbackEmailService.showPasswordResetCodeDialog(
            context: _context!,
            email: email,
            verificationCode: resetCode,
            userName: userName ?? 'User',
          );
        }
      }

      // Store reset code in Firestore with expiry
      final userQuery = await _firestore
          .collection(collection!)
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (userQuery.docs.isNotEmpty) {
        await _firestore
            .collection(collection)
            .doc(userQuery.docs.first.id)
            .update({
          'passwordResetCode': resetCode,
          'passwordResetCodeExpiry': DateTime.now()
              .add(const Duration(minutes: 15))
              .toIso8601String(),
        });
        print('✅ Password reset code stored in Firestore');
      }

      // Log password reset request
      await AuditService.log(
        action: AuditAction.systemWarning,
        description: 'Password reset requested for: $email',
        actorEmail: email,
        actorName: userName ?? 'Unknown',
        actorType: collection == 'admins' ? 'admin' : 'user',
        category: 'security',
        riskLevel: RiskLevel.medium,
        metadata: {
          'requestTime': DateTime.now().toIso8601String(),
          'codeExpiry': DateTime.now()
              .add(const Duration(minutes: 15))
              .toIso8601String(),
        },
      );

      _isLoading = false;
      notifyListeners();
      print('✅ Password reset code sent successfully!');
      return true;
    } catch (e) {
      print('❌ Error sending password reset code: $e');
      _errorMessage = 'Failed to send password reset code: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Verify password reset code
  Future<bool> verifyPasswordResetCode(String email, String code) async {
    try {
      print('🔐 Verifying password reset code for: $email');
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      // Find user in either collection
      DocumentSnapshot? userDoc;

      // Check admins
      var adminQuery = await _firestore
          .collection('admins')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (adminQuery.docs.isNotEmpty) {
        userDoc = adminQuery.docs.first;
      } else {
        // Check users
        var userQuery = await _firestore
            .collection('users')
            .where('email', isEqualTo: email)
            .limit(1)
            .get();

        if (userQuery.docs.isNotEmpty) {
          userDoc = userQuery.docs.first;
        }
      }

      if (userDoc == null || !userDoc.exists) {
        print('⚠️ User not found');
        _errorMessage = 'User not found.';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      final data = userDoc.data() as Map<String, dynamic>;
      final storedCode = data['passwordResetCode'] as String?;
      final expiryString = data['passwordResetCodeExpiry'] as String?;

      if (storedCode == null) {
        print('⚠️ No password reset code found');
        _errorMessage = 'No password reset request found. Please request a new code.';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      if (storedCode != code) {
        print('❌ Code mismatch');
        _errorMessage = 'Invalid verification code.';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      if (expiryString != null) {
        final expiry = DateTime.parse(expiryString);
        if (expiry.isBefore(DateTime.now())) {
          print('❌ Code expired');
          _errorMessage = 'Verification code has expired. Please request a new one.';
          _isLoading = false;
          notifyListeners();
          return false;
        }
      }

      print('✅ Password reset code verified!');
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      print('❌ Error verifying password reset code: $e');
      _errorMessage = 'Failed to verify code: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Complete password reset by sending Firebase's password reset email
  /// This is called after code verification for added security (2-factor)
  Future<bool> completePasswordReset(String email, String newPassword) async {
    try {
      print('🔐 Completing password reset for: $email');
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      // Find user in either collection
      String? collection;
      DocumentSnapshot? userDoc;

      // Check admins
      var adminQuery = await _firestore
          .collection('admins')
          .where('email', isEqualTo: email)
          .limit(1)
          .get();

      if (adminQuery.docs.isNotEmpty) {
        collection = 'admins';
        userDoc = adminQuery.docs.first;
      } else {
        // Check users
        var userQuery = await _firestore
            .collection('users')
            .where('email', isEqualTo: email)
            .limit(1)
            .get();

        if (userQuery.docs.isNotEmpty) {
          collection = 'users';
          userDoc = userQuery.docs.first;
        }
      }

      if (userDoc == null || !userDoc.exists) {
        print('⚠️ User not found');
        _errorMessage = 'User not found.';
        _isLoading = false;
        notifyListeners();
        return false;
      }

      final data = userDoc.data() as Map<String, dynamic>;

      // Send Firebase's password reset email
      // This provides a secure way to reset the password
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      print('✅ Firebase password reset email sent');

      // Clear reset code from Firestore
      if (collection != null) {
        await _firestore.collection(collection).doc(userDoc.id).update({
          'passwordResetCode': FieldValue.delete(),
          'passwordResetCodeExpiry': FieldValue.delete(),
        });
      }

      // Log successful password reset completion
      await AuditService.log(
        action: AuditAction.systemWarning,
        description: 'Password reset email sent after verification for: $email',
        actorEmail: email,
        actorName: data['name'] ?? 'Unknown',
        actorType: collection == 'admins' ? 'admin' : 'user',
        category: 'security',
        riskLevel: RiskLevel.low,
        success: true,
        metadata: {
          'resetTime': DateTime.now().toIso8601String(),
          'method': 'two_factor_verification',
        },
      );

      _isLoading = false;
      notifyListeners();
      print('✅ Password reset process completed successfully!');
      return true;
    } catch (e) {
      print('❌ Error completing password reset: $e');
      _errorMessage = 'Failed to send password reset email: ${e.toString()}';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> resendVerificationCode(String email, String name) async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final verificationCode = EmailService.generateVerificationCode();
      _verificationCode = verificationCode;

      print('🔄 Resending verification code: $verificationCode');

      // Send verification email with fallback
      try {
        await EmailService.sendVerificationCode(
          email: email,
          verificationCode: verificationCode,
          userName: name,
        );
      } catch (e) {
        print('⚠️ Email.js failed for resend, using fallback: $e');
        // Show verification code in dialog as fallback
        if (_context != null) {
          FallbackEmailService.showVerificationCodeDialog(
            context: _context!,
            email: email,
            verificationCode: verificationCode,
            userName: name,
          );
        }
      }

      // Update Firestore with new verification code
      if (_user != null) {
        print('📝 Updating Firestore with new verification code...');

        // Determine which collection to update based on role
        final collectionName = _userModel?.role == UserRole.admin
            ? 'admins'
            : 'users';

        await _firestore.collection(collectionName).doc(_user!.uid).update({
          'verificationCode': verificationCode,
          'verificationCodeExpiry': DateTime.now()
              .add(const Duration(minutes: 10))
              .toIso8601String(),
        });
        print('✅ Firestore updated with new code');

        // Update local model
        _userModel = _userModel?.copyWith(
          verificationCode: verificationCode,
          verificationCodeExpiry: DateTime.now().add(
            const Duration(minutes: 10),
          ),
        );
      }

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      print('❌ Error resending verification code: $e');
      _errorMessage = 'Failed to resend verification code: $e';
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  String _getErrorMessage(String code) {
    switch (code) {
      case 'weak-password':
        return 'The password provided is too weak.';
      case 'email-already-in-use':
        return 'An account already exists for that email.';
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'operation-not-allowed':
        return 'Email/password accounts are not enabled.';
      case 'user-disabled':
        return 'The user account has been disabled.';
      case 'user-not-found':
        return 'No account found for that email.';
      case 'wrong-password':
        return 'The password is incorrect.';
      case 'invalid-credential':
        return 'The email or password is incorrect.';
      default:
        return 'An error occurred. Please try again.';
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  /// Recover admin account by recreating Firestore document
  Future<bool> recoverAdminAccount({
    required String uid,
    required String email,
    required String name,
  }) async {
    try {
      print('🔄 Recovering admin account...');
      print('   UID: $uid');
      print('   Email: $email');
      print('   Name: $name');

      final adminData = {
        'uid': uid,
        'email': email,
        'name': name,
        'role': 'admin',
        'isEmailVerified': true,
        'createdAt': DateTime.now().toIso8601String(),
        'lastLogin': DateTime.now().toIso8601String(),
      };

      await _firestore.collection('admins').doc(uid).set(adminData);
      print('✅ Admin account recovered successfully!');

      // Reload user model
      await _loadUserModel();
      notifyListeners();
      return true;
    } catch (e) {
      print('❌ Error recovering admin account: $e');
      _errorMessage = 'Failed to recover admin account: $e';
      notifyListeners();
      return false;
    }
  }

  /// Reload user model from Firestore (useful after role/status changes)
  Future<void> reloadUserModel() async {
    await _loadUserModel();
    notifyListeners();
  }

  /// Update user profile name
  Future<Map<String, dynamic>> updateProfileName(String newName) async {
    if (_user == null || _userModel == null) {
      return {
        'success': false,
        'error': 'User not authenticated',
      };
    }

    try {
      _isLoading = true;
      notifyListeners();

      final result = await UserProfileService.updateUserName(
        userId: _user!.uid,
        newName: newName,
        isAdmin: isAdmin,
      );

      if (result['success'] == true) {
        // Reload user model to get updated data
        await _loadUserModel();
        notifyListeners();
      }

      _isLoading = false;
      notifyListeners();
      return result;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }

  /// Update user profile email
  Future<Map<String, dynamic>> updateProfileEmail(String newEmail) async {
    if (_user == null || _userModel == null) {
      return {
        'success': false,
        'error': 'User not authenticated',
      };
    }

    try {
      _isLoading = true;
      notifyListeners();

      final result = await UserProfileService.updateUserEmail(
        userId: _user!.uid,
        newEmail: newEmail,
        isAdmin: isAdmin,
      );

      if (result['success'] == true) {
        // Reload user model to get updated data
        await _loadUserModel();
        notifyListeners();
      }

      _isLoading = false;
      notifyListeners();
      return result;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }

  /// Update user password
  Future<Map<String, dynamic>> updatePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    if (_user == null) {
      return {
        'success': false,
        'error': 'User not authenticated',
      };
    }

    try {
      _isLoading = true;
      notifyListeners();

      final result = await UserProfileService.updateUserPassword(
        userId: _user!.uid,
        currentPassword: currentPassword,
        newPassword: newPassword,
      );

      _isLoading = false;
      notifyListeners();
      return result;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }

  /// Update user profile photo URL
  Future<Map<String, dynamic>> updateProfilePhotoUrl(String photoUrl) async {
    if (_user == null || _userModel == null) {
      return {
        'success': false,
        'error': 'User not authenticated',
      };
    }

    try {
      _isLoading = true;
      notifyListeners();

      final result = await UserProfileService.updateUserPhotoUrl(
        userId: _user!.uid,
        photoUrl: photoUrl,
        isAdmin: isAdmin,
      );

      if (result['success'] == true) {
        // Reload user model to get updated data
        await _loadUserModel();
        notifyListeners();
      }

      _isLoading = false;
      notifyListeners();
      return result;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
      return {
        'success': false,
        'error': e.toString(),
      };
    }
  }
}
