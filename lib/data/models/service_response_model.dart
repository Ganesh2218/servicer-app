import '../../domain/entities/service_response_entity.dart';

class ServiceResponseModel extends ServiceResponseEntity {
  ServiceResponseModel({
    required super.id,
    required super.requestId,
    required super.providerId,
    required super.providerName,
    super.providerProfileImage,
    required super.message,
    required super.price,
    required super.timestamp,
    required super.status,
  });

  factory ServiceResponseModel.fromJson(Map<String, dynamic> json, String documentId) {
    return ServiceResponseModel(
      id: documentId,
      requestId: json['requestId'] ?? '',
      providerId: json['providerId'] ?? '',
      providerName: json['providerName'] ?? '',
      providerProfileImage: json['providerProfileImage'],
      message: json['message'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      timestamp: json['timestamp'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['timestamp'])
          : DateTime.now(),
      status: json['status'] ?? 'pending',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'requestId': requestId,
      'providerId': providerId,
      'providerName': providerName,
      'providerProfileImage': providerProfileImage,
      'message': message,
      'price': price,
      'timestamp': timestamp.millisecondsSinceEpoch,
      'status': status,
    };
  }
}
