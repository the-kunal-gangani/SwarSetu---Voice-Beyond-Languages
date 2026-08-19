import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/language_constants.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../data/contribution_local_storage.dart';
import '../../domain/entities/contribution.dart';

class ContributionScreen extends StatefulWidget {
  const ContributionScreen({super.key});

  @override
  State<ContributionScreen> createState() => _ContributionScreenState();
}

class _ContributionScreenState extends State<ContributionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _sourceController = TextEditingController();
  final _translatedController = TextEditingController();
  final _storage = ContributionLocalStorage();

  String _sourceLanguage = 'hi';
  String _targetLanguage = 'mr';
  bool _submitting = false;

  @override
  void dispose() {
    _sourceController.dispose();
    _translatedController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _submitting = true);

    await _storage.add(
      Contribution(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        sourceLanguage: _sourceLanguage,
        targetLanguage: _targetLanguage,
        sourceText: _sourceController.text.trim(),
        translatedText: _translatedController.text.trim(),
        timestamp: DateTime.now(),
      ),
    );

    if (!mounted) return;

    _sourceController.clear();
    _translatedController.clear();
    setState(() => _submitting = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: AppColors.success,
        content: Text(
          'Thank you for contributing!',
          style: AppTextStyles.bodyMedium.copyWith(color: Colors.white),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.deepNavy,
      appBar: AppBar(
        title: Text(AppStrings.contribute, style: AppTextStyles.h3),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppDimensions.paddingMD),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Help SwarSetu learn new phrases and dialects.',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: Colors.white.withValues(alpha: 0.8),
                  ),
                ),
                const SizedBox(height: AppDimensions.paddingLG),

                Row(
                  children: [
                    Expanded(
                      child: _buildLanguageDropdown(
                        value: _sourceLanguage,
                        onChanged: (v) => setState(() => _sourceLanguage = v!),
                      ),
                    ),
                    const SizedBox(width: AppDimensions.paddingSM),
                    const Icon(
                      Icons.arrow_forward_rounded,
                      color: AppColors.cyan,
                    ),
                    const SizedBox(width: AppDimensions.paddingSM),
                    Expanded(
                      child: _buildLanguageDropdown(
                        value: _targetLanguage,
                        onChanged: (v) => setState(() => _targetLanguage = v!),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: AppDimensions.paddingLG),
                Text(
                  'Source Phrase',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: AppDimensions.paddingSM),
                _buildTextField(
                  controller: _sourceController,
                  hint: 'Enter phrase in source language',
                ),

                const SizedBox(height: AppDimensions.paddingMD),
                Text(
                  'Translation',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: AppDimensions.paddingSM),
                _buildTextField(
                  controller: _translatedController,
                  hint: 'Enter the translated phrase',
                ),

                const SizedBox(height: AppDimensions.paddingXL),
                SizedBox(
                  width: double.infinity,
                  height: AppDimensions.buttonHeight,
                  child: ElevatedButton(
                    onPressed: _submitting ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.electricBlue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          AppDimensions.radiusMD,
                        ),
                      ),
                    ),
                    child: _submitting
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            'Submit Contribution',
                            style: AppTextStyles.bodyLarge.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageDropdown({
    required String value,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: AppDimensions.paddingSM),
      decoration: BoxDecoration(
        color: AppColors.surface.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
        border: Border.all(color: AppColors.cyan.withValues(alpha: 0.2)),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          dropdownColor: AppColors.deepNavy,
          isExpanded: true,
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: AppColors.cyan,
          ),
          items: LanguageConstants.supportedLanguages.map((lang) {
            return DropdownMenuItem(
              value: lang.code,
              child: Text(
                lang.nativeName,
                style: AppTextStyles.bodyMedium.copyWith(color: Colors.white),
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: 2,
      style: AppTextStyles.bodyLarge.copyWith(color: Colors.white),
      validator: (value) => (value == null || value.trim().isEmpty)
          ? 'This field is required'
          : null,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: AppTextStyles.bodyMedium.copyWith(
          color: AppColors.textSecondary,
        ),
        filled: true,
        fillColor: AppColors.surface.withValues(alpha: 0.05),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
          borderSide: BorderSide(color: AppColors.cyan.withValues(alpha: 0.2)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
          borderSide: BorderSide(color: AppColors.cyan.withValues(alpha: 0.2)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppDimensions.radiusMD),
          borderSide: const BorderSide(color: AppColors.cyan, width: 1.5),
        ),
      ),
    );
  }
}
