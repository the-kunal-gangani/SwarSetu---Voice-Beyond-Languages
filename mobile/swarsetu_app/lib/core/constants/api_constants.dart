class ApiConstants {
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://10.0.2.2:8000',
  );

  static const Duration connectTimeout = Duration(seconds: 10);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);

  static const String health = '/health';
  static const String translationAudio = '/api/v1/translation/audio';
  static const String translationText = '/api/v1/translation/text';
  static const String voiceSpeak = '/api/v1/voice/speak';
  static const String phrases = '/api/v1/phrases';
  static const String contributions = '/api/v1/contributions';
}
