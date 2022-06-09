import '../../../data_layer/network.dart';
import '../../../features/dpa.dart';

/// Use case that uploads an image (a document, or a user signature)
/// for the DPA process variable.
class UploadDPAImageUseCase {
  final DPARepositoryInterface _repository;

  /// Creates a new [UploadDPAImageUseCase] instance.
  const UploadDPAImageUseCase({
    required DPARepositoryInterface repository,
  }) : _repository = repository;

  /// Upload an image (a document, or a user signature, for instance) for the
  /// DPA process variable.
  ///
  /// The variable needs to have a key set and required a file to complete.
  ///
  /// Returns the variable updated with a [DPAFileData].
  /// This helps in doing the validation of the DPA variables, and is not
  /// uploaded to the server for variables.
  ///
  /// The optional [onProgress] can be used to track the upload progress.
  Future<DPAVariable> call({
    required DPAProcess process,
    required DPAVariable variable,
    required String imageName,
    required int imageFileSizeBytes,
    required String imageBase64Data,
    NetProgressCallback? onProgress,
  }) =>
      _repository.uploadImage(
        process: process,
        variable: variable,
        imageName: imageName,
        imageFileSizeBytes: imageFileSizeBytes,
        imageBase64Data: imageBase64Data,
        onProgress: onProgress,
      );
}
