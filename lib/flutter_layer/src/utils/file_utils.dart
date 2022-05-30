import 'dart:math';

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
}
