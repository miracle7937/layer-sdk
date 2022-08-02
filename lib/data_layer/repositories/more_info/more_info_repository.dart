import 'dart:typed_data';

import '../../../domain_layer/abstract_repositories.dart';
import '../../../domain_layer/models/more_info/more_info_field.dart';
import '../../mappings.dart';
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
  Future<Uint8List> fetchRenderedFile(List<MoreInfoField> infoFields) {
    return _provider.fetchRenderedFile(
      infoFields.map((field) => field.toMoreInfoFieldDTO()).toList(
            growable: false,
          ),
    );
  }
}
