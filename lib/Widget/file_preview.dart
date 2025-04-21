// lib/widgets/file_preview.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FilePreview extends StatelessWidget {
  final File file;
  final VoidCallback onRemove;

  const FilePreview({
    Key? key,
    required this.file,
    required this.onRemove,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;
    final isImage = file.path.toLowerCase().endsWith('.png') ||
                     file.path.toLowerCase().endsWith('.jpg') ||
                     file.path.toLowerCase().endsWith('.jpeg');

    return Stack(
      children: [
        Container(
          width: mq.width * 0.5,
          height: mq.height * 0.15,
          margin: const EdgeInsets.only(bottom: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.deepPurple),
            image: isImage
                ? DecorationImage(
                    image: FileImage(file),
                    fit: BoxFit.cover,
                  )
                : null,
            color: Colors.grey.shade200,
          ),
          child: !isImage
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      file.path.split('/').last,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      style: GoogleFonts.publicSans(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                )
              : null,
        ),
        Positioned(
          right: 0,
          child: GestureDetector(
            onTap: onRemove,
            child: Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.redAccent,
              ),
              child: const Icon(
                Icons.close,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ),
      ],
    );
  }
}