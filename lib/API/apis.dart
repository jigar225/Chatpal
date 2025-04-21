import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class Apis {
  static late final GenerativeModel geminiVersion;
  static final API_KEY = "${dotenv.env['GEMINI_API_KEY']}";
  void initState() {
    geminiVersion = GenerativeModel(
      model: "gemini-1.5-flash-latest",
      apiKey: API_KEY,
    );
  }
}
