import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'core/constants/app_colors.dart';
import 'core/constants/app_strings.dart';
import 'core/utils/shared_pref.dart';
import 'core/utils/notification_service.dart';
import 'routes/app_pages.dart';
import 'routes/app_routes.dart';
import 'routes/auth_binding.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Shared Preferences
  await SharedPrefs.init();

  // Initialize Firebase (Requires flutterfire configure to generate DefaultFirebaseOptions)
  try {
    await Firebase.initializeApp();
    /* await FirebaseAppCheck.instance.activate(
      androidProvider: AndroidProvider.playIntegrity, // for now
    ); */
    await NotificationService.initialize();
  } catch (e) {
    debugPrint(
      "Firebase init failed (Likely missing flutterfire configure): $e",
    );
  }

  runApp(const ServicerApp());
}

class ServicerApp extends StatelessWidget {
  const ServicerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: AppColors.primaryColor,
        scaffoldBackgroundColor: AppColors.background,
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primaryColor,
          secondary: AppColors.accentColor,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.primaryColor,
          foregroundColor: AppColors.textLight,
          centerTitle: true,
          elevation: 0,
        ),
        fontFamily: 'Inter', // Add font to pubspec if desired later
      ),
      initialRoute: Routes.splash,
      initialBinding: AuthBinding(),
      getPages: AppPages.pages,
    );
  }
}
