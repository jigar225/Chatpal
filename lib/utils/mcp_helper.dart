import 'package:chatbot/helper/chatmeesage.dart';

String formatChatHistory(List<Chatmeesage> message){
return message.map((msg){
  final role = msg.isUser ? 'User' : 'Bot';
  return '$role:${msg.text}';
}).join('\n');
}