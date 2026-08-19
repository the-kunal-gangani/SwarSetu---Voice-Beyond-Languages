import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../data/phrasebook_data.dart';
import '../widgets/phrase_card.dart';

class PhrasebookScreen extends StatefulWidget {
  const PhrasebookScreen({super.key});

  @override
  State<PhrasebookScreen> createState() => _PhrasebookScreenState();
}

class _PhrasebookScreenState extends State<PhrasebookScreen> {
  String _selectedCategory = PhrasebookData.categories.first;

  @override
  Widget build(BuildContext context) {
    final phrases = PhrasebookData.byCategory(_selectedCategory);

    return Scaffold(
      backgroundColor: AppColors.deepNavy,
      appBar: AppBar(
        title: Text(AppStrings.phrasebook, style: AppTextStyles.h3),
      ),
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 48,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.paddingMD,
                ),
                itemCount: PhrasebookData.categories.length,
                separatorBuilder: (_, _) =>
                    const SizedBox(width: AppDimensions.paddingSM),
                itemBuilder: (context, index) {
                  final category = PhrasebookData.categories[index];
                  final isSelected = category == _selectedCategory;
                  return ChoiceChip(
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (_) {
                      setState(() => _selectedCategory = category);
                    },
                    selectedColor: AppColors.electricBlue,
                    backgroundColor: AppColors.surface.withValues(alpha: 0.05),
                    labelStyle: AppTextStyles.bodySmall.copyWith(
                      color: isSelected
                          ? Colors.white
                          : AppColors.textSecondary,
                    ),
                    side: BorderSide(
                      color: AppColors.cyan.withValues(alpha: 0.2),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: AppDimensions.paddingMD),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDimensions.paddingMD,
                ),
                itemCount: phrases.length,
                itemBuilder: (context, index) {
                  return PhraseCard(phrase: phrases[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
