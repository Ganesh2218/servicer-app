class ServiceResponseEntity {
  final String id;
  final String requestId;
  final String providerId;
  final String providerName;
  final String? providerProfileImage;
  final String message;
  final double price;
  final DateTime timestamp;
  final String status; // 'pending', 'accepted', 'rejected'

  ServiceResponseEntity({
    required this.id,
    required this.requestId,
    required this.providerId,
    required this.providerName,
    this.providerProfileImage,
    required this.message,
    required this.price,
    required this.timestamp,
    required this.status,
  });
}
