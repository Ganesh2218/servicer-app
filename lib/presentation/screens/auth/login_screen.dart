import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import '../../../core/constants/app_strings.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/app_text.dart';
import '../../../core/utils/location_service.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../core/constants/app_constants.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final AuthController authController = Get.find<AuthController>();

  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController locationController = TextEditingController();

  String? _selectedAddress;
  double? _selectedLat;
  double? _selectedLng;

  final FocusNode _locationFocusNode = FocusNode();

  bool isSignUp = false;

  void _submit() {
    if (_formKey.currentState!.validate()) {
      if (isSignUp) {
        if (_selectedAddress == null) {
          Get.snackbar('Location Required', 'Please select a location from the search results');
          return;
        }
        authController.signUp(
          name: nameController.text.trim(),
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
          address: _selectedAddress,
          latitude: _selectedLat,
          longitude: _selectedLng,
        );
      } else {
        authController.signIn(
          emailController.text.trim(),
          passwordController.text.trim(),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 48),
                AppText(
                  isSignUp ? 'Create an Account' : AppStrings.loginTitle,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor,
                ),
                const SizedBox(height: 8),
                AppText(
                  isSignUp ? 'Join Servicer today' : AppStrings.loginSubtitle,
                  fontSize: 16,
                  color: AppColors.grey,
                ),
                const SizedBox(height: 48),
                if (isSignUp) ...[
                  AppTextField(
                    label: 'Full Name',
                    hintText: 'Enter your full name',
                    controller: nameController,
                    prefixIcon: const Icon(
                      Icons.person_outline,
                      color: AppColors.grey,
                    ),
                    validator: (val) => val == null || val.isEmpty
                        ? AppStrings.requiredField
                        : null,
                  ),
                  const SizedBox(height: 20),
                ],
                AppTextField(
                  label: 'Email Address',
                  hintText: 'Enter your email',
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: const Icon(
                    Icons.email_outlined,
                    color: AppColors.grey,
                  ),
                  validator: (val) {
                    if (val == null || val.isEmpty) {
                      return AppStrings.requiredField;
                    }
                    if (!val.contains('@')) return AppStrings.invalidEmail;
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                AppTextField(
                  label: 'Password',
                  hintText: 'Enter your password',
                  controller: passwordController,
                  obscureText: true,
                  prefixIcon: const Icon(
                    Icons.lock_outline,
                    color: AppColors.grey,
                  ),
                  validator: (val) => val == null || val.length < 6
                      ? 'Password must be at least 6 characters'
                      : null,
                ),
                if (isSignUp) ...[
                  const SizedBox(height: 16),
                  const AppText(
                    'Location',
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryColor,
                  ),
                  const SizedBox(height: 8),
                  GooglePlaceAutoCompleteTextField(
                    textEditingController: locationController,
                    googleAPIKey: AppConstants.mapKey,
                    focusNode: _locationFocusNode,
                    inputDecoration: InputDecoration(
                      labelText: "Location",
                      labelStyle: const TextStyle(color: AppColors.grey, fontFamily: 'Inter', fontSize: 14),
                      hintText: "Search Location...",
                      hintStyle: const TextStyle(color: AppColors.grey, fontFamily: 'Inter', fontSize: 14),
                      prefixIcon: const Icon(Icons.location_on_outlined, color: AppColors.grey),
                      filled: true,
                      fillColor: AppColors.lightBackground,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(color: AppColors.grey.withOpacity(0.3)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide(color: AppColors.grey.withOpacity(0.3)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: const BorderSide(color: AppColors.primaryColor, width: 1.5),
                      ),
                    ),
                    debounceTime: 800,
                    itemClick: (Prediction prediction) {
                      locationController.text = prediction.description!;
                      locationController.selection = TextSelection.fromPosition(
                        TextPosition(offset: prediction.description!.length),
                      );
                      
                      // Fetch coordinates from placeId
                      LocationService.getLatLngFromPlaceId(prediction.placeId!).then((coords) {
                        if (coords != null) {
                          setState(() {
                            _selectedLat = coords['lat'];
                            _selectedLng = coords['lng'];
                          });
                        }
                      });

                      setState(() {
                        _selectedAddress = prediction.description;
                      });
                    },
                    seperatedBuilder: const Divider(),
                    itemBuilder: (context, index, Prediction prediction) {
                      return Container(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          children: [
                            const Icon(Icons.location_on, color: AppColors.grey),
                            const SizedBox(width: 7),
                            Expanded(child: AppText(prediction.description ?? "", fontSize: 14)),
                          ],
                        ),
                      );
                    },
                  ),
                ],
                const SizedBox(height: 32),
                Obx(
                  () => PrimaryButton(
                    isSignUp ? 'Sign Up' : 'Login',
                    isLoading: authController.isLoading.value,
                    onPressed: _submit,
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AppText(
                      isSignUp
                          ? 'Already have an account? '
                          : 'Don\'t have an account? ',
                      color: AppColors.grey,
                    ),
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isSignUp = !isSignUp;
                        });
                      },
                      child: AppText(
                        isSignUp ? 'Login' : 'Sign Up',
                        color: AppColors.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    locationController.dispose();
    _locationFocusNode.dispose();
    super.dispose();
  }
}
