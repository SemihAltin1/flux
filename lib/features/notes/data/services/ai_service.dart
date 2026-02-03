import 'package:google_generative_ai/google_generative_ai.dart';

final class AIService {
  final model = GenerativeModel(model: "gemini-3-flash-preview", apiKey: "AIzaSyA1vWnwQos7lqkqRcSBr7RXMVJGkse2ZHU");

  Future<String?> processNote(String prompt, String content) async {
    final response = await model.generateContent([
      Content.text("$prompt: $content")
    ]);
    return response.text;
  }

}