class Chatmeesage {
  final String text;
  final bool isUser;
  final DateTime? timestamp;
   String? fileUrl;

  Chatmeesage({
    required this.text,
    required this.isUser,
    this.timestamp,
    this.fileUrl,
  });
}

