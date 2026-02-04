import 'package:google_generative_ai/google_generative_ai.dart';

final class AIService {
  final model = GenerativeModel(model: "gemini-3-flash-preview", apiKey: "AIzaSyA1vWnwQos7lqkqRcSBr7RXMVJGkse2ZHU");

  Future<String?> processNote(String prompt, String content) async {
    try {
      final response = await model.generateContent([
        Content.multi([
          TextPart("SYSTEM INSTRUCTION: You are a professional note editor. "
              "Output ONLY the requested text. No introductions, no explanations.\n"),
          TextPart("USER TASK: $prompt\n"),
          TextPart("TARGET CONTENT:\n$content"),
        ])
      ]);

      if (response.text == null || response.text!.isEmpty) {
        return "AI could not generate a response. Please try again.";
      }

      return response.text;
    } catch (e) {
      return null;
    }
  }

}