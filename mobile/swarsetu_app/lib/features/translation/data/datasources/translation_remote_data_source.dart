import 'dart:io';
import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/network/api_client.dart';
import '../models/translation_model.dart';

abstract class TranslationRemoteDataSource {
  Future<TranslationModel> translateAudio({
    required String audioPath,
    required String sourceLanguage,
    required String targetLanguage,
  });

  Future<TranslationModel> translateText({
    required String text,
    required String sourceLanguage,
    required String targetLanguage,
  });
}

class TranslationRemoteDataSourceImpl implements TranslationRemoteDataSource {
  final ApiClient apiClient;

  TranslationRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<TranslationModel> translateAudio({
    required String audioPath,
    required String sourceLanguage,
    required String targetLanguage,
  }) async {
    final file = File(audioPath);
    final formData = FormData.fromMap({
      'source_language': sourceLanguage,
      'target_language': targetLanguage,
      'audio': await MultipartFile.fromFile(
        file.path,
        filename: file.uri.pathSegments.last,
      ),
    });

    final response = await apiClient.postFormData(
      ApiConstants.translationAudio,
      formData: formData,
    );

    return TranslationModel.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<TranslationModel> translateText({
    required String text,
    required String sourceLanguage,
    required String targetLanguage,
  }) async {
    final response = await apiClient.post(
      ApiConstants.translationText,
      data: {
        'text': text,
        'source_language': sourceLanguage,
        'target_language': targetLanguage,
      },
    );

    return TranslationModel.fromJson(response.data as Map<String, dynamic>);
  }
}
