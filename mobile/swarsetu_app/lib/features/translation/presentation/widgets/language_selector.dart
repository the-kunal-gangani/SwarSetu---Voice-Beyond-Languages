import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/language_constants.dart';
import '../../../../core/theme/app_text_styles.dart';

class LanguageSelector extends StatelessWidget {
  final String sourceLanguage;
  final String targetLanguage;
  final ValueChanged<String> onSourceChanged;
  final ValueChanged<String> onTargetChanged;
  final VoidCallback onSwap;

  const LanguageSelector({
    super.key,
    required this.sourceLanguage,
    required this.targetLanguage,
    required this.onSourceChanged,
    required this.onTargetChanged,
    required this.onSwap,
  });

  @override
  Widget build(BuildContext context) {
    final sourceModel = LanguageConstants.getByCode(sourceLanguage);
    final targetModel = LanguageConstants.getByCode(targetLanguage);

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimensions.paddingMD,
        vertical: AppDimensions.paddingSM,
      ),
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(AppDimensions.radiusLG),
        border: Border.all(
          color: AppColors.cyan.withValues(alpha: 0.2),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: _buildDropdown(
              context: context,
              currentCode: sourceLanguage,
              label: sourceModel.nativeName,
              onChanged: onSourceChanged,
            ),
          ),
          IconButton(
            onPressed: onSwap,
            icon: Container(
              padding: const EdgeInsets.all(AppDimensions.paddingSM),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.royalBlue.withValues(alpha: 0.3),
                border: Border.all(
                  color: AppColors.cyan.withValues(alpha: 0.3),
                ),
              ),
              child: const Icon(
                Icons.swap_horiz_rounded,
                color: AppColors.cyan,
                size: AppDimensions.iconMD,
              ),
            ),
          ),
          Expanded(
            child: _buildDropdown(
              context: context,
              currentCode: targetLanguage,
              label: targetModel.nativeName,
              onChanged: onTargetChanged,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown({
    required BuildContext context,
    required String currentCode,
    required String label,
    required ValueChanged<String> onChanged,
  }) {
    return DropdownButtonHideUnderline(
      child: DropdownButton<String>(
        value: currentCode,
        dropdownColor: AppColors.deepNavy,
        borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
        icon: const Icon(
          Icons.keyboard_arrow_down_rounded,
          color: AppColors.cyan,
        ),
        isExpanded: true,
        items: LanguageConstants.supportedLanguages.map((lang) {
          return DropdownMenuItem<String>(
            value: lang.code,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  lang.nativeName,
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
                Text(
                  lang.name,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          );
        }).toList(),
        onChanged: (val) {
          if (val != null) onChanged(val);
        },
      ),
    );
  }
}
