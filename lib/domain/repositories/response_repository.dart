import '../entities/response_entity.dart';

abstract class ResponseRepository {
  Future<String> submitResponse(ResponseEntity response);
  Future<List<ResponseEntity>> getResponsesForRequest(String requestId);
  Future<List<ResponseEntity>> getResponsesByProvider(String providerId);
}
