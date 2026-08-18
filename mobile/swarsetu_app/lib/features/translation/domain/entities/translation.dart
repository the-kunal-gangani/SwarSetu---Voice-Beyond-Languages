import 'package:equatable/equatable.dart';

class Translation extends Equatable {
  final String id;
  final String sourceLanguage;
  final String targetLanguage;
  final String sourceText;
  final String translatedText;
  final String? audioUrl;
  final DateTime timestamp;

  const Translation({
    required this.id,
    required this.sourceLanguage,
    required this.targetLanguage,
    required this.sourceText,
    required this.translatedText,
    this.audioUrl,
    required this.timestamp,
  });

  @override
  List<Object?> get props => [
    id,
    sourceLanguage,
    targetLanguage,
    sourceText,
    translatedText,
    audioUrl,
    timestamp,
  ];
}
