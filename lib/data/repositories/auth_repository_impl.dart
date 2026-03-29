import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../models/user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  // Use getters to avoid accessing .instance before checking initialization
  FirebaseAuth get _firebaseAuth => FirebaseAuth.instance;
  FirebaseFirestore get _firestore => FirebaseFirestore.instance;

  // Helper to check if Firebase is ready to be used
  bool get _isFirebaseReady => Firebase.apps.isNotEmpty;

  @override
  Future<UserEntity?> signInWithEmail(String email, String password) async {

    if (!_isFirebaseReady) return null;
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user != null) {
        return await _getUserFromFirestore(credential.user!.uid);
      }
      return null;
    } catch (e) {

      return null;
    }
  }

  @override
  Future<UserEntity?> signUpWithEmail({
    required String name,
    required String email,
    required String password,
    required String role,
    String? address,
    double? latitude,
    double? longitude,
  }) async {
    if (!_isFirebaseReady) return null;
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (credential.user != null) {
        UserModel newUser = UserModel(
          id: credential.user!.uid,
          name: name,
          email: email,
          role: role,
          address: address,
          latitude: latitude,
          longitude: longitude,
        );

        await _firestore
            .collection('users')
            .doc(newUser.id)
            .set(newUser.toJson());
        return newUser;
      }
      return null;
    } catch (e) {
      debugPrint("Sign up error: $e");
      rethrow;
    }
  }

  @override
  Future<void> signOut() async {
    if (!_isFirebaseReady) return;
    try {
      await _firebaseAuth.signOut();
    } catch (_) {}
  }

  @override
  Future<UserEntity?> getCurrentUser() async {
    if (!_isFirebaseReady) return null;
    try {
      final user = _firebaseAuth.currentUser;
      if (user != null) {
        return await _getUserFromFirestore(user.uid);
      }
    } catch (_) {}
    return null;
  }

  Future<UserEntity?> _getUserFromFirestore(String uid) async {
    if (!_isFirebaseReady) return null;
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        return UserModel.fromJson(doc.data()!, doc.id);
      }
    } catch (e) {
      debugPrint("Error fetching user from Firestore: $e");
    }
    return null;
  }

  @override
  Future<void> saveUserRole(String uid, String role) async {
    if (!_isFirebaseReady) return;
    try {
      await _firestore.collection('users').doc(uid).update({'role': role});
    } catch (_) {}
  }

  @override
  Future<void> updateUserProfile({
    required String uid,
    String? name,
    String? profileImage,
  }) async {
    if (!_isFirebaseReady) return;
    try {
      final Map<String, dynamic> updateData = {};
      if (name != null) updateData['name'] = name;
      if (profileImage != null) updateData['profileImage'] = profileImage;

      if (updateData.isNotEmpty) {
        await _firestore.collection('users').doc(uid).update(updateData);
      }
    } catch (e) {
      throw Exception("Failed to update profile: $e");
    }
  }

  @override
  Future<UserEntity?> getUserById(String uid) => _getUserFromFirestore(uid);
}
