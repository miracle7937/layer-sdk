import 'dart:io';

import 'package:path_provider/path_provider.dart';

/// A mixin that exposes method for checking existence of file.
mixin FileExistenceCheckerMixin {
  /// Check if file with provided name exists in a platform-specific location.
  Future<bool> isFileExists({
    required String filename,
  }) async {
    final directory = await getApplicationDocumentsDirectory();

    final path = '${directory.path}/$filename';
    final file = File(path);
    return file.exists();
  }

  /// Check if file with provided name exists in a platform-specific location.
  Future<File> getFile({
    required String filename,
  }) async {
    final directory = await getApplicationDocumentsDirectory();

    final path = '${directory.path}/$filename';
    return File(path);
  }
}
