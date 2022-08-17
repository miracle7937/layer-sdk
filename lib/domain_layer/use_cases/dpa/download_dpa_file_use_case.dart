import '../../../data_layer/network.dart';
import '../../../features/dpa.dart';

/// Use case that downloads a base64 encoded file from the server.
class DownloadDPAFileUseCase {
  final DPARepositoryInterface _repository;

  /// Creates a new [DownloadDPAFileUseCase] instance.
  const DownloadDPAFileUseCase({
    required DPARepositoryInterface repository,
  }) : _repository = repository;

  /// Downloads a base64 encoded file from the server.
  ///
  /// Returns null if the download fails.
  ///
  /// Use the [NetProgressCallback] parameter to be notified of progress updates
  Future<String?> call({
    required DPAProcess process,
    required DPAVariable variable,
    NetProgressCallback? onProgress,
  }) =>
      _repository.downloadFile(
        process: process,
        variable: variable,
        onProgress: onProgress,
      );
}
