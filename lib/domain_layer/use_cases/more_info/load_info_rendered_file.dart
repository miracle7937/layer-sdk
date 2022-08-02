import 'dart:typed_data';

import '../../../data_layer/dtos/more_info/more_info_field_dto.dart';
import '../../abstract_repositories.dart';

/// Usecase for fetching rendered info files
class LoadInfoRendedFileUseCase {
  final MoreInfoRepositoryInterface _repository;

  /// Creates a new [LoadInfoRendedFileUseCase]
  LoadInfoRendedFileUseCase({
    required MoreInfoRepositoryInterface repository,
  }) : _repository = repository;

  /// Callable that fetches the file
  Future<Uint8List> call({required List<MoreInfoFieldDTO> infoFields}) {
    return _repository.fetchRenderedFile(infoFields);
  }
}
