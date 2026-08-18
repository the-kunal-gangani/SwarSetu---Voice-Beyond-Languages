import 'package:equatable/equatable.dart';

abstract class TranslationEvent extends Equatable {
  const TranslationEvent();

  @override
  List<Object?> get props => [];
}

class SourceLanguageChanged extends TranslationEvent {
  final String languageCode;

  const SourceLanguageChanged(this.languageCode);

  @override
  List<Object?> get props => [languageCode];
}

class TargetLanguageChanged extends TranslationEvent {
  final String languageCode;

  const TargetLanguageChanged(this.languageCode);

  @override
  List<Object?> get props => [languageCode];
}

class SwapLanguagesRequested extends TranslationEvent {}

class AudioRecordingStarted extends TranslationEvent {}

class AudioRecordingStopped extends TranslationEvent {
  final String audioPath;

  const AudioRecordingStopped(this.audioPath);

  @override
  List<Object?> get props => [audioPath];
}

class TextTranslationRequested extends TranslationEvent {
  final String text;

  const TextTranslationRequested(this.text);

  @override
  List<Object?> get props => [text];
}

class TranslationCleared extends TranslationEvent {}
