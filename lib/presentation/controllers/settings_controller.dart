import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/storage_repository.dart';
import 'auth_controller.dart';
import '../../core/utils/app_snackbar.dart';

class SettingsController extends GetxController {
  final AuthRepository _authRepository;
  final StorageRepository _storageRepository;
  final AuthController _authController = Get.find<AuthController>();

  SettingsController(this._authRepository, this._storageRepository);

  final nameController = TextEditingController();
  final Rx<File?> selectedImage = Rx<File?>(null);
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    nameController.text = _authController.currentUser.value?.name ?? '';
  }

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      selectedImage.value = File(image.path);
    }
  }

  Future<void> updateProfile() async {
    final user = _authController.currentUser.value;
    if (user == null) return;

    isLoading.value = true;
    try {
      String? imageUrl;
      if (selectedImage.value != null) {
        imageUrl = await _storageRepository.uploadMedia(
          selectedImage.value!,
          'profiles/${user.id}',
        );
      }

      await _authRepository.updateUserProfile(
        uid: user.id,
        name: nameController.text.trim(),
        profileImage: imageUrl,
      );

      // Refresh local user data
      await _authController.checkAuthStatus();
      AppSnackbar.showSuccess('Profile updated successfully!');
    } catch (e) {
      AppSnackbar.showError('Something went wrong. Please try again.');
    } finally {
      isLoading.value = false;
    }
  }

  void logout() {
    _authController.signOut();
  }

  @override
  void onClose() {
    nameController.dispose();
    super.onClose();
  }
}
