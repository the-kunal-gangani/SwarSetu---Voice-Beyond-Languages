import '../entities/translation.dart';

abstract class TranslationRepository {
  Future<Translation> translateAudio({
    required String audioPath,
    required String sourceLanguage,
    required String targetLanguage,
  });

  Future<Translation> translateText({
    required String text,
    required String sourceLanguage,
    required String targetLanguage,
  });
}
