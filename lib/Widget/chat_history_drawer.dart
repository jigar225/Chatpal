import 'package:chatbot/firebase/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ChatDrawer extends StatefulWidget {
  final VoidCallback onNewChat;
  final Function(String chatId) onSelectChat;
  final ChatService chatService;

  const ChatDrawer({
    Key? key,
    required this.onNewChat,
    required this.onSelectChat,
    required this.chatService,
  }) : super(key: key);

  @override
  State<ChatDrawer> createState() => _ChatDrawerState();
}

class _ChatDrawerState extends State<ChatDrawer> {
  String searchQuery = '';

  void deleteChat(String chatId) async {
    await FirebaseFirestore.instance.collection('chats').doc(chatId).delete();
  }

  @override
  Widget build(BuildContext context) {
    final String currentUserId = FirebaseAuth.instance.currentUser!.uid;
    return Drawer(
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search chat history...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onChanged: (value) {
                  setState(() => searchQuery = value.toLowerCase());
                },
              ),
            ),
            const SizedBox(height: 10),
            GestureDetector(
              onTap: () {
                widget.onNewChat();
                Navigator.of(context).pop();
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  children: [
                    const Icon(Icons.add, color: Colors.blue),
                    const SizedBox(width: 8),
                    Text(
                      'New Chat',
                      style: GoogleFonts.publicSans(
                          color: Colors.deepPurple,
                          fontWeight: FontWeight.bold,
                          fontSize: 18),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text('Chat History',
                  style: GoogleFonts.publicSans(fontSize: 18, fontWeight: FontWeight.bold)),
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: widget.chatService.getChatHistory(currentUserId),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(child: Text('No chat history'));
                  }

                  final chats = snapshot.data!.docs;

                  return ListView.builder(
                    itemCount: chats.length,
                    itemBuilder: (context, index) {
                      final chat = chats[index];
                      return FutureBuilder<QuerySnapshot>(
                        future: chat.reference
                            .collection('messages')
                            .orderBy('timestamp', descending: false)
                            .limit(1)
                            .get(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting ||
                              !snapshot.hasData ||
                              snapshot.data!.docs.isEmpty) {
                            return const SizedBox();
                          }

                          final firstMessage = snapshot.data!.docs.first;
                          String chatTitle = firstMessage['text'] ?? '';

                          if (chatTitle.isEmpty && firstMessage['fileUrl'] != null) {
                            chatTitle = "📷 Image";
                          }

                          chatTitle = chatTitle.isEmpty ? "New Chat" : chatTitle;

                          if (searchQuery.isNotEmpty &&
                              !chatTitle.toLowerCase().contains(searchQuery)) {
                            return const SizedBox();
                          }

                          chatTitle = chatTitle.length > 25
                              ? '${chatTitle.substring(0, 25)}...'
                              : chatTitle;

                          final createdAtTimestamp = chat['createdAt'] as Timestamp?;
                          final dateString = createdAtTimestamp != null
                              ? createdAtTimestamp.toDate().toString().split(" ").first
                              : "Unknown";

                          return ListTile(
                            leading: const Icon(Icons.chat_bubble_outline, color: Colors.black),
                            title: Text(chatTitle,
                                style: GoogleFonts.publicSans(fontWeight: FontWeight.w600)),
                            subtitle: Text('Started $dateString'),
                            trailing: PopupMenuButton<String>(
                              icon: const Icon(Icons.more_vert, color: Colors.grey),
                              onSelected: (value) {
                                if (value == 'delete') deleteChat(chat.id);
                              },
                              itemBuilder: (context) => [
                                PopupMenuItem(
                                  value: 'delete',
                                  child: Row(
                                    children: [
                                      const Icon(Icons.delete, color: Colors.redAccent),
                                      const SizedBox(width: 10),
                                      Text('Delete Chat',
                                          style: GoogleFonts.publicSans(fontWeight: FontWeight.w500)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            onTap: () {
                              widget.onSelectChat(chat.id);
                              Navigator.of(context).pop();
                            },
                          );
                        },
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
