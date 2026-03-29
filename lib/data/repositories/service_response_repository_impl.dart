import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/service_response_entity.dart';
import '../../domain/repositories/service_response_repository.dart';
import '../models/service_response_model.dart';

class ServiceResponseRepositoryImpl implements ServiceResponseRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<String> submitResponse(ServiceResponseEntity response) async {
    final model = ServiceResponseModel(
      id: '',
      requestId: response.requestId,
      providerId: response.providerId,
      providerName: response.providerName,
      providerProfileImage: response.providerProfileImage,
      message: response.message,
      price: response.price,
      timestamp: response.timestamp,
      status: response.status,
    );

    final docRef = await _firestore.collection('responses').add(model.toJson());
    return docRef.id;
  }

  @override
  Future<List<ServiceResponseEntity>> getResponsesByRequest(String requestId) async {
    final snapshot = await _firestore
        .collection('responses')
        .where('requestId', isEqualTo: requestId)
        .orderBy('timestamp', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => ServiceResponseModel.fromJson(doc.data(), doc.id))
        .toList();
  }

  @override
  Future<List<ServiceResponseEntity>> getResponsesByProvider(String providerId) async {
    final snapshot = await _firestore
        .collection('responses')
        .where('providerId', isEqualTo: providerId)
        .orderBy('timestamp', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => ServiceResponseModel.fromJson(doc.data(), doc.id))
        .toList();
  }

  @override
  Future<void> updateResponseStatus(String responseId, String status) async {
    await _firestore
        .collection('responses')
        .doc(responseId)
        .update({'status': status});
  }
}
