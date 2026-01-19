import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

class Apis {
  static late final GenerativeModel geminiVersion;
  static final API_KEY = "${dotenv.env['GEMINI_API_KEY']}";

  /// Call this once during app startup (e.g. main.dart) after dotenv is loaded.
  static void init() {
    geminiVersion = GenerativeModel(
      // Use a stable, supported model name
      model: "gemini-2.5-flash",
      apiKey: API_KEY,
    );
  }
}
