import 'dart:io';

import 'package:path_provider/path_provider.dart';

import '../file_utils.dart';

/// Implementation of [FileUtils] for the mobile platform.
class PlatformFileUtils implements FileUtils {
  @override
  Future<String> saveBytes({
    required String filename,
    required List<int> bytes,
  }) async {
    final directory = await getApplicationDocumentsDirectory();

    final path = '${directory.path}/$filename';

    await File(path).writeAsBytes(bytes);

    return path;
  }
}
