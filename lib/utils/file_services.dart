// lib/services/file_service.dart
import 'dart:io';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime/mime.dart';
import 'package:chatbot/utils/cloudinary_service.dart';

class FileService {
  // Pick any file
  static Future<File?> pickFile() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: false,
      type: FileType.any,
    );

    if (result != null && result.files.single.path != null) {
      return File(result.files.single.path!);
    }
    return null;
  }

  // Pick image from gallery
  static Future<File?> pickImageFromGallery() async {
    final pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      return File(pickedImage.path);
    }
    return null;
  }

  // Upload file to Cloudinary
  static Future<String?> uploadFileToCloudinary(File file) async {
    try {
      final response = await CloudinaryService.uploadFile(file.path);
      return response.secureUrl;
    } catch (e) {
      debugPrint("Error uploading file: $e");
      return null;
    }
  }

  // Get MIME type of a file
  static String? getMimeType(File file) {
    return lookupMimeType(file.path);
  }

  // Read file as bytes
  static Future<Uint8List> readFileAsBytes(File file) async {
    return await file.readAsBytes();
  }

  // Check if file is an image
  static bool isImage(File file) {
    final path = file.path.toLowerCase();
    return path.endsWith('.png') || path.endsWith('.jpg') || path.endsWith('.jpeg');
  }
}