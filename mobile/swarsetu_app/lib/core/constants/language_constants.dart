class LanguageModel {
  final String code;
  final String name;
  final String nativeName;

  const LanguageModel({
    required this.code,
    required this.name,
    required this.nativeName,
  });
}

class LanguageConstants {
  LanguageConstants._();

  static const List<LanguageModel> supportedLanguages = [
    LanguageModel(code: 'hi', name: 'Hindi', nativeName: 'हिन्दी'),
    LanguageModel(code: 'mr', name: 'Marathi', nativeName: 'मराठी'),
    LanguageModel(code: 'bho', name: 'Bhojpuri', nativeName: 'भोजपुरी'),
    LanguageModel(code: 'mai', name: 'Maithili', nativeName: 'मैथिली'),
    LanguageModel(code: 'mag', name: 'Magahi', nativeName: 'मगही'),
    LanguageModel(code: 'en', name: 'English', nativeName: 'English'),
  ];

  static LanguageModel getByCode(String code) {
    return supportedLanguages.firstWhere(
      (lang) => lang.code == code,
      orElse: () =>
          const LanguageModel(code: 'hi', name: 'Hindi', nativeName: 'हिन्दी'),
    );
  }
}
