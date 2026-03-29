class ResponseEntity {
  final String id;
  final String requestId; // The linked service request
  final String providerId; // The user ID of the provider
  final String message;
  final double? price;
  final DateTime timestamp;

  ResponseEntity({
    required this.id,
    required this.requestId,
    required this.providerId,
    required this.message,
    required this.timestamp,
    this.price,
  });
}
