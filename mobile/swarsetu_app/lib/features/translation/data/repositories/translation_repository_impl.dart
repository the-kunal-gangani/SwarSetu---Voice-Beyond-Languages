import '../../domain/entities/translation.dart';
import '../../domain/repositories/translation_repository.dart';
import '../datasources/translation_remote_data_source.dart';

class TranslationRepositoryImpl implements TranslationRepository {
  final TranslationRemoteDataSource remoteDataSource;

  TranslationRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Translation> translateAudio({
    required String audioPath,
    required String sourceLanguage,
    required String targetLanguage,
  }) {
    return remoteDataSource.translateAudio(
      audioPath: audioPath,
      sourceLanguage: sourceLanguage,
      targetLanguage: targetLanguage,
    );
  }

  @override
  Future<Translation> translateText({
    required String text,
    required String sourceLanguage,
    required String targetLanguage,
  }) {
    return remoteDataSource.translateText(
      text: text,
      sourceLanguage: sourceLanguage,
      targetLanguage: targetLanguage,
    );
  }
}
