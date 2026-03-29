import 'package:get/get.dart';
import '../presentation/controllers/main_navigation_controller.dart';
import '../presentation/controllers/marketplace_controller.dart';
import '../presentation/controllers/service_request_controller.dart';
import '../presentation/controllers/my_services_controller.dart';
import '../presentation/controllers/settings_controller.dart';
import '../domain/repositories/auth_repository.dart';
import '../data/repositories/auth_repository_impl.dart';
import '../domain/repositories/service_request_repository.dart';
import '../domain/repositories/storage_repository.dart';
import '../domain/repositories/service_response_repository.dart';
import '../data/repositories/service_request_repository_impl.dart';
import '../data/repositories/storage_repository_impl.dart';
import '../data/repositories/service_response_repository_impl.dart';

class MainNavigationBinding extends Bindings {
  @override
  void dependencies() {
    // Navigation
    Get.lazyPut<MainNavigationController>(() => MainNavigationController());

    // Repositories
    Get.lazyPut<ServiceRequestRepository>(() => ServiceRequestRepositoryImpl());
    Get.lazyPut<StorageRepository>(() => StorageRepositoryImpl());
    Get.lazyPut<AuthRepository>(() => AuthRepositoryImpl());
    Get.lazyPut<ServiceResponseRepository>(() => ServiceResponseRepositoryImpl());

    // Controllers
    Get.lazyPut<MarketplaceController>(() => MarketplaceController(Get.find(), Get.find()), fenix: true);
    Get.lazyPut<ServiceRequestController>(() => ServiceRequestController(Get.find(), Get.find()), fenix: true);
    Get.lazyPut<MyServicesController>(() => MyServicesController(Get.find()), fenix: true);
    Get.lazyPut<SettingsController>(() => SettingsController(Get.find(), Get.find()), fenix: true);
  }
}
