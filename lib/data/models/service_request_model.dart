import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/service_request_entity.dart';

class ServiceRequestModel extends ServiceRequestEntity {
  ServiceRequestModel({
    required super.id,
    required super.title,
    required super.description,
    required super.category,
    required super.mediaUrls,
    super.address,
    required super.latitude,
    required super.longitude,
    required super.createdBy,
    required super.timestamp,
    super.budget,
  });

  factory ServiceRequestModel.fromJson(Map<String, dynamic> json, String documentId) {
    final location = json['location'] as Map<String, dynamic>?;
    return ServiceRequestModel(
      id: documentId,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      category: json['category'] ?? '',
      mediaUrls: List<String>.from(json['mediaUrls'] ?? []),
      address: location?['address'] ?? json['address'],
      latitude: (location?['lat'] as num?)?.toDouble() ?? (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (location?['lng'] as num?)?.toDouble() ?? (json['longitude'] as num?)?.toDouble() ?? 0.0,
      createdBy: json['createdBy'] ?? '',
      timestamp: (json['timestamp'] as Timestamp).toDate(),
      budget: (json['budget'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'category': category,
      'mediaUrls': mediaUrls,
      'location': {
        'address': address,
        'lat': latitude,
        'lng': longitude,
      },
      'createdBy': createdBy,
      'timestamp': Timestamp.fromDate(timestamp),
      'budget': budget,
    };
  }
}
