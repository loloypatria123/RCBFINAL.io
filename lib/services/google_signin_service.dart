import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

/// Service for handling Google Sign-In authentication
class GoogleSignInService {
  // Initialize Google Sign-In with required scopes
  static final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: [
      'email',
      'profile',
    ],
  );

  static final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  /// Sign in with Google
  /// Returns UserCredential if successful, null if cancelled or failed
  static Future<UserCredential?> signInWithGoogle() async {
    try {
      print('🔐 Starting Google Sign-In...');

      // Trigger the Google Sign-In flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      // If user cancels the sign-in
      if (googleUser == null) {
        print('⚠️ Google Sign-In cancelled by user');
        return null;
      }

      print('✅ Google account selected: ${googleUser.email}');

      // Obtain auth details from the request
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      print('🔑 Obtained Google authentication tokens');

      // Create a new credential for Firebase
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      print('🔥 Signing in to Firebase with Google credentials...');

      // Sign in to Firebase with the Google credential
      final UserCredential userCredential =
          await _firebaseAuth.signInWithCredential(credential);

      print('✅ Firebase sign-in successful!');
      print('   User: ${userCredential.user?.email}');
      print('   Display Name: ${userCredential.user?.displayName}');
      print('   Photo URL: ${userCredential.user?.photoURL}');

      return userCredential;
    } catch (e) {
      print('❌ Error during Google Sign-In: $e');
      rethrow;
    }
  }

  /// Sign out from Google
  static Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      print('✅ Signed out from Google');
    } catch (e) {
      print('❌ Error signing out from Google: $e');
      rethrow;
    }
  }

  /// Check if user is currently signed in with Google
  static Future<bool> isSignedIn() async {
    try {
      return await _googleSignIn.isSignedIn();
    } catch (e) {
      print('❌ Error checking Google sign-in status: $e');
      return false;
    }
  }

  /// Get the current Google user if signed in
  static Future<GoogleSignInAccount?> getCurrentUser() async {
    try {
      return _googleSignIn.currentUser;
    } catch (e) {
      print('❌ Error getting current Google user: $e');
      return null;
    }
  }

  /// Disconnect Google account (revokes access)
  static Future<void> disconnect() async {
    try {
      await _googleSignIn.disconnect();
      print('✅ Disconnected from Google');
    } catch (e) {
      print('❌ Error disconnecting from Google: $e');
      rethrow;
    }
  }

  /// Silent sign-in (attempts to sign in without user interaction)
  /// Returns UserCredential if successful, null otherwise
  static Future<UserCredential?> signInSilently() async {
    try {
      print('🔐 Attempting silent Google Sign-In...');

      final GoogleSignInAccount? googleUser =
          await _googleSignIn.signInSilently();

      if (googleUser == null) {
        print('⚠️ Silent sign-in not available');
        return null;
      }

      print('✅ Silent sign-in successful: ${googleUser.email}');

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await _firebaseAuth.signInWithCredential(credential);

      print('✅ Firebase silent sign-in successful!');
      return userCredential;
    } catch (e) {
      print('❌ Error during silent Google Sign-In: $e');
      return null;
    }
  }

  /// Get user's Google profile information
  static Future<Map<String, dynamic>?> getUserProfile() async {
    try {
      final GoogleSignInAccount? user = _googleSignIn.currentUser;
      if (user == null) return null;

      return {
        'email': user.email,
        'displayName': user.displayName,
        'photoUrl': user.photoUrl,
        'id': user.id,
      };
    } catch (e) {
      print('❌ Error getting user profile: $e');
      return null;
    }
  }
}

