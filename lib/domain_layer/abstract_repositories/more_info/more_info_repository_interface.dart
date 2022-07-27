import 'dart:typed_data';

import '../../models.dart';

/// Interface for fetching rendered info files
abstract class MoreInfoRepositoryInterface {
  /// Fetch info files
  Future<Uint8List> fetchRenderedFile(List<MoreInfoField> infoFields);
}
