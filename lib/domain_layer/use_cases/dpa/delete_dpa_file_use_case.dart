import '../../../data_layer/network.dart';
import '../../../features/dpa.dart';

/// Use case that deletes an uploaded file/image on the server.
class DeleteDPAFileUseCase {
  final DPARepositoryInterface _repository;

  /// Creates a new [DeleteDPAFileUseCase] instance.
  const DeleteDPAFileUseCase({
    required DPARepositoryInterface repository,
  }) : _repository = repository;

  /// Deletes an uploaded file/image on the server.
  ///
  /// Returns an updated [DPAVariable], or throws a [NetException] if could
  /// not delete the file.
  ///
  /// Use the [NetProgressCallback] parameter to be notified of progress updates
  Future<DPAVariable> call({
    required DPAProcess process,
    required DPAVariable variable,
    NetProgressCallback? onProgress,
  }) =>
      _repository.deleteFile(
        process: process,
        variable: variable,
        onProgress: onProgress,
      );
}
