import 'dart:async';
import '../../domain/entities/translation.dart';
import '../../domain/repositories/translation_repository.dart';

class MockTranslationRepository implements TranslationRepository {
  @override
  Future<Translation> translateAudio({
    required String audioPath,
    required String sourceLanguage,
    required String targetLanguage,
  }) async {
    // Simulate pipeline latency (STT -> NMT -> TTS)
    await Future.delayed(const Duration(seconds: 2));

    return Translation(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      sourceLanguage: sourceLanguage,
      targetLanguage: targetLanguage,
      sourceText: 'नमस्ते, आप कैसे हैं? स्वरसेतु में आपका स्वागत है।',
      translatedText:
          'नमस्कार, तुम्ही कसे आहात? स्वरसेतूमध्ये तुमचे स्वागत आहे.',
      audioUrl: 'mock_audio.mp3',
      timestamp: DateTime.now(),
    );
  }

  @override
  Future<Translation> translateText({
    required String text,
    required String sourceLanguage,
    required String targetLanguage,
  }) async {
    await Future.delayed(const Duration(seconds: 1));

    return Translation(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      sourceLanguage: sourceLanguage,
      targetLanguage: targetLanguage,
      sourceText: text,
      translatedText: 'भाषा अडथळे दूर करा स्वरसेतूच्या साहाय्याने.',
      audioUrl: null,
      timestamp: DateTime.now(),
    );
  }
}
