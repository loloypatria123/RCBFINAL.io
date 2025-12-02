import 'package:flutter/material.dart';
import '../services/storage_service.dart';

class UIProvider extends ChangeNotifier {
  bool _rememberMe = false;
  bool _agreeToTerms = false;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isDarkMode = true;
  String _selectedLanguage = 'English';

  UIProvider() {
    _loadSavedPreferences();
  }

  /// Load saved preferences from storage
  Future<void> _loadSavedPreferences() async {
    try {
      _rememberMe = await StorageService.getRememberMe();
      notifyListeners();
    } catch (e) {
      print('⚠️ Error loading preferences: $e');
    }
  }

  bool get rememberMe => _rememberMe;
  bool get agreeToTerms => _agreeToTerms;
  bool get obscurePassword => _obscurePassword;
  bool get obscureConfirmPassword => _obscureConfirmPassword;
  bool get isDarkMode => _isDarkMode;
  String get selectedLanguage => _selectedLanguage;

  void toggleRememberMe() {
    _rememberMe = !_rememberMe;
    notifyListeners();
  }

  void toggleAgreeToTerms() {
    _agreeToTerms = !_agreeToTerms;
    notifyListeners();
  }

  void toggleObscurePassword() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  void toggleObscureConfirmPassword() {
    _obscureConfirmPassword = !_obscureConfirmPassword;
    notifyListeners();
  }

  void setRememberMe(bool value) {
    _rememberMe = value;
    StorageService.setRememberMe(value); // Save to storage
    notifyListeners();
  }

  void setAgreeToTerms(bool value) {
    _agreeToTerms = value;
    notifyListeners();
  }

  void setObscurePassword(bool value) {
    _obscurePassword = value;
    notifyListeners();
  }

  void setDarkMode(bool value) {
    _isDarkMode = value;
    notifyListeners();
  }

  void setSelectedLanguage(String value) {
    _selectedLanguage = value;
    notifyListeners();
  }

  void reset() {
    _rememberMe = false;
    _agreeToTerms = false;
    _obscurePassword = true;
    _obscureConfirmPassword = true;
    _isDarkMode = true;
    _selectedLanguage = 'English';
    notifyListeners();
  }
}
