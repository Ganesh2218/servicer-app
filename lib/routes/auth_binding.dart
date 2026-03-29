import 'package:get/get.dart';
import '../presentation/controllers/auth_controller.dart';
import '../domain/repositories/auth_repository.dart';
import '../data/repositories/auth_repository_impl.dart';

class AuthBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthRepository>(() => AuthRepositoryImpl());
    Get.put<AuthController>(AuthController(Get.find<AuthRepository>()));
  }
}
