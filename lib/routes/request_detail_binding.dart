import 'package:get/get.dart';
import '../data/repositories/service_response_repository_impl.dart';
import '../domain/repositories/service_response_repository.dart';
import '../presentation/controllers/offer_controller.dart';

class RequestDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ServiceResponseRepository>(
      () => ServiceResponseRepositoryImpl(),
      fenix: true,
    );
    Get.lazyPut<OfferController>(
      () => OfferController(Get.find()),
      fenix: true,
    );
  }
}
