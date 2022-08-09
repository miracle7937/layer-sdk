import 'package:open_file/open_file.dart';

import '../../../layer_sdk.dart';

/// Use case responsible for sharing receipt.
class ShareReceiptUseCase {
  /// Creates a new [ShareReceiptUseCase] instance.
  const ShareReceiptUseCase();

  /// Saves the provided [bytes] of receipt to file with [filename].
  /// If [checkExistence] is true,
  /// then existence of [filename] is being checked at first:
  /// - file exists - return existing file;
  /// - file doesn't exist - return newly saved file.
  Future<void> call({
    required String filename,
    required List<int> bytes,
    bool checkExistence = false,
  }) async {
    final fileUtils = FileUtils();
    final fileExists = await fileUtils.isFileExists(filename: filename);
    var path = '';
    if (checkExistence && fileExists) {
      path = (await fileUtils.getFile(filename: filename)).path;
    } else {
      path = await FileUtils().saveBytes(
        filename: filename,
        bytes: bytes,
      );
    }
    OpenFile.open(
      path,
    );
  }
}
