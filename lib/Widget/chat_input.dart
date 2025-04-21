// lib/widgets/chat_input.dart
import 'dart:io';
import 'package:chatbot/Widget/file_preview.dart';
import 'package:chatbot/utils/file_services.dart';
import 'package:flutter/material.dart';
import 'package:chatbot/helper/comanborder.dart';

class ChatInput extends StatefulWidget {
  final TextEditingController controller;
  final Function(String text, File? file) onSend;
  final Function(String) onPromptSelected;

  const ChatInput({
    Key? key,
    required this.controller,
    required this.onSend,
    required this.onPromptSelected,
  }) : super(key: key);

  @override
  State<ChatInput> createState() => _ChatInputState();
}

class _ChatInputState extends State<ChatInput> {
  File? selectedFile;

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context).size;

    return AnimatedPadding(
      duration: const Duration(milliseconds: 1),
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: mq.width * 0.03, vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (selectedFile != null)
                FilePreview(
                  file: selectedFile!,
                  onRemove: () {
                    setState(() => selectedFile = null);
                  },
                ),
              Row(
                children: [
                  IconButton.filled(
                    color: Colors.black,
                    style: IconButton.styleFrom(backgroundColor: Colors.white),
                    onPressed: () {
                      _pickImageFromGallery();
                    },
                    icon: Icon(Icons.add, size: mq.width * 0.075),
                  ),
                  SizedBox(width: mq.width * 0.02),
                  Expanded(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxHeight: mq.height * 0.18),
                      child: TextFormField(
                        controller: widget.controller,
                        minLines: 1,
                        maxLines: 500,
                        keyboardType: TextInputType.multiline,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          border: InputBorder.none,
                          enabledBorder: commonBorder,
                          focusedBorder: commonBorder,
                          suffixIcon: IconButton(
                            padding: EdgeInsets.zero,
                            style: const ButtonStyle(
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            splashRadius: 2,
                            onPressed: () {
                              _sendMessage();
                            },
                            icon: const Icon(Icons.arrow_upward_outlined),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _pickImageFromGallery() async {
    final pickedFile = await FileService.pickImageFromGallery();
    if (pickedFile != null) {
      setState(() {
        selectedFile = pickedFile;
      });
    }
  }

  void _sendMessage() {
    if (widget.controller.text.isNotEmpty || selectedFile != null) {
      final text = widget.controller.text.trim();
      final file = selectedFile;
      
      widget.controller.clear();
      setState(() {
        selectedFile = null;
      });
      
      widget.onSend(text, file);
    }
  }
}