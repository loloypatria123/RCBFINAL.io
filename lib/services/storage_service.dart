import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Service for handling persistent storage of user preferences and credentials
class StorageService {
  static const String _keyRememberMe = 'remember_me';
  static const String _keyUserEmail = 'user_email';
  static const String _keyUserId = 'user_id';
  static const String _keyAutoLogin = 'auto_login';

  // Secure storage for sensitive data
  static const FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  /// Save remember me preference
  static Future<void> setRememberMe(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyRememberMe, value);
  }

  /// Get remember me preference
  static Future<bool> getRememberMe() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyRememberMe) ?? false;
  }

  /// Save user email for auto-fill
  static Future<void> saveUserEmail(String email) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUserEmail, email);
  }

  /// Get saved user email
  static Future<String?> getUserEmail() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUserEmail);
  }

  /// Save user ID for auto-login
  static Future<void> saveUserId(String userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyUserId, userId);
  }

  /// Get saved user ID
  static Future<String?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUserId);
  }

  /// Enable auto-login
  static Future<void> setAutoLogin(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyAutoLogin, value);
  }

  /// Check if auto-login is enabled
  static Future<bool> isAutoLoginEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyAutoLogin) ?? false;
  }

  /// Save user credentials securely (for remember me)
  static Future<void> saveCredentials({
    required String email,
    required String userId,
  }) async {
    await saveUserEmail(email);
    await saveUserId(userId);
    await setAutoLogin(true);
    print('✅ Credentials saved for auto-login');
  }

  /// Clear all saved credentials and preferences
  static Future<void> clearCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyUserEmail);
    await prefs.remove(_keyUserId);
    await prefs.remove(_keyAutoLogin);
    await prefs.remove(_keyRememberMe);
    print('✅ Credentials cleared');
  }

  /// Clear all stored data
  static Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    await _secureStorage.deleteAll();
    print('✅ All storage cleared');
  }

  /// Check if user has saved credentials
  static Future<bool> hasStoredCredentials() async {
    final email = await getUserEmail();
    final userId = await getUserId();
    final autoLogin = await isAutoLoginEnabled();
    return email != null && userId != null && autoLogin;
  }

  /// Get stored credentials
  static Future<Map<String, String>?> getStoredCredentials() async {
    final email = await getUserEmail();
    final userId = await getUserId();
    
    if (email != null && userId != null) {
      return {
        'email': email,
        'userId': userId,
      };
    }
    return null;
  }
}

