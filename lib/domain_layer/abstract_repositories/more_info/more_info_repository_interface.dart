import 'dart:typed_data';

import '../../models/more_info/more_info_field.dart';

/// Interface for fetching rendered info files
abstract class MoreInfoRepositoryInterface {
  /// Fetch info files
  Future<Uint8List> fetchRenderedFile(List<MoreInfoField> infoFields);
}
