import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';

class MediaUploadService {
  // TODO: Replace with your Cloudinary credentials
  // Get these from your Cloudinary Dashboard: https://cloudinary.com/console
  static const String _cloudName = 'dlq3h84oy';
  static const String _uploadPreset =
      'maidconnect'; // Ensure this is "unsigned"

  static final ImagePicker _picker = ImagePicker();

  /// Picks an image from the gallery
  static Future<XFile?> pickImage() async {
    return await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70, // Compress for better performance
    );
  }

  /// Picks a document (PDF, JPG, PNG)
  static Future<PlatformFile?> pickDocument() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
    );
    return result?.files.single;
  }

  /// Uploads a file to Cloudinary and returns the URL.
  /// Works for both mobile (File) and Web (Bytes).
  static Future<String?> uploadToCloudinary({
    XFile? xFile,
    PlatformFile? platformFile,
  }) async {
    try {
      final url = Uri.parse(
        'https://api.cloudinary.com/v1_1/$_cloudName/upload',
      );
      final request = http.MultipartRequest('POST', url);

      request.fields['upload_preset'] = _uploadPreset;

      if (kIsWeb) {
        // Web handling
        final bytes = xFile != null
            ? await xFile.readAsBytes()
            : platformFile?.bytes;

        if (bytes == null) return null;

        final filename = xFile?.name ?? platformFile?.name ?? 'upload';
        request.files.add(
          http.MultipartFile.fromBytes('file', bytes, filename: filename),
        );
      } else {
        // Mobile/Desktop handling
        final path = xFile?.path ?? platformFile?.path;
        if (path == null) return null;

        request.files.add(await http.MultipartFile.fromPath('file', path));
      }

      final response = await request.send();
      final responseData = await response.stream.toBytes();
      final responseString = String.fromCharCodes(responseData);

      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(responseString);
        return jsonResponse['secure_url'] as String;
      } else {
        debugPrint(
          'Cloudinary Upload Error: ${response.statusCode} - $responseString',
        );
        return null;
      }
    } catch (e) {
      debugPrint('MediaUploadService Error: $e');
      return null;
    }
  }
}
