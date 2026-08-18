import 'package:flutter_bloc/flutter_bloc.dart';
import '../domain/repositories/translation_repository.dart';
import 'translation_event.dart';
import 'translation_state.dart';

class TranslationBloc extends Bloc<TranslationEvent, TranslationState> {
  final TranslationRepository repository;

  TranslationBloc({required this.repository})
    : super(const TranslationState()) {
    on<SourceLanguageChanged>(_onSourceLanguageChanged);
    on<TargetLanguageChanged>(_onTargetLanguageChanged);
    on<SwapLanguagesRequested>(_onSwapLanguagesRequested);
    on<AudioRecordingStarted>(_onAudioRecordingStarted);
    on<AudioRecordingStopped>(_onAudioRecordingStopped);
    on<TextTranslationRequested>(_onTextTranslationRequested);
    on<TranslationCleared>(_onTranslationCleared);
  }

  void _onSourceLanguageChanged(
    SourceLanguageChanged event,
    Emitter<TranslationState> emit,
  ) {
    emit(state.copyWith(sourceLanguage: event.languageCode));
  }

  void _onTargetLanguageChanged(
    TargetLanguageChanged event,
    Emitter<TranslationState> emit,
  ) {
    emit(state.copyWith(targetLanguage: event.languageCode));
  }

  void _onSwapLanguagesRequested(
    SwapLanguagesRequested event,
    Emitter<TranslationState> emit,
  ) {
    emit(
      state.copyWith(
        sourceLanguage: state.targetLanguage,
        targetLanguage: state.sourceLanguage,
      ),
    );
  }

  void _onAudioRecordingStarted(
    AudioRecordingStarted event,
    Emitter<TranslationState> emit,
  ) {
    emit(state.copyWith(status: TranslationStatus.recording));
  }

  Future<void> _onAudioRecordingStopped(
    AudioRecordingStopped event,
    Emitter<TranslationState> emit,
  ) async {
    emit(state.copyWith(status: TranslationStatus.processing));
    try {
      final translation = await repository.translateAudio(
        audioPath: event.audioPath,
        sourceLanguage: state.sourceLanguage,
        targetLanguage: state.targetLanguage,
      );
      emit(
        state.copyWith(status: TranslationStatus.success, result: translation),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: TranslationStatus.failure,
          errorMessage: 'Translation failed. Please try speaking again.',
        ),
      );
    }
  }

  Future<void> _onTextTranslationRequested(
    TextTranslationRequested event,
    Emitter<TranslationState> emit,
  ) async {
    if (event.text.trim().isEmpty) return;

    emit(state.copyWith(status: TranslationStatus.processing));
    try {
      final translation = await repository.translateText(
        text: event.text,
        sourceLanguage: state.sourceLanguage,
        targetLanguage: state.targetLanguage,
      );
      emit(
        state.copyWith(status: TranslationStatus.success, result: translation),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: TranslationStatus.failure,
          errorMessage: 'Text translation failed. Please try again.',
        ),
      );
    }
  }

  void _onTranslationCleared(
    TranslationCleared event,
    Emitter<TranslationState> emit,
  ) {
    emit(
      state.copyWith(
        status: TranslationStatus.initial,
        result: null,
        errorMessage: null,
      ),
    );
  }
}
