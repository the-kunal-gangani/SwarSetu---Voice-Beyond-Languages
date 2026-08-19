import '../domain/entities/phrase.dart';

class PhrasebookData {
  static const List<String> categories = [
    'Greetings',
    'Travel',
    'Emergency',
    'Food',
    'Shopping',
  ];

  static const List<Phrase> phrases = [
    Phrase(
      id: 'p1',
      category: 'Greetings',
      sourceText: 'Hello, how are you?',
      translatedText: 'नमस्ते, आप कैसे हैं?',
      languageCode: 'hi',
    ),
    Phrase(
      id: 'p2',
      category: 'Greetings',
      sourceText: 'Thank you very much',
      translatedText: 'बहुत बहुत धन्यवाद',
      languageCode: 'hi',
    ),
    Phrase(
      id: 'p3',
      category: 'Travel',
      sourceText: 'Where is the bus station?',
      translatedText: 'बस स्टेशन कहाँ है?',
      languageCode: 'hi',
    ),
    Phrase(
      id: 'p4',
      category: 'Emergency',
      sourceText: 'I need a doctor',
      translatedText: 'मुझे डॉक्टर चाहिए',
      languageCode: 'hi',
    ),
    Phrase(
      id: 'p5',
      category: 'Food',
      sourceText: 'This is delicious',
      translatedText: 'हे खूप छान आहे',
      languageCode: 'mr',
    ),
    Phrase(
      id: 'p6',
      category: 'Shopping',
      sourceText: 'How much does this cost?',
      translatedText: 'हे किती पैसे आहे?',
      languageCode: 'mr',
    ),
  ];

  static List<Phrase> byCategory(String category) {
    return phrases.where((p) => p.category == category).toList();
  }
}
