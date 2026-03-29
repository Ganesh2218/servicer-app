import 'package:flutter/material.dart';
import '../constants/app_colors.dart';
import 'app_text.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final Color backgroundColor;
  final Color textColor;
  final double width;

  const PrimaryButton(
    this.text, {
    super.key,
    required this.onPressed,
    this.isLoading = false,
    this.backgroundColor = AppColors.primaryColor,
    this.textColor = AppColors.textLight,
    this.width = double.infinity,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        onPressed: isLoading ? null : onPressed,
        child: isLoading
            ? const SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(
                  color: AppColors.background,
                  strokeWidth: 2,
                ),
              )
            : AppText(
                text,
                color: textColor,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
      ),
    );
  }
}
