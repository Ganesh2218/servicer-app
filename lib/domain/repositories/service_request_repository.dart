import '../entities/service_request_entity.dart';

abstract class ServiceRequestRepository {
  Future<String> createRequest(ServiceRequestEntity request);
  Future<List<ServiceRequestEntity>> getRequestsByUser(String userId);
  Future<List<ServiceRequestEntity>> getNearbyRequests(double lat, double lng, double radiusInKm);
  Future<List<ServiceRequestEntity>> getAllRequests();
  Future<void> deleteRequest(String requestId);
  Future<void> updateRequest(ServiceRequestEntity request);
}
