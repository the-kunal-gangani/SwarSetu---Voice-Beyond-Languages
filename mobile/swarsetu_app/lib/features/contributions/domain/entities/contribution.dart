class Contribution {
  final String id;
  final String sourceLanguage;
  final String targetLanguage;
  final String sourceText;
  final String translatedText;
  final DateTime timestamp;
  final bool synced;

  const Contribution({
    required this.id,
    required this.sourceLanguage,
    required this.targetLanguage,
    required this.sourceText,
    required this.translatedText,
    required this.timestamp,
    this.synced = false,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'source_language': sourceLanguage,
    'target_language': targetLanguage,
    'source_text': sourceText,
    'translated_text': translatedText,
    'timestamp': timestamp.toIso8601String(),
    'synced': synced,
  };

  factory Contribution.fromJson(Map<String, dynamic> json) => Contribution(
    id: json['id'] as String,
    sourceLanguage: json['source_language'] as String,
    targetLanguage: json['target_language'] as String,
    sourceText: json['source_text'] as String,
    translatedText: json['translated_text'] as String,
    timestamp: DateTime.parse(json['timestamp'] as String),
    synced: json['synced'] as bool? ?? false,
  );
}
