import 'package:get/get.dart';
import '../data/repositories/service_request_repository_impl.dart';
import '../data/repositories/storage_repository_impl.dart';
import '../domain/repositories/service_request_repository.dart';
import '../domain/repositories/storage_repository.dart';
import '../presentation/controllers/service_request_controller.dart';

class ServiceRequestBinding extends Bindings {
  @override
  void dependencies() {
    // Repositories
    Get.lazyPut<ServiceRequestRepository>(() => ServiceRequestRepositoryImpl());
    Get.lazyPut<StorageRepository>(() => StorageRepositoryImpl());
    
    // Controller
    Get.lazyPut<ServiceRequestController>(() => ServiceRequestController(
      Get.find<ServiceRequestRepository>(),
      Get.find<StorageRepository>(),
    ));
  }
}
