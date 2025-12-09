import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:path/path.dart' as path;

/// Service for handling Supabase Storage operations
class SupabaseStorageService {
  static final SupabaseClient _supabase = Supabase.instance.client;

  /// Upload profile image to Supabase Storage
  /// Returns the public URL of the uploaded image
  static Future<Map<String, dynamic>> uploadProfileImage({
    required String userId,
    required File imageFile,
    required bool isAdmin,
  }) async {
    try {
      // Validate file size (max 5MB)
      final fileSize = await imageFile.length();
      if (fileSize > 5 * 1024 * 1024) {
        return {
          'success': false,
          'error': 'Image size must be less than 5MB',
        };
      }

      // Validate file type
      final extension = path.extension(imageFile.path).toLowerCase();
      if (!['.jpg', '.jpeg', '.png', '.webp'].contains(extension)) {
        return {
          'success': false,
          'error': 'Only JPG, PNG, and WebP images are allowed',
        };
      }

      // Create file path in storage
      final folder = isAdmin ? 'admin-profiles' : 'user-profiles';
      final fileName = '$userId${DateTime.now().millisecondsSinceEpoch}$extension';
      final filePath = '$folder/$fileName';

      // Read file bytes
      final fileBytes = await imageFile.readAsBytes();

      // Upload to Supabase Storage
      await _supabase.storage.from('profile-images').uploadBinary(
        filePath,
        fileBytes,
        fileOptions: FileOptions(
          upsert: true,
          contentType: 'image/jpeg',
        ),
      );

      // Get public URL
      final publicUrl = _supabase.storage.from('profile-images').getPublicUrl(filePath);

      print('✅ Profile image uploaded successfully: $publicUrl');
      return {
        'success': true,
        'url': publicUrl,
        'message': 'Profile image uploaded successfully',
      };
    } catch (e) {
      print('❌ Error uploading profile image: $e');
      return {
        'success': false,
        'error': 'Failed to upload image: ${e.toString()}',
      };
    }
  }

  /// Delete profile image from Supabase Storage
  static Future<Map<String, dynamic>> deleteProfileImage({
    required String userId,
    required bool isAdmin,
  }) async {
    try {
      final folder = isAdmin ? 'admin-profiles' : 'user-profiles';
      
      // List files in user's folder
      final files = await _supabase.storage
          .from('profile-images')
          .list(path: folder);

      // Find and delete user's profile images
      for (final file in files) {
        if (file.name.startsWith(userId)) {
          await _supabase.storage
              .from('profile-images')
              .remove(['$folder/${file.name}']);
        }
      }

      print('✅ Profile image deleted successfully');
      return {
        'success': true,
        'message': 'Profile image deleted successfully',
      };
    } catch (e) {
      print('❌ Error deleting profile image: $e');
      return {
        'success': false,
        'error': 'Failed to delete image: ${e.toString()}',
      };
    }
  }

  /// Get public URL for profile image
  static String? getProfileImageUrl(String? imagePath) {
    if (imagePath == null || imagePath.isEmpty) {
      return null;
    }
    
    try {
      return _supabase.storage.from('profile-images').getPublicUrl(imagePath);
    } catch (e) {
      print('❌ Error getting profile image URL: $e');
      return null;
    }
  }
}

