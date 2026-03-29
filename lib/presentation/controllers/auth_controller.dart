import 'package:get/get.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/entities/user_entity.dart';
import '../../routes/app_routes.dart';
import '../../core/utils/shared_pref.dart';
import '../../core/utils/app_snackbar.dart';

class AuthController extends GetxController {
  final AuthRepository _authRepository;

  AuthController(this._authRepository);

  final Rx<UserEntity?> currentUser = Rx<UserEntity?>(null);
  final RxBool isLoading = false.obs;

  @override
  void onReady() {
    super.onReady();
    // Small delay to ensure the splash screen is seen and navigator is ready
    Future.delayed(const Duration(seconds: 2), () {
      checkAuthStatus();
    });
  }

  Future<void> checkAuthStatus() async {
    isLoading.value = true;
    try {
      final user = await _authRepository.getCurrentUser();
      currentUser.value = user;

      if (user != null) {
        SharedPrefs.saveUserId(user.id);
        if (user.role.isNotEmpty) {
          SharedPrefs.saveUserRole(user.role);
          Get.offAllNamed(Routes.main);
        } else {
          // If role is somehow missing, assign default and go to main
          await setRole('service_provider');
        }
      } else {
        Get.offAllNamed(Routes.login);
      }
    } catch (e) {
      AppSnackbar.showError('Failed to check authentication state');
      Get.offAllNamed(Routes.login);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signIn(String email, String password) async {
    isLoading.value = true;
    try {
      final user = await _authRepository.signInWithEmail(email, password);
      if (user != null) {
        currentUser.value = user;
        SharedPrefs.saveUserId(user.id);

        if (user.role.isNotEmpty) {
          SharedPrefs.saveUserRole(user.role);
          Get.offAllNamed(Routes.main);
        } else {
          await setRole('service_provider');
        }
      } else {
        AppSnackbar.showError('Invalid credentials or user not found');
      }
    } catch (e) {
      AppSnackbar.showError('An error occurred during sign in');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signUp({
    required String name,
    required String email,
    required String password,
    String? address,
    double? latitude,
    double? longitude,
  }) async {
    isLoading.value = true;
    try {
      final user = await _authRepository.signUpWithEmail(
        name: name,
        email: email,
        password: password,
        role: 'service_provider',
        address: address,
        latitude: latitude,
        longitude: longitude,
      );
      if (user != null) {
        currentUser.value = user;
        SharedPrefs.saveUserId(user.id);
        SharedPrefs.saveUserRole(user.role);
        Get.offAllNamed(Routes.main);
        AppSnackbar.showSuccess('Account created successfully!');
      }
    } catch (e) {
      AppSnackbar.showError('Sign up failed. Please try again.');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> setRole(String role) async {
    if (currentUser.value == null) return;

    isLoading.value = true;
    try {
      await _authRepository.saveUserRole(currentUser.value!.id, role);
      SharedPrefs.saveUserRole(role);

      final updatedUser = await _authRepository.getCurrentUser();
      currentUser.value = updatedUser;

      Get.offAllNamed(Routes.main);
    } catch (e) {
      AppSnackbar.showError('Failed to update authentication profile');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> signOut() async {
    await _authRepository.signOut();
    await SharedPrefs.clearUser();
    currentUser.value = null;
    Get.offAllNamed(Routes.login);
  }

  // Removed _navigateBasedOnRole as it's no longer needed (all go to main)
}
