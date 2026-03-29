import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import '../../domain/entities/service_request_entity.dart';
import '../../domain/repositories/service_request_repository.dart';
import '../../domain/repositories/storage_repository.dart';
import '../../core/utils/location_service.dart';
import 'auth_controller.dart';
import 'my_services_controller.dart';
import 'marketplace_controller.dart';
import 'main_navigation_controller.dart';
import '../../core/utils/app_snackbar.dart';

class ServiceRequestController extends GetxController {
  final ServiceRequestRepository _repository;
  final StorageRepository _storageRepository;
  final AuthController _authController = Get.find<AuthController>();

  ServiceRequestController(this._repository, this._storageRepository);

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();
  final budgetController = TextEditingController();
  final locationController = TextEditingController();
  final locationFocusNode = FocusNode();

  var selectedCategory = 'Plumbing'.obs;
  var pickedFiles = <File>[].obs;
  var isLoading = false.obs;
  var address = 'Fetching location...'.obs;
  var selectedPricingType = 'completion'.obs; // 'daily', 'monthly', 'completion'

  double? latitude;
  double? longitude;

  final categories = [
    'Plumbing',
    'Electrical',
    'Cleaning',
    'Beauty',
    'Painting',
    'Moving',
  ];

  @override
  void onInit() {
    super.onInit();
    _fetchCurrentLocation();
  }

  Future<void> updateLocationFromPlaceId(String placeId) async {
    final coords = await LocationService.getLatLngFromPlaceId(placeId);
    if (coords != null) {
      latitude = coords['lat'];
      longitude = coords['lng'];
    }
  }

  Future<void> _fetchCurrentLocation() async {
    final position = await LocationService.getCurrentLocation();
    if (position != null) {
      latitude = position.latitude;
      longitude = position.longitude;
      address.value = await LocationService.getAddressFromLatLng(
        latitude!,
        longitude!,
      );
    } else {
      address.value = 'Could not fetch location';
    }
  }

  Future<void> pickMedia() async {
    if (pickedFiles.length >= 5) {
      AppSnackbar.showError('You can only upload up to 5 files.');
      return;
    }

    try {
      final FilePickerResult? result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.custom,
        allowedExtensions: ['jpg', 'png', 'jpeg', 'mp4', 'pdf', 'doc', 'docx'],
      );

      if (result != null) {
        for (var path in result.paths) {
          if (path != null && pickedFiles.length < 10) {
            pickedFiles.add(File(path));
          }
        }
      }
    } catch (e) {
      AppSnackbar.showError('Failed to pick files');
    }
  }

  void removeFile(int index) {
    pickedFiles.removeAt(index);
  }

  Future<void> createRequest() async {
    if (titleController.text.isEmpty || descriptionController.text.isEmpty) {
      AppSnackbar.showError('Title and Description are required');
      return;
    }

    if (latitude == null || longitude == null) {
      AppSnackbar.showError('Location is required to post a request');
      return;
    }

    isLoading.value = true;
    try {
      final userId = _authController.currentUser.value?.id;
      if (userId == null) throw Exception('User not logged in');

      // 1. Upload Media
      List<String> mediaUrls = [];
      if (pickedFiles.isNotEmpty) {
        mediaUrls = await _storageRepository.uploadMultipleMedia(
          pickedFiles.toList(),
          'service_requests/$userId/${DateTime.now().millisecondsSinceEpoch}',
        );
      }

      // 2. Create Request Entity
      final request = ServiceRequestEntity(
        id: '',
        title: titleController.text.trim(),
        description: descriptionController.text.trim(),
        category: selectedCategory.value,
        mediaUrls: mediaUrls,
        address: address.value,
        latitude: latitude!,
        longitude: longitude!,
        createdBy: userId,
        timestamp: DateTime.now(),
        budget: double.tryParse(budgetController.text.trim()),
        pricingType: selectedPricingType.value,
      );

      // 3. Save to Firestore
      await _repository.createRequest(request);

      // 4. Update relevant controllers
      if (Get.isRegistered<MyServicesController>()) {
        Get.find<MyServicesController>().fetchMyRequests();
      }
      if (Get.isRegistered<MarketplaceController>()) {
        Get.find<MarketplaceController>().fetchRequests();
      }

      // Clear form
      titleController.clear();
      descriptionController.clear();
      budgetController.clear();
      pickedFiles.clear();

      AppSnackbar.showSuccess('Service request posted successfully!');

      // Navigate to Home tab
      Get.find<MainNavigationController>().changeIndex(0);
    } catch (e) {
      AppSnackbar.showError('Something went wrong. Please try again.');
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    titleController.dispose();
    descriptionController.dispose();
    budgetController.dispose();
    locationController.dispose();
    locationFocusNode.dispose();
    super.onClose();
  }
}
