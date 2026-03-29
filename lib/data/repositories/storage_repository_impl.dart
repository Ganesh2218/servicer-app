import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import '../../domain/repositories/storage_repository.dart';

class StorageRepositoryImpl implements StorageRepository {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  @override
  Future<String> uploadMedia(File file, String path) async {
    try {
      final ref = _storage.ref().child(path);
      final uploadTask = await ref.putFile(file);
      return await uploadTask.ref.getDownloadURL();
    } catch (e) {
      throw Exception('Failed to upload media: ${e.toString()}');
    }
  }

  @override
  Future<List<String>> uploadMultipleMedia(List<File> files, String folderPath) async {
    try {
      List<String> urls = [];
      for (var file in files) {
        final fileName = '${DateTime.now().millisecondsSinceEpoch}_${file.path.split('/').last}';
        final path = '$folderPath/$fileName';
        final url = await uploadMedia(file, path);
        urls.add(url);
      }
      return urls;
    } catch (e) {
      throw Exception('Failed to upload multiple media: ${e.toString()}');
    }
  }
}
