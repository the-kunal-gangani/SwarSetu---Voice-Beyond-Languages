import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:swarsetu_app/core/constants/route_constants.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_dimensions.dart';
import '../../core/constants/app_strings.dart';
import '../../core/theme/app_text_styles.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.midnightBlue,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppDimensions.paddingMD),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppDimensions.paddingMD),
              Text(AppStrings.goodMorning, style: AppTextStyles.bodyMedium),
              const SizedBox(height: 4),
              Text(
                AppStrings.appName,
                style: AppTextStyles.h1.copyWith(color: AppColors.cyan),
              ),
              const SizedBox(height: AppDimensions.paddingSM),
              Text(
                AppStrings.languageBarrier,
                style: AppTextStyles.bodyLarge.copyWith(
                  color: Colors.white.withValues(alpha: 0.8),
                ),
              ),
              const SizedBox(height: AppDimensions.paddingXL),

              // Hero Translation Button — warm voice gradient
              GestureDetector(
                onTap: () => context.push(RouteConstants.translate),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(AppDimensions.paddingLG),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [
                        AppColors.voiceCoral,
                        AppColors.voiceMagenta,
                        AppColors.voiceViolet,
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(AppDimensions.radiusLG),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.voiceMagenta.withValues(alpha: 0.35),
                        blurRadius: 24,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(AppDimensions.paddingMD),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.mic_rounded,
                          color: Colors.white,
                          size: AppDimensions.iconLG,
                        ),
                      ),
                      const SizedBox(width: AppDimensions.paddingMD),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              AppStrings.startTranslating,
                              style: AppTextStyles.h3,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              AppStrings.tapToSpeak,
                              style: AppTextStyles.bodySmall.copyWith(
                                color: Colors.white.withValues(alpha: 0.8),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: Colors.white,
                        size: AppDimensions.iconSM,
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: AppDimensions.paddingXL),
              Text(AppStrings.quickAccess, style: AppTextStyles.h3),
              const SizedBox(height: AppDimensions.paddingMD),

              // Quick Actions Grid — stays cool blue, deliberately
              Expanded(
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: AppDimensions.paddingMD,
                  mainAxisSpacing: AppDimensions.paddingMD,
                  children: [
                    _buildQuickCard(
                      context,
                      title: AppStrings.phrasebook,
                      icon: Icons.menu_book_rounded,
                      route: RouteConstants.phrasebook,
                    ),
                    _buildQuickCard(
                      context,
                      title: AppStrings.history,
                      icon: Icons.history_rounded,
                      route: RouteConstants.history,
                    ),
                    _buildQuickCard(
                      context,
                      title: AppStrings.contribute,
                      icon: Icons.volunteer_activism_rounded,
                      route: RouteConstants.contribute,
                    ),
                    _buildQuickCard(
                      context,
                      title: AppStrings.settings,
                      icon: Icons.settings_rounded,
                      route: RouteConstants.settings,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required String route,
  }) {
    return GestureDetector(
      onTap: () => context.push(route),
      child: Container(
        padding: const EdgeInsets.all(AppDimensions.paddingMD),
        decoration: BoxDecoration(
          color: AppColors.surface.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
          border: Border.all(color: AppColors.cyan.withValues(alpha: 0.15)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: AppColors.cyan, size: AppDimensions.iconLG),
            const SizedBox(height: AppDimensions.paddingSM),
            Text(
              title,
              style: AppTextStyles.bodyLarge.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
