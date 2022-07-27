import 'dart:typed_data';

import '../../abstract_repositories.dart';
import '../../models.dart';

/// Usecase for fetching rendered info files
class LoadInfoRendedFileUseCase {
  final MoreInfoRepositoryInterface _repository;

  /// Creates a new [LoadInfoRendedFileUseCase]
  LoadInfoRendedFileUseCase({
    required MoreInfoRepositoryInterface repository,
  }) : _repository = repository;

  /// Callable that fetches the file
  Future<Uint8List> call({required List<MoreInfoField> infoFields}) {
    return _repository.fetchRenderedFile(infoFields);
  }
}
