/// Stub for export service on non-web platforms
/// This file is used when export_service_web is not available (Android, iOS)
class ExportServiceWeb {
  /// Download CSV file - stub implementation for mobile
  static void downloadCSV(String csvContent, String filename) {
    print('⚠️ CSV download is only available on web platform');
    print('   Use file_picker or share package for mobile downloads');
    // On mobile, you would typically use packages like:
    // - file_picker: to let user choose save location
    // - share_plus: to share the file
    // - path_provider: to save to app directory
  }
}

