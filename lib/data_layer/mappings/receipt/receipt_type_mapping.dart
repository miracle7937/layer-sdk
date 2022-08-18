import '../../../domain_layer/models.dart';

/// Extension that provides mappings for [ReceiptType].
extension ReceiptTypeMapping on ReceiptType {
  /// Maps into a backend accepted format.
  String toFormat() {
    switch (this) {
      case ReceiptType.pdf:
        return 'pdf';

      case ReceiptType.image:
        return 'image';
    }
  }
}
