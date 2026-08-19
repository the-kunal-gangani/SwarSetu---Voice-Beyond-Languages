import 'package:flutter/material.dart';
import 'package:swarsetu_app/core/constants/app_colors.dart';
import 'package:swarsetu_app/core/constants/app_dimensions.dart';
import 'package:swarsetu_app/core/constants/app_strings.dart';
import 'package:swarsetu_app/core/theme/app_text_styles.dart';
import 'package:swarsetu_app/features/history/data/history_local_storage.dart';
import '../widgets/settings_tile.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.deepNavy,
      appBar: AppBar(title: Text(AppStrings.settings, style: AppTextStyles.h3)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(AppDimensions.paddingMD),
          children: [
            Text(
              'ABOUT',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
                letterSpacing: 1.1,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppDimensions.paddingSM),
            const SettingsTile(
              icon: Icons.info_outline_rounded,
              title: AppStrings.appName,
              subtitle: AppStrings.tagline,
            ),

            const SizedBox(height: AppDimensions.paddingLG),
            Text(
              'DATA',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
                letterSpacing: 1.1,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: AppDimensions.paddingSM),
            SettingsTile(
              icon: Icons.delete_sweep_outlined,
              title: 'Clear Translation History',
              subtitle: 'Remove all saved translations',
              onTap: () => _confirmClearHistory(context),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmClearHistory(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.deepNavy,
        title: Text('Clear History?', style: AppTextStyles.h3),
        content: Text(
          'This will permanently delete all saved translations.',
          style: AppTextStyles.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              'Cancel',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              await HistoryLocalStorage().clear();
              if (dialogContext.mounted) Navigator.pop(dialogContext);
            },
            child: Text(
              'Clear',
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }
}
