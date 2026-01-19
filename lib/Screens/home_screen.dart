import 'dart:io';
import 'package:chatbot/Screens/welcome_screen.dart';
import 'package:chatbot/Widget/chat_history_drawer.dart';
import 'package:chatbot/Widget/chat_input.dart';
import 'package:chatbot/Widget/chat_start.dart';
import 'package:chatbot/Screens/profile_screen.dart';
import 'package:chatbot/firebase/chat_service.dart';
import 'package:chatbot/helper/chatmeesage.dart';
import 'package:chatbot/helper/pref.dart';
import 'package:chatbot/utils/ai_service.dart';
import 'package:chatbot/utils/file_services.dart';
import 'package:chatbot/utils/user_sevice.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
// import 'package:intl/intl.dart';
import 'package:scaffold_gradient_background/scaffold_gradient_background.dart';

class Homescreen extends StatefulWidget {
  const Homescreen({super.key});

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ChatService _chatService = ChatService();

  List<Chatmeesage> messages = [];
  bool _isLoading = false;
  String firstName = "";
  String? currentChatId;

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    _fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    // String lastUpdateText = "Last Update: N/A";
    
    if (messages.isNotEmpty && messages.last.timestamp != null) {
      // lastUpdateText = "Last Update: ${DateFormat('dd/MM/yyyy').format(messages.last.timestamp!)}";
    }
    
    return ScaffoldGradientBackground(
      gradient: const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFFF7E7F5),
          Color(0xFFF7E7F5),
          Color(0xFFFFF4E0),
          Color(0xFFFFF4E0),
        ],
      ),
      appBar: _buildAppBar(),
      drawer: ChatDrawer(
        onNewChat: _startNewChat,
        onSelectChat: _loadChat,
        chatService: _chatService,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: messages.isEmpty
                  ? WelcomeScreen(
                      firstName:Pref.username,
                      // lastUpdateText: lastUpdateText,
                      onPromptSelected: _handlePromptSelection,
                    )
                  : ChatStart(
                      scrollController: _scrollController,
                      messages: messages,
                      isLoading: _isLoading,
                    ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: ChatInput(
        controller: _controller,
        onSend: _sendMessage,
        onPromptSelected: _handlePromptSelection,
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      centerTitle: true,
      backgroundColor: const Color(0xFFF7E7F5),
      title: Text(
        'Chat Pal',
        style: GoogleFonts.publicSans(
          color: Colors.deepPurple,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: [
        PopupMenuButton<String>(
          icon: const Icon(Icons.person, color: Colors.black),
          onSelected: (value) {
            switch (value) {
              case 'profile':
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProfileScreen(),
                  ),
                ).then((_) {
                  _fetchUserData();
                });
                break;
              case 'logout':
                UserService.logout();
                break;
            }
          },
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'profile',
              child: Row(
                children: [
                  const Icon(Icons.person_outline, color: Colors.deepPurple),
                  const SizedBox(width: 10),
                  Text(
                    'Profile',
                    style: GoogleFonts.publicSans(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'logout',
              child: Row(
                children: [
                  const Icon(Icons.logout, color: Colors.redAccent),
                  const SizedBox(width: 10),
                  Text(
                    'Logout',
                    style: GoogleFonts.publicSans(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  // User data methods
  Future<void> _fetchUserData() async {
    try {
      final userData = await UserService.fetchUserData();
      if (!mounted) return;
      setState(() {
        firstName = userData['firstName'] ?? "";
        Pref.username = userData['firstName'] ?? '';
      });
    } catch (_) {
      // Best-effort: don't crash home screen if Firestore is blocked.
      if (!mounted) return;
      setState(() {
        firstName = '';
        Pref.username = '';
      });
    }
  }

  // Chat management methods
  void _startNewChat() {
    setState(() {
      currentChatId = null;
      messages.clear();
    });
  }

  void _loadChat(String chatId) {
    setState(() {
      currentChatId = chatId;
      messages.clear();
    });

    _chatService.getChatMessages(chatId).listen((snapshot) {
      List<Chatmeesage> loadedMessages = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>;
        return Chatmeesage(
          text: data['text'] ?? "",
          isUser: data['senderId'] == 'user',
          timestamp: (data['timestamp'] as Timestamp?)?.toDate(),
          fileUrl: data['fileUrl'],
        );
      }).toList();

      setState(() {
        messages = loadedMessages;
      });

      _scrollToBottom();
    });
  }

  // UI helper methods
  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _handlePromptSelection(String prompt) {
    _controller.text = prompt;
  }

  // Message handling
  Future<void> _sendMessage(String text, File? file) async {
    if (text.isEmpty && file == null) return;

    // Add message preview
    final tempMessage = Chatmeesage(
      text: text,
      isUser: true,
      fileUrl: file?.path,
      timestamp: DateTime.now(),
    );

    setState(() {
      messages.add(tempMessage);
      _isLoading = true;
    });

    _scrollToBottom();

    // Upload file if exists
    String? uploadedFileUrl;
    if (file != null) {
      uploadedFileUrl = await FileService.uploadFileToCloudinary(file);
      
      // Update message with cloud URL
      final messageIndex = messages.indexOf(tempMessage);
      if (messageIndex != -1) {
        setState(() {
          messages[messageIndex] = Chatmeesage(
            text: text,
            isUser: true,
            fileUrl: uploadedFileUrl,
            timestamp: tempMessage.timestamp,
          );
        });
      }
    }

    // Create or update chat
    final userId = UserService.getCurrentUserId();
    if (userId == null) {
      setState(() {
        _isLoading = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('You are not logged in. Please sign in again.')),
        );
      }
      return;
    }

    bool canPersistChat = true;
    try {
      if (currentChatId == null) {
        currentChatId = await _chatService.createNewChat(
          initialMessage: text,
          senderId: 'user',
          userId: userId,
          fileUrl: uploadedFileUrl,
        );
      } else {
        await _chatService.addMessageToChat(
          chatId: currentChatId!,
          senderId: 'user',
          message: text,
          fileUrl: uploadedFileUrl,
        );
      }
    } on FirebaseException catch (e) {
      // Firestore rules most likely: permission-denied
      canPersistChat = false;
      currentChatId = null;
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Chat could not be saved (${e.code}). Fix Firestore rules to enable chat history.',
            ),
          ),
        );
      }
    } catch (e) {
      canPersistChat = false;
      currentChatId = null;
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Chat could not be saved: $e')),
        );
      }
    }

    // Get AI response as a stream (streaming UI)
    final botMessage = Chatmeesage(
      text: '',
      isUser: false,
      timestamp: DateTime.now(),
    );

    setState(() {
      messages.add(botMessage);
    });

    final botIndex = messages.length - 1;
    _scrollToBottom();

    String finalBotText = '';

    await for (final partialText
        in AIService.generateResponseStream(messages, text, file)) {
      if (!mounted) break;
      finalBotText = partialText;
      setState(() {
        messages[botIndex] = Chatmeesage(
          text: partialText,
          isUser: false,
          timestamp: botMessage.timestamp,
        );
      });
      _scrollToBottom();
    }

    if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }

    if (finalBotText.isNotEmpty &&
        !finalBotText.startsWith('Error:') &&
        canPersistChat &&
        currentChatId != null) {
      try {
        await _chatService.addMessageToChat(
          chatId: currentChatId!,
          senderId: 'bot',
          message: finalBotText,
        );
      } on FirebaseException {
        // Don't block UI if saving bot message fails.
      } catch (_) {}
    }
  }
}