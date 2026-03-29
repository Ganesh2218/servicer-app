import '../entities/user_entity.dart';

abstract class AuthRepository {
  Future<UserEntity?> signInWithEmail(String email, String password);
  Future<UserEntity?> signUpWithEmail({
    required String name,
    required String email,
    required String password,
    required String role,
    String? address,
    double? latitude,
    double? longitude,
  });
  Future<void> signOut();
  Future<UserEntity?> getCurrentUser();
  Future<void> saveUserRole(String uid, String role);
  
  Future<void> updateUserProfile({
    required String uid,
    String? name,
    String? profileImage,
  });
}
