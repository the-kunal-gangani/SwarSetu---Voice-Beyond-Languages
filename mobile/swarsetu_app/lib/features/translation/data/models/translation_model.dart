import '../../domain/entities/translation.dart';

class TranslationModel extends Translation {
  const TranslationModel({
    required super.id,
    required super.sourceLanguage,
    required super.targetLanguage,
    required super.sourceText,
    required super.translatedText,
    super.audioUrl,
    required super.timestamp,
  });

  factory TranslationModel.fromJson(Map<String, dynamic> json) {
    return TranslationModel(
      id:
          json['id'] as String? ??
          DateTime.now().millisecondsSinceEpoch.toString(),
      sourceLanguage: json['source_language'] as String? ?? 'hi',
      targetLanguage: json['target_language'] as String? ?? 'mr',
      sourceText: json['source_text'] as String? ?? '',
      translatedText: json['translated_text'] as String? ?? '',
      audioUrl: json['audio_url'] as String?,
      timestamp: json['timestamp'] != null
          ? DateTime.parse(json['timestamp'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'source_language': sourceLanguage,
      'target_language': targetLanguage,
      'source_text': sourceText,
      'translated_text': translatedText,
      'audio_url': audioUrl,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}
