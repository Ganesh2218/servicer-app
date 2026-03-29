import 'dart:io';

abstract class StorageRepository {
  Future<String> uploadMedia(File file, String path);
  Future<List<String>> uploadMultipleMedia(List<File> files, String folderPath);
}
