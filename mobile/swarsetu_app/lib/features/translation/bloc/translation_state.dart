import 'package:equatable/equatable.dart';
import '../domain/entities/translation.dart';

enum TranslationStatus { initial, recording, processing, success, failure }

class TranslationState extends Equatable {
  final String sourceLanguage;
  final String targetLanguage;
  final TranslationStatus status;
  final Translation? result;
  final String? errorMessage;

  const TranslationState({
    this.sourceLanguage = 'hi',
    this.targetLanguage = 'mr',
    this.status = TranslationStatus.initial,
    this.result,
    this.errorMessage,
  });

  TranslationState copyWith({
    String? sourceLanguage,
    String? targetLanguage,
    TranslationStatus? status,
    Translation? result,
    String? errorMessage,
  }) {
    return TranslationState(
      sourceLanguage: sourceLanguage ?? this.sourceLanguage,
      targetLanguage: targetLanguage ?? this.targetLanguage,
      status: status ?? this.status,
      result: result ?? this.result,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    sourceLanguage,
    targetLanguage,
    status,
    result,
    errorMessage,
  ];
}
