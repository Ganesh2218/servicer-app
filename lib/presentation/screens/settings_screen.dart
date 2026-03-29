import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../core/constants/app_colors.dart';
import '../../core/widgets/app_text.dart';
import '../../core/widgets/app_text_field.dart';
import '../../core/widgets/primary_button.dart';
import '../controllers/settings_controller.dart';
import '../controllers/auth_controller.dart';

class SettingsScreen extends GetView<SettingsController> {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthController authController = Get.find<AuthController>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        actions: [
          IconButton(
            onPressed: () => controller.logout(),
            icon: const Icon(Icons.logout, color: AppColors.error),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Profile Image Section
            Center(
              child: Stack(
                children: [
                  Obx(() {
                    final currentUser = authController.currentUser.value;
                    final selectedImage = controller.selectedImage.value;

                    return CircleAvatar(
                      radius: 60,
                      backgroundColor: AppColors.lightGrey,
                      backgroundImage: selectedImage != null
                          ? FileImage(selectedImage)
                          : (currentUser?.profileImage != null
                                  ? NetworkImage(currentUser!.profileImage!)
                                  : null)
                              as ImageProvider?,
                      child: (selectedImage == null && currentUser?.profileImage == null)
                          ? const Icon(Icons.person, size: 60, color: AppColors.grey)
                          : null,
                    );
                  }),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: controller.pickImage,
                      child: const CircleAvatar(
                        radius: 18,
                        backgroundColor: AppColors.primaryColor,
                        child: Icon(Icons.camera_alt, size: 18, color: Colors.white),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            
            // Name Field
            AppTextField(
              hintText: 'Full Name',
              controller: controller.nameController,
              prefixIcon: const Icon(Icons.person_outline),
            ),
            const SizedBox(height: 16),
            
            // Role (Display only)
            Obx(() => Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.lightGrey.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.work_outline, color: AppColors.grey),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const AppText('User Role', fontSize: 12, color: AppColors.grey),
                      AppText(
                        authController.currentUser.value?.role ?? 'Unknown',
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ],
                  ),
                ],
              ),
            )),
            const SizedBox(height: 16),
            
            // Email (Display only)
            Obx(() => Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.lightGrey.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.email_outlined, color: AppColors.grey),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const AppText('Email Address', fontSize: 12, color: AppColors.grey),
                      AppText(
                        authController.currentUser.value?.email ?? 'Unknown',
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ],
                  ),
                ],
              ),
            )),
            const SizedBox(height: 32),
            
            // Save Button
            Obx(() => PrimaryButton(
              'Save Changes',
              isLoading: controller.isLoading.value,
              onPressed: () => controller.updateProfile(),
            )),
            
            const SizedBox(height: 48),
            // Version Info
            const AppText(
              'Servicer v1.0.0',
              color: AppColors.grey,
              fontSize: 12,
            ),
          ],
        ),
      ),
    );
  }
}
