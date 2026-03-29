class ServiceRequestEntity {
  final String id;
  final String title;
  final String description;
  final String category;
  final List<String> mediaUrls;
  final String? address;
  final double latitude;
  final double longitude;
  final String createdBy; // User ID
  final DateTime timestamp;
  final double? budget;
  final String pricingType; // 'daily', 'monthly', 'completion'

  ServiceRequestEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.mediaUrls,
    this.address,
    required this.latitude,
    required this.longitude,
    required this.createdBy,
    required this.timestamp,
    this.budget,
    required this.pricingType,
  });
}
