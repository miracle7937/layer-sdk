import 'dart:convert';
import 'dart:typed_data';

/// Encoding/decoding helper methods.
class CodecUtils {
  /// Returns a string with the bytes encoded as an image.
  ///
  /// [format] is the format of the image. Defaults to `jpeg`.
  ///
  /// Useful for uploading files to the server.
  String encodeBase64Image(
    Uint8List bytes, {
    String format = 'jpeg',
  }) =>
      'data:image/$format;base64,${base64Encode(bytes)}';

  /// Returns a string with the bytes encoded as a PDF.
  ///
  /// Useful for uploading files to the server.
  String encodeBase64PDF(Uint8List bytes) =>
      'data:application/pdf;base64,${base64Encode(bytes)}';

  /// Decodes a base64 encoded string into a list of bytes.
  ///
  /// To decode this base64 properly is necessary to part the [Uri]
  /// `Uri.parse(base64File).data?.contentAsBytes()`
  Uint8List decodeBase64(String encodedString) => base64.decode(encodedString);
}
