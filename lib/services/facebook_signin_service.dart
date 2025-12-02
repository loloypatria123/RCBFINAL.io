import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

/// Service for handling Facebook Sign-In authentication
class FacebookSignInService {
  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  /// Sign in with Facebook
  /// Returns UserCredential if successful, null if cancelled or failed
  static Future<UserCredential?> signInWithFacebook() async {
    try {
      print('🔐 Starting Facebook Sign-In...');
      print('🌐 Platform: ${kIsWeb ? "Web" : "Mobile"}');

      // For web, flutter_facebook_auth should work, but we need to ensure proper configuration
      if (kIsWeb) {
        print('🌐 Using Facebook authentication on web platform...');
        print('⚠️ Make sure Website platform is added in Facebook Console');
        print('⚠️ Make sure OAuth Redirect URI is configured');
      }

      // For mobile platforms, use the standard method
      // Note: 'email' permission is deprecated, use only 'public_profile'
      // Email can be retrieved through Graph API after authentication
      final LoginResult loginResult = await FacebookAuth.instance.login(
        permissions: ['public_profile'],
      );

      // Check the status of the login
      if (loginResult.status == LoginStatus.success) {
        print('✅ Facebook login successful');

        // Get the access token
        final AccessToken accessToken = loginResult.accessToken!;
        print('🔑 Obtained Facebook access token');

        // Get user data from Facebook
        final userData = await FacebookAuth.instance.getUserData(
          fields: "name,email,picture.width(200)",
        );

        print('👤 Facebook user data:');
        print('   Name: ${userData['name']}');
        print('   Email: ${userData['email']}');
        print('   Picture: ${userData['picture']?['data']?['url']}');

        // Create a credential for Firebase
        final OAuthCredential credential = FacebookAuthProvider.credential(
          accessToken.tokenString,
        );

        print('🔥 Signing in to Firebase with Facebook credentials...');

        // Sign in to Firebase with the Facebook credential
        final UserCredential userCredential =
            await _firebaseAuth.signInWithCredential(credential);

        print('✅ Firebase sign-in successful!');
        print('   User: ${userCredential.user?.email}');
        print('   Display Name: ${userCredential.user?.displayName}');
        print('   Photo URL: ${userCredential.user?.photoURL}');

        return userCredential;
      } else if (loginResult.status == LoginStatus.cancelled) {
        print('⚠️ Facebook Sign-In cancelled by user');
        return null;
      } else {
        print('❌ Facebook Sign-In failed: ${loginResult.status}');
        print('   Message: ${loginResult.message}');
        return null;
      }
    } catch (e) {
      print('❌ Error during Facebook Sign-In: $e');
      rethrow;
    }
  }

  /// Sign out from Facebook
  static Future<void> signOut() async {
    try {
      await FacebookAuth.instance.logOut();
      print('✅ Signed out from Facebook');
    } catch (e) {
      print('❌ Error signing out from Facebook: $e');
      rethrow;
    }
  }

  /// Check if user is currently logged in with Facebook
  static Future<bool> isLoggedIn() async {
    try {
      final accessToken = await FacebookAuth.instance.accessToken;
      return accessToken != null;
    } catch (e) {
      print('❌ Error checking Facebook login status: $e');
      return false;
    }
  }

  /// Get the current Facebook access token
  static Future<AccessToken?> getAccessToken() async {
    try {
      return await FacebookAuth.instance.accessToken;
    } catch (e) {
      print('❌ Error getting Facebook access token: $e');
      return null;
    }
  }

  /// Get user's Facebook profile information
  static Future<Map<String, dynamic>?> getUserProfile() async {
    try {
      final isLoggedIn = await FacebookAuth.instance.accessToken != null;
      if (!isLoggedIn) return null;

      final userData = await FacebookAuth.instance.getUserData(
        fields: "name,email,picture.width(200),first_name,last_name",
      );

      return {
        'email': userData['email'],
        'displayName': userData['name'],
        'firstName': userData['first_name'],
        'lastName': userData['last_name'],
        'photoUrl': userData['picture']?['data']?['url'],
        'id': userData['id'],
      };
    } catch (e) {
      print('❌ Error getting user profile: $e');
      return null;
    }
  }

  /// Get Facebook user data with custom fields
  static Future<Map<String, dynamic>?> getUserData({
    String fields = "name,email,picture.width(200)",
  }) async {
    try {
      final isLoggedIn = await FacebookAuth.instance.accessToken != null;
      if (!isLoggedIn) {
        print('⚠️ User not logged in with Facebook');
        return null;
      }

      return await FacebookAuth.instance.getUserData(fields: fields);
    } catch (e) {
      print('❌ Error getting Facebook user data: $e');
      return null;
    }
  }
}

