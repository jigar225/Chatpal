import 'dart:io';
import 'package:chatbot/helper/chatmeesage.dart';
import 'package:chatbot/helper/global.dart';
import 'package:flutter/material.dart';
import 'package:gpt_markdown/gpt_markdown.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class ChatStart extends StatelessWidget {
  final ScrollController _scrollController;
  final List<Chatmeesage> messages;
  final bool _isLoading;

  const ChatStart({
    super.key,
    required ScrollController scrollController,
    required this.messages,
    required bool isLoading,
  })  : _scrollController = scrollController,
        _isLoading = isLoading;

  bool _isImage(String url) {
    return url.endsWith('.png') ||
        url.endsWith('.jpg') ||
        url.endsWith('.jpeg') ||
        url.startsWith('http');
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      controller: _scrollController,
      itemCount: messages.length + (_isLoading ? 1 : 0),
      itemBuilder: (context, index) {
        if (index < messages.length) {
          Chatmeesage msg = messages[index];
          return Align(
            alignment:
                msg.isUser ? Alignment.centerRight : Alignment.centerLeft,
            child: Padding(
              padding: EdgeInsets.symmetric(
                vertical: 4,
                horizontal: mq.width * 0.03,
              ),
              child: Column(
                crossAxisAlignment: msg.isUser
                    ? CrossAxisAlignment.end
                    : CrossAxisAlignment.start,
                children: [
                  // Display image separately if available
                  if (msg.fileUrl != null && _isImage(msg.fileUrl!))
                    Container(
                      margin: const EdgeInsets.only(bottom: 6),
                      constraints: BoxConstraints(
                        maxWidth: mq.width * 0.6,
                        maxHeight: mq.height * 0.25,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: msg.fileUrl!.startsWith('http')
                            ? Image.network(
                                msg.fileUrl!,
                                fit: BoxFit.cover,
                              )
                            : Image.file(
                                File(msg.fileUrl!),
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),

                  // Display text separately
                  if (msg.text.isNotEmpty)
                    Container(
                      // User messages stay as bubbles; AI messages stretch full width
                      constraints: BoxConstraints(
                        maxWidth: msg.isUser ? mq.width * 0.7 : mq.width,
                      ),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color:
                            msg.isUser ? Colors.deepPurple : Colors.transparent,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: SelectionArea(
                        child: GptMarkdown(
                          msg.text,
                          useDollarSignsForLatex: true,
                          style: TextStyle(
                            fontSize: 14,
                            height: 1.4,
                            color: msg.isUser ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        } else {
          return Align(
            alignment: Alignment.centerLeft,
            child: Container(
              width: mq.width * 0.2,
              margin: EdgeInsets.symmetric(
                vertical: 4,
                horizontal: mq.width * 0.03,
              ),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
              ),
              child: const SpinKitThreeBounce(
                color: Colors.black,
                size: 20,
              ),
            ),
          );
        }
      },
    );
  }
}
