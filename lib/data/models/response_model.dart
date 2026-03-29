import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/response_entity.dart';

class ResponseModel extends ResponseEntity {
  ResponseModel({
    required super.id,
    required super.requestId,
    required super.providerId,
    required super.message,
    required super.timestamp,
    super.price,
  });

  factory ResponseModel.fromJson(Map<String, dynamic> json, String documentId) {
    return ResponseModel(
      id: documentId,
      requestId: json['requestId'] ?? '',
      providerId: json['providerId'] ?? '',
      message: json['message'] ?? '',
      timestamp: (json['timestamp'] as Timestamp).toDate(),
      price: (json['price'] as num?)?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'requestId': requestId,
      'providerId': providerId,
      'message': message,
      'timestamp': Timestamp.fromDate(timestamp),
      'price': price,
    };
  }
}
