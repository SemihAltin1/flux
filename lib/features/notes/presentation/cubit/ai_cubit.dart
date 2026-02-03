import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/services/ai_service.dart';
import 'ai_state.dart';

final class AICubit extends Cubit<AIState> {
  AICubit() : super(AIInitial());

  final AIService _aiService = AIService();

  Future<void> processContent(String prompt, String content) async {
    if (content.isEmpty) {
      emit(AIError("Content cannot be empty for AI processing."));
      return;
    }

    emit(AILoading());

    try {
      final result = await _aiService.processNote(prompt, content);
      if (result != null) {
        emit(AISuccess(result));
      } else {
        emit(AIError("AI couldn't generate a response."));
      }
    } catch (e) {
      emit(AIError(e.toString()));
    }
  }

}