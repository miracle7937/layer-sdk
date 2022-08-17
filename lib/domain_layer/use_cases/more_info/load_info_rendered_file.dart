import 'dart:typed_data';

import '../../abstract_repositories.dart';
import '../../models/more_info/more_info_field.dart';

/// Usecase for fetching rendered info files
class LoadInfoRenderedFileUseCase {
  final MoreInfoRepositoryInterface _repository;

  /// Creates a new [LoadInfoRenderedFileUseCase]
  LoadInfoRenderedFileUseCase({
    required MoreInfoRepositoryInterface repository,
  }) : _repository = repository;

  /// Callable that fetches the file by the list of [MoreInfoField]
  ///
  /// The server returns a binary list with all data to be rendered as pdf
  Future<Uint8List> call({
    required List<MoreInfoField> infoFields,
  }) =>
      _repository.fetchRenderedFile(infoFields);
}
