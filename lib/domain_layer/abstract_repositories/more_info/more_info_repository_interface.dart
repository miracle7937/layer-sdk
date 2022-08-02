import 'dart:typed_data';

import '../../../data_layer/dtos/more_info/more_info_field_dto.dart';

/// Interface for fetching rendered info files
abstract class MoreInfoRepositoryInterface {
  /// Fetch info files
  Future<Uint8List> fetchRenderedFile(List<MoreInfoFieldDTO> infoFields);
}
