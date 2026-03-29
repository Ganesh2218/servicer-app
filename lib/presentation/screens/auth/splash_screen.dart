import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/widgets/app_text.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // In a real app, logic to navigate based on auth state would be in a SplashController
    // We will just show a UI skeleton for now
    return Scaffold(
      backgroundColor: AppColors.primaryColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const AppText(
              AppStrings.appName,
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: AppColors.textLight,
            ),
            const SizedBox(height: 24),
            const CircularProgressIndicator(
              color: AppColors.accentColor,
            ),
          ],
        ),
      ),
    );
  }
}
