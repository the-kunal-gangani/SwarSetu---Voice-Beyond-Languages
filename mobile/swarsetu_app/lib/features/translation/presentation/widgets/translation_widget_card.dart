import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/language_constants.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/translation.dart';

class TranslationResultCard extends StatefulWidget {
  final Translation translation;

  const TranslationResultCard({super.key, required this.translation});

  @override
  State<TranslationResultCard> createState() => _TranslationResultCardState();
}

class _TranslationResultCardState extends State<TranslationResultCard> {
  final _player = AudioPlayer();
  bool _isLoading = false;
  bool _isPlaying = false;

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  String _resolveAudioUrl(String audioUrl) {
    if (audioUrl.startsWith('http://') || audioUrl.startsWith('https://')) {
      return audioUrl;
    }
    return '${ApiConstants.baseUrl}$audioUrl';
  }

  Future<void> _togglePlayback() async {
    final audioUrl = widget.translation.audioUrl;
    if (audioUrl == null || audioUrl.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Audio not available for this translation.'),
        ),
      );
      return;
    }

    if (_isPlaying) {
      await _player.pause();
      setState(() => _isPlaying = false);
      return;
    }

    setState(() => _isLoading = true);
    try {
      await _player.setUrl(_resolveAudioUrl(audioUrl));
      await _player.play();
      setState(() {
        _isLoading = false;
        _isPlaying = true;
      });

      _player.playerStateStream.listen((state) {
        if (state.processingState == ProcessingState.completed && mounted) {
          setState(() => _isPlaying = false);
        }
      });
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Could not play audio. Please try again.'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final sourceLang = LanguageConstants.getByCode(
      widget.translation.sourceLanguage,
    );
    final targetLang = LanguageConstants.getByCode(
      widget.translation.targetLanguage,
    );

    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppDimensions.paddingMD),
          decoration: BoxDecoration(
            color: AppColors.surface.withValues(alpha: 0.04),
            borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
            border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                sourceLang.name.toUpperCase(),
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                  letterSpacing: 1.1,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: AppDimensions.paddingSM),
              Text(
                widget.translation.sourceText,
                style: AppTextStyles.bodyLarge.copyWith(
                  color: Colors.white.withValues(alpha: 0.9),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: AppDimensions.paddingMD),

        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppDimensions.paddingLG),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.royalBlue.withValues(alpha: 0.25),
                AppColors.cyan.withValues(alpha: 0.12),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(AppDimensions.radiusLG),
            border: Border.all(color: AppColors.cyan.withValues(alpha: 0.35)),
            boxShadow: [
              BoxShadow(
                color: AppColors.cyan.withValues(alpha: 0.08),
                blurRadius: 20,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    targetLang.nativeName.toUpperCase(),
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.cyan,
                      letterSpacing: 1.1,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: _isLoading ? null : _togglePlayback,
                    icon: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: AppColors.cyan,
                              strokeWidth: 2,
                            ),
                          )
                        : Icon(
                            _isPlaying
                                ? Icons.pause_circle_filled_rounded
                                : Icons.volume_up_rounded,
                            color: AppColors.cyan,
                            size: AppDimensions.iconMD,
                          ),
                  ),
                ],
              ),
              Text(
                widget.translation.translatedText,
                style: AppTextStyles.h3.copyWith(
                  color: Colors.white,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
