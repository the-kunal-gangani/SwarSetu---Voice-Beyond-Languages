class Phrase {
  final String id;
  final String category;
  final String sourceText;
  final String translatedText;
  final String languageCode;

  const Phrase({
    required this.id,
    required this.category,
    required this.sourceText,
    required this.translatedText,
    required this.languageCode,
  });
}
