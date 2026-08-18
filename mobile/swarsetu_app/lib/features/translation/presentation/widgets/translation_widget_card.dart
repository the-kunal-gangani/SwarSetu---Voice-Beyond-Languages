import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/language_constants.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/translation.dart';

class TranslationResultCard extends StatelessWidget {
  final Translation translation;

  const TranslationResultCard({super.key, required this.translation});

  @override
  Widget build(BuildContext context) {
    final sourceLang = LanguageConstants.getByCode(translation.sourceLanguage);
    final targetLang = LanguageConstants.getByCode(translation.targetLanguage);

    return Column(
      children: [
        // Source Text Card
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
                translation.sourceText,
                style: AppTextStyles.bodyLarge.copyWith(
                  color: Colors.white.withValues(alpha: 0.9),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: AppDimensions.paddingMD),

        // Translated Result Card (Glowing liquid style)
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
                    onPressed: () {
                      // Trigger audio play
                    },
                    icon: const Icon(
                      Icons.volume_up_rounded,
                      color: AppColors.cyan,
                      size: AppDimensions.iconMD,
                    ),
                  ),
                ],
              ),
              Text(
                translation.translatedText,
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
