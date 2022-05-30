import 'dart:html';

import '../file_utils.dart';

/// Implementation of [FileUtils] for the web platform.
class PlatformFileUtils implements FileUtils {
  @override
  Future<String> saveBytes({
    required String filename,
    required List<int> bytes,
  }) async {
    final data = Uri.dataFromBytes(bytes);

    AnchorElement()
      ..href = '$data'
      ..download = filename
      ..style.display = 'none'
      ..click();

    // TODO: return with the correct file path. Not possible now.
    return filename;
  }
}
