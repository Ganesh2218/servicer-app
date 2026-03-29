import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/service_request_entity.dart';
import '../../domain/repositories/service_request_repository.dart';
import '../models/service_request_model.dart';
import 'package:geolocator/geolocator.dart'; // To calculate distance

class ServiceRequestRepositoryImpl implements ServiceRequestRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<String> createRequest(ServiceRequestEntity request) async {
    final model = ServiceRequestModel(
      id: '', // Firestore will generate
      title: request.title,
      description: request.description,
      category: request.category,
      mediaUrls: request.mediaUrls,
      address: request.address,
      latitude: request.latitude,
      longitude: request.longitude,
      createdBy: request.createdBy,
      timestamp: request.timestamp,
      budget: request.budget,
    );

    final docRef = await _firestore
        .collection('service_requests')
        .add(model.toJson());
    return docRef.id;
  }

  @override
  Future<List<ServiceRequestEntity>> getRequestsByUser(String userId) async {
    final snapshot = await _firestore
        .collection('service_requests')
        .where('createdBy', isEqualTo: userId)
        .orderBy('timestamp', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => ServiceRequestModel.fromJson(doc.data(), doc.id))
        .toList();
  }

  @override
  Future<List<ServiceRequestEntity>> getAllRequests() async {
    final snapshot = await _firestore
        .collection('service_requests')
        .orderBy('timestamp', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => ServiceRequestModel.fromJson(doc.data(), doc.id))
        .toList();
  }

  @override
  Future<List<ServiceRequestEntity>> getNearbyRequests(
    double lat,
    double lng,
    double radiusInKm,
  ) async {
    // For MVP, fetch all and filter client side.
    // In production, use GeoFlutterFire or similar for server-side filtering.
    final allRequests = await getAllRequests();

    return allRequests.where((req) {
      double distanceInMeters = Geolocator.distanceBetween(
        lat,
        lng,
        req.latitude,
        req.longitude,
      );
      double distanceInKm = distanceInMeters / 1000;
      return distanceInKm <= radiusInKm;
    }).toList();
  }

  @override
  Future<void> deleteRequest(String requestId) async {
    await _firestore.collection('service_requests').doc(requestId).delete();
  }

  @override
  Future<void> updateRequest(ServiceRequestEntity request) async {
    final model = ServiceRequestModel(
      id: request.id,
      title: request.title,
      description: request.description,
      category: request.category,
      mediaUrls: request.mediaUrls,
      latitude: request.latitude,
      longitude: request.longitude,
      createdBy: request.createdBy,
      timestamp: request.timestamp,
      budget: request.budget,
    );
    await _firestore
        .collection('service_requests')
        .doc(request.id)
        .update(model.toJson());
  }
}
