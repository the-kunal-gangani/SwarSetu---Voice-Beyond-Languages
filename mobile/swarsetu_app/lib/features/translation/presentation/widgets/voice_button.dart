import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_dimensions.dart';
import '../../bloc/translation_state.dart';

class VoiceButton extends StatefulWidget {
  final TranslationStatus status;
  final VoidCallback onTap;

  const VoiceButton({super.key, required this.status, required this.onTap});

  @override
  State<VoiceButton> createState() => _VoiceButtonState();
}

class _VoiceButtonState extends State<VoiceButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _rippleController;

  @override
  void initState() {
    super.initState();
    _rippleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    );
  }

  @override
  void didUpdateWidget(VoiceButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.status == TranslationStatus.recording) {
      _rippleController.repeat();
    } else {
      _rippleController.stop();
      _rippleController.reset();
    }
  }

  @override
  void dispose() {
    _rippleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isRecording = widget.status == TranslationStatus.recording;
    final isProcessing = widget.status == TranslationStatus.processing;

    return GestureDetector(
      onTap: isProcessing ? null : widget.onTap,
      child: SizedBox(
        width: 140,
        height: 140,
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Liquid Ripples
            if (isRecording)
              AnimatedBuilder(
                animation: _rippleController,
                builder: (context, child) {
                  return Stack(
                    alignment: Alignment.center,
                    children: List.generate(3, (index) {
                      final progress =
                          (_rippleController.value + (index * 0.33)) % 1.0;
                      return Container(
                        width: 80 + (progress * 60),
                        height: 80 + (progress * 60),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.cyan.withValues(
                              alpha: (1.0 - progress) * 0.6,
                            ),
                            width: 2,
                          ),
                          color: AppColors.cyan.withValues(
                            alpha: (1.0 - progress) * 0.15,
                          ),
                        ),
                      );
                    }),
                  );
                },
              ),

            // Base Glow Outer Layer
            Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: isRecording
                      ? [AppColors.electricBlue, AppColors.cyan]
                      : [AppColors.royalBlue, AppColors.electricBlue],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: isRecording
                        ? AppColors.cyan.withValues(alpha: 0.6)
                        : AppColors.electricBlue.withValues(alpha: 0.35),
                    blurRadius: isRecording ? 30 : 15,
                    spreadRadius: isRecording ? 5 : 2,
                  ),
                ],
              ),
            ),

            // Inner Icon Container
            Container(
              width: 76,
              height: 76,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.deepNavy.withValues(alpha: 0.3),
              ),
              child: isProcessing
                  ? const Padding(
                      padding: EdgeInsets.all(AppDimensions.paddingMD),
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 3,
                      ),
                    )
                  : Icon(
                      isRecording ? Icons.stop_rounded : Icons.mic_rounded,
                      color: Colors.white,
                      size: AppDimensions.iconXL,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
