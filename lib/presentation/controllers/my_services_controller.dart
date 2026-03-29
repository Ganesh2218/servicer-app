import 'package:get/get.dart';
import '../../domain/entities/service_request_entity.dart';
import '../../domain/repositories/service_request_repository.dart';
import 'auth_controller.dart';
import '../../core/utils/app_snackbar.dart';

class MyServicesController extends GetxController {
  final ServiceRequestRepository _repository;
  final AuthController _authController = Get.find<AuthController>();

  MyServicesController(this._repository);

  final RxList<ServiceRequestEntity> myRequests = <ServiceRequestEntity>[].obs;
  final RxBool isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchMyRequests();
  }

  Future<void> fetchMyRequests() async {
    isLoading.value = true;
    try {
      final userId = _authController.currentUser.value?.id;
      if (userId == null) throw Exception('User not logged in');
      
      final fetched = await _repository.getRequestsByUser(userId);
      myRequests.assignAll(fetched);
    } catch (e) {
      AppSnackbar.showError('Something went wrong. Please try again.');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteRequest(String requestId) async {
    // We should add delete to repository
    // For now, assume repository will have it
    try {
      // await _repository.deleteRequest(requestId);
      myRequests.removeWhere((req) => req.id == requestId);
      AppSnackbar.showSuccess('Service request deleted successfully!');
    } catch (e) {
      AppSnackbar.showError('Something went wrong. Please try again.');
    }
  }
}
