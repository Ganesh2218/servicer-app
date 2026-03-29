import 'package:get/get.dart';
import 'app_routes.dart';
import 'auth_binding.dart';
import 'main_binding.dart';
import 'service_request_binding.dart';
import 'request_detail_binding.dart';
import '../presentation/screens/auth/splash_screen.dart';
import '../presentation/screens/auth/login_screen.dart';

import '../presentation/screens/main_screen.dart';
import '../presentation/screens/create_service_request_screen.dart';
import '../presentation/screens/request_detail_screen.dart';
import '../domain/entities/service_request_entity.dart';

class AppPages {
  static final pages = [
    GetPage(name: Routes.splash, page: () => const SplashScreen()),
    GetPage(
      name: Routes.login,
      page: () => const LoginScreen(),
      binding: AuthBinding(),
    ),

    GetPage(
      name: Routes.main,
      page: () => const MainScreen(),
      binding: MainNavigationBinding(),
    ),
    GetPage(
      name: Routes.createServiceRequest,
      page: () => const CreateServiceRequestScreen(),
      binding: ServiceRequestBinding(),
    ),
    GetPage(
      name: Routes.requestDetails,
      page: () =>
          RequestDetailScreen(request: Get.arguments as ServiceRequestEntity),
      binding: RequestDetailBinding(),
    ),
  ];
}
