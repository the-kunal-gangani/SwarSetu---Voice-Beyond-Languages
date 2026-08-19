import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/language_constants.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../domain/entities/history_entry.dart';

class HistoryCard extends StatelessWidget {
  final HistoryEntry entry;

  const HistoryCard({super.key, required this.entry});

  @override
  Widget build(BuildContext context) {
    final source = LanguageConstants.getByCode(entry.sourceLanguage);
    final target = LanguageConstants.getByCode(entry.targetLanguage);

    return Container(
      margin: const EdgeInsets.only(bottom: AppDimensions.paddingSM),
      padding: const EdgeInsets.all(AppDimensions.paddingMD),
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
        border: Border.all(color: AppColors.cyan.withValues(alpha: 0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                '${source.nativeName} → ${target.nativeName}',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.cyan,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const Spacer(),
              Text(
                _formatTime(entry.timestamp),
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppDimensions.paddingSM),
          Text(
            entry.sourceText,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            entry.translatedText,
            style: AppTextStyles.bodyLarge.copyWith(color: Colors.white),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final diff = now.difference(time);
    if (diff.inMinutes < 1) return 'Just now';
    if (diff.inHours < 1) return '${diff.inMinutes}m ago';
    if (diff.inDays < 1) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}
