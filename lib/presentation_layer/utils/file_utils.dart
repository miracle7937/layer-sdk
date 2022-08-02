import 'dart:core';
import 'dart:io';
import 'dart:math';

import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

import 'platform/file_utils_mobile.dart'
    if (dart.library.html) 'platform/file_utils_web.dart';

/// Wrapper over the platform-specific file utils.
abstract class FileUtils {
  /// Creates a new [FileUtils] based on the current platform.
  factory FileUtils() => PlatformFileUtils();

  /// Saves a new file on a platform-specific location, with the given
  /// filename and content (in bytes).
  ///
  /// Returns the complete path to said file.
  Future<String> saveBytes({
    required String filename,
    required List<int> bytes,
  });

  /// Returns the file size.
  // TODO: refactor this for better code and to use translations if needed.
  static String formatBytes({
    required int bytes,
    int decimals = 2,
  }) {
    const suffixes = ["B", "KB", "MB", "GB", "TB", "PB", "EB", "ZB", "YB"];

    if (bytes <= 0) return '0 ${suffixes[0]}';

    final index = (log(bytes) / log(1024)).floor();
    final value = (bytes / pow(1024, index)).toStringAsFixed(decimals);

    return '$value ${suffixes[index]}';
  }

  /// Opens the more info pdf
  static Future<void> getMoreInfoPdf(
    List<int> bytes,
    String? id, {
    bool isImage = false,
  }) async {
    final appDocDir = await getApplicationDocumentsDirectory();
    final appPath = appDocDir.path;
    final fileFormat = isImage ? "png" : "pdf";
    final path = '$appPath/more_info${id != null ? "_$id" : ""}.$fileFormat';
    final file = File(path);
    await file.writeAsBytes(bytes);

    OpenFile.open(
      file.path,
      uti: isImage ? 'public.jpeg' : 'com.adobe.pdf',
      type: isImage ? 'image/jpeg' : 'application/pdf',
    );
  }
}
