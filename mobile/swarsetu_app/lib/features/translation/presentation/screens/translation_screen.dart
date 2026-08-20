import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:swarsetu_app/core/constants/app_colors.dart';
import 'package:swarsetu_app/core/constants/app_dimensions.dart';
import 'package:swarsetu_app/core/constants/app_strings.dart';
import 'package:swarsetu_app/core/theme/app_text_styles.dart';
import 'package:swarsetu_app/features/translation/bloc/translation_bloc.dart';
import 'package:swarsetu_app/features/translation/bloc/translation_event.dart';
import 'package:swarsetu_app/features/translation/bloc/translation_state.dart';
import 'package:swarsetu_app/features/translation/presentation/widgets/language_selector.dart';
import 'package:swarsetu_app/features/translation/presentation/widgets/translation_widget_card.dart';
import 'package:swarsetu_app/features/translation/presentation/widgets/voice_button.dart';
import 'package:swarsetu_app/core/network/api_client.dart';
import 'package:swarsetu_app/features/translation/data/datasources/translation_remote_data_source.dart';
import 'package:swarsetu_app/features/translation/data/repositories/translation_repository_impl.dart';

class TranslationScreen extends StatelessWidget {
  const TranslationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TranslationBloc(
        repository: TranslationRepositoryImpl(
          remoteDataSource: TranslationRemoteDataSourceImpl(
            apiClient: ApiClient(),
          ),
        ),
      ),
      child: const _TranslationView(),
    );
  }
}

class _TranslationView extends StatelessWidget {
  const _TranslationView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.deepNavy,
      appBar: AppBar(
        title: Text(AppStrings.translate, style: AppTextStyles.h3),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: AppColors.cyan),
            onPressed: () {
              context.read<TranslationBloc>().add(TranslationCleared());
            },
          ),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.paddingMD),
          child: Column(
            children: [
              // Language Selection Bar
              BlocBuilder<TranslationBloc, TranslationState>(
                buildWhen: (p, c) =>
                    p.sourceLanguage != c.sourceLanguage ||
                    p.targetLanguage != c.targetLanguage,
                builder: (context, state) {
                  return LanguageSelector(
                    sourceLanguage: state.sourceLanguage,
                    targetLanguage: state.targetLanguage,
                    onSourceChanged: (code) {
                      context.read<TranslationBloc>().add(
                        SourceLanguageChanged(code),
                      );
                    },
                    onTargetChanged: (code) {
                      context.read<TranslationBloc>().add(
                        TargetLanguageChanged(code),
                      );
                    },
                    onSwap: () {
                      context.read<TranslationBloc>().add(
                        SwapLanguagesRequested(),
                      );
                    },
                  );
                },
              ),

              const SizedBox(height: AppDimensions.paddingLG),

              // Results & Content Area
              Expanded(
                child: SingleChildScrollView(
                  child: BlocBuilder<TranslationBloc, TranslationState>(
                    builder: (context, state) {
                      if (state.status == TranslationStatus.processing) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 60.0),
                            child: Column(
                              children: [
                                const CircularProgressIndicator(
                                  color: AppColors.cyan,
                                ),
                                const SizedBox(height: AppDimensions.paddingMD),
                                Text(
                                  AppStrings.translating,
                                  style: AppTextStyles.bodyMedium,
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      if (state.status == TranslationStatus.failure) {
                        return Center(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 60.0),
                            child: Text(
                              state.errorMessage ?? 'An error occurred',
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.error,
                              ),
                            ),
                          ),
                        );
                      }

                      if (state.result != null) {
                        return TranslationResultCard(
                          translation: state.result!,
                        );
                      }

                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 80.0),
                          child: Column(
                            children: [
                              Icon(
                                Icons.graphic_eq_rounded,
                                size: AppDimensions.iconXL * 1.5,
                                color: AppColors.cyan.withValues(alpha: 0.3),
                              ),
                              const SizedBox(height: AppDimensions.paddingMD),
                              Text(
                                AppStrings.tapToSpeak,
                                style: AppTextStyles.bodyMedium,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),

              // Microphone Controller
              BlocBuilder<TranslationBloc, TranslationState>(
                builder: (context, state) {
                  return Column(
                    children: [
                      VoiceButton(
                        status: state.status,
                        onTap: () {
                          final bloc = context.read<TranslationBloc>();
                          if (state.status == TranslationStatus.recording) {
                            bloc.add(
                              const AudioRecordingStopped('temp_mock.wav'),
                            );
                          } else {
                            bloc.add(AudioRecordingStarted());
                          }
                        },
                      ),
                      const SizedBox(height: AppDimensions.paddingSM),
                      Text(
                        state.status == TranslationStatus.recording
                            ? AppStrings.listening
                            : AppStrings.tapToSpeak,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: state.status == TranslationStatus.recording
                              ? AppColors.cyan
                              : AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: AppDimensions.paddingMD),
                    ],
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
