import 'dart:typed_data';

import '../../../domain_layer/abstract_repositories.dart';
import '../../dtos/more_info/more_info_field_dto.dart';
import '../../providers.dart';

/// Repository for fetching rendered info files
class MoreInfoRepository implements MoreInfoRepositoryInterface {
  /// Provider
  final MoreInfoProvider _provider;

  /// Creates a new [MoreInfoRepository]
  MoreInfoRepository({
    required MoreInfoProvider provider,
  }) : _provider = provider;

  /// Fetches info file
  @override
  Future<Uint8List> fetchRenderedFile(List<MoreInfoFieldDTO> infoFields) {
    return _provider.fetchRenderedFile(infoFields);
  }
}
