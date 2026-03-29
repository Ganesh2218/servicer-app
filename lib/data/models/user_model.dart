import '../../domain/entities/user_entity.dart';

class UserModel extends UserEntity {
  UserModel({
    required super.id,
    required super.name,
    required super.email,
    required super.role,
    super.address,
    super.rating,
    super.latitude,
    super.longitude,
    super.profileImage,
  });

  factory UserModel.fromJson(Map<String, dynamic> json, String documentId) {
    final location = json['location'] as Map<String, dynamic>?;
    return UserModel(
      id: documentId,
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? 'service_provider',
      address: location?['address'] ?? json['address'],
      rating: (json['rating'] as num?)?.toDouble(),
      latitude: (location?['lat'] as num?)?.toDouble() ?? (json['latitude'] as num?)?.toDouble(),
      longitude: (location?['lng'] as num?)?.toDouble() ?? (json['longitude'] as num?)?.toDouble(),
      profileImage: json['profileImage'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'role': role,
      'rating': rating,
      'location': {
        'address': address,
        'lat': latitude,
        'lng': longitude,
      },
      'profileImage': profileImage,
    };
  }
}
