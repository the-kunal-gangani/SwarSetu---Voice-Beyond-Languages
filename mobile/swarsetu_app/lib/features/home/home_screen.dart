import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:swarsetu_app/core/constants/app_text_styles.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/route_constants.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimensions.paddingLG),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              const Text(
                '${AppStrings.goodMorning} 👋',
                style: AppTextStyles.heading2,
              ),

              const SizedBox(height: 8),

              const Text(
                AppStrings.languageBarrier,
                style: AppTextStyles.bodySecondary,
              ),

              const SizedBox(height: 28),

              _buildTranslateCard(context),

              const SizedBox(height: 32),

              const Text(AppStrings.quickAccess, style: AppTextStyles.heading3),

              const SizedBox(height: 16),

              Row(
                children: [
                  Expanded(
                    child: _buildQuickCard(
                      icon: Icons.menu_book_rounded,
                      title: AppStrings.phrasebook,
                      onTap: () {},
                    ),
                  ),

                  const SizedBox(width: 16),

                  Expanded(
                    child: _buildQuickCard(
                      icon: Icons.history_rounded,
                      title: AppStrings.history,
                      onTap: () {},
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              const Text(
                AppStrings.recentTranslations,
                style: AppTextStyles.heading3,
              ),

              const SizedBox(height: 16),

              _buildEmptyHistory(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTranslateCard(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.push(RouteConstants.translate);
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(AppDimensions.paddingLG),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(AppDimensions.radiusXL),
          gradient: const LinearGradient(
            colors: [AppColors.royalBlue, AppColors.electricBlue],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.royalBlue.withOpacity(0.25),
              blurRadius: 30,
              offset: const Offset(0, 15),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Icon(Icons.graphic_eq_rounded, color: Colors.white, size: 36),

            const SizedBox(height: 20),

            const Text(
              AppStrings.startTranslating,
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Speak naturally. Let SwarSetu bridge the gap.',
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),

            const SizedBox(height: 24),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.mic_rounded, color: Colors.white, size: 20),
                  SizedBox(width: 8),
                  Text(
                    AppStrings.tapToSpeak,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickCard({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.paddingMD),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppDimensions.radiusLG),
          border: Border.all(color: AppColors.softBlue.withOpacity(0.3)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 44,
              width: 44,
              decoration: BoxDecoration(
                color: AppColors.softBlue.withOpacity(0.2),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(icon, color: AppColors.royalBlue),
            ),

            const SizedBox(height: 16),

            Text(title, style: AppTextStyles.heading3),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyHistory() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppDimensions.radiusLG),
      ),
      child: const Column(
        children: [
          Icon(Icons.translate_rounded, size: 36, color: AppColors.softBlue),

          SizedBox(height: 12),

          Text(
            'Your translations will appear here.',
            textAlign: TextAlign.center,
            style: AppTextStyles.bodySecondary,
          ),
        ],
      ),
    );
  }
}
