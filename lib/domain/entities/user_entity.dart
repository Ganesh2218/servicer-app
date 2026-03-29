class UserEntity {
  final String id;
  final String name;
  final String email;
  final String role; // 'Customer' or 'Service Provider'
  final double? rating;
  final String? address;
  final double? latitude;
  final double? longitude;
  final String? profileImage;

  UserEntity({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    this.address,
    this.rating,
    this.latitude,
    this.longitude,
    this.profileImage,
  });
}
