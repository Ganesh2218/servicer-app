import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/response_entity.dart';
import '../../domain/repositories/response_repository.dart';
import '../models/response_model.dart';

class ResponseRepositoryImpl implements ResponseRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<String> submitResponse(ResponseEntity response) async {
    final model = ResponseModel(
      id: '',
      requestId: response.requestId,
      providerId: response.providerId,
      message: response.message,
      timestamp: response.timestamp,
      price: response.price,
    );

    final docRef = await _firestore.collection('responses').add(model.toJson());
    return docRef.id;
  }

  @override
  Future<List<ResponseEntity>> getResponsesForRequest(String requestId) async {
    final snapshot = await _firestore
        .collection('responses')
        .where('requestId', isEqualTo: requestId)
        .orderBy('timestamp', descending: true)
        .get();

    return snapshot.docs.map((doc) => ResponseModel.fromJson(doc.data(), doc.id)).toList();
  }

  @override
  Future<List<ResponseEntity>> getResponsesByProvider(String providerId) async {
    final snapshot = await _firestore
        .collection('responses')
        .where('providerId', isEqualTo: providerId)
        .orderBy('timestamp', descending: true)
        .get();

    return snapshot.docs.map((doc) => ResponseModel.fromJson(doc.data(), doc.id)).toList();
  }
}
