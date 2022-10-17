import '../../../domain_layer/models.dart';

/// Extension that provides mappings for [FileType].
extension FileTypeMapping on FileType {
  /// Maps into a backend accepted format.
  String toFormat() {
    switch (this) {
      case FileType.pdf:
        return 'pdf';

      case FileType.image:
        return 'image';
    }
  }
}
