import 'package:flutter/material.dart';
import 'package:swarsetu_app/core/constants/app_text_styles.dart';

import '../../../../core/constants/app_strings.dart';

class TranslationScreen extends StatelessWidget {
  const TranslationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.translate)),
      body: const Center(
        child: Text('Translation Screen', style: AppTextStyles.heading2),
      ),
    );
  }
}
