import '../entities/service_response_entity.dart';

abstract class ServiceResponseRepository {
  Future<String> submitResponse(ServiceResponseEntity response);
  Future<List<ServiceResponseEntity>> getResponsesByRequest(String requestId);
  Future<List<ServiceResponseEntity>> getResponsesByProvider(String providerId);
  Future<void> updateResponseStatus(String responseId, String status);
}
