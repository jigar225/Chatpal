// lib/services/ai_service.dart
import 'dart:io';
import 'package:chatbot/utils/file_services.dart';

import 'package:flutter/material.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:chatbot/API/apis.dart';
import 'package:chatbot/helper/chatmeesage.dart';

class AIService {
  // Generate full response from Gemini (non-streaming)
  static Future<String?> generateResponse(List<Chatmeesage> messages,
      String currentUserText, File? currentFile) async {
    try {
      // Prepare the content for Gemini including chat history
      List<Content> content = [];

      // Add previous messages to maintain context
      for (var msg in messages) {
        if (msg.fileUrl != null && msg.fileUrl!.startsWith('http')) {
          // Past uploaded images (Cloudinary URLs)
          content.add(Content.multi([
            if (msg.text.isNotEmpty) TextPart(msg.text),
            TextPart("Image URL: ${msg.fileUrl}"),
          ]));
        } else if (msg.fileUrl == null) {
          // Past text-only messages
          content.add(Content.text(msg.text));
        }
      }

      // Add current message with image data if present
      if (currentFile != null) {
        final mimeType = FileService.getMimeType(currentFile);
        final fileBytes = await FileService.readFileAsBytes(currentFile);

        content.add(Content.multi([
          if (currentUserText.isNotEmpty) TextPart(currentUserText),
          DataPart(mimeType ?? 'image/jpeg', fileBytes),
        ]));
      } else {
        // Current text-only message
        content.add(Content.text(currentUserText));
      }

      // Get response from Gemini
      final response = await Apis.geminiVersion.generateContent(content);
      return response.text;
    } catch (e) {
      debugPrint("Error in generateContent: $e");
      return "Error: $e";
    }
  }

  // Generate streaming response from Gemini
  static Stream<String> generateResponseStream(List<Chatmeesage> messages,
      String currentUserText, File? currentFile) async* {
    try {
      // Prepare the content for Gemini including chat history
      List<Content> content = [];

      for (var msg in messages) {
        if (msg.fileUrl != null && msg.fileUrl!.startsWith('http')) {
          content.add(Content.multi([
            if (msg.text.isNotEmpty) TextPart(msg.text),
            TextPart("Image URL: ${msg.fileUrl}"),
          ]));
        } else if (msg.fileUrl == null) {
          content.add(Content.text(msg.text));
        }
      }

      if (currentFile != null) {
        final mimeType = FileService.getMimeType(currentFile);
        final fileBytes = await FileService.readFileAsBytes(currentFile);

        content.add(Content.multi([
          if (currentUserText.isNotEmpty) TextPart(currentUserText),
          DataPart(mimeType ?? 'image/jpeg', fileBytes),
        ]));
      } else {
        content.add(Content.text(currentUserText));
      }

      final buffer = StringBuffer();
      final stream = Apis.geminiVersion.generateContentStream(content);

      await for (final response in stream) {
        final part = response.text;
        if (part != null && part.isNotEmpty) {
          buffer.write(part);
          yield buffer.toString();
        }
      }
    } catch (e) {
      debugPrint("Error in generateContentStream: $e");
      yield "Error: $e";
    }
  }
}
