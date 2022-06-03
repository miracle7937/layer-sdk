import '../../../../data_layer/network.dart';
import '../../providers.dart';

/// A repository focused on generic file management on the servers.
class FileRepository {
  final FileProvider _fileProvider;

  /// Creates a new repository with the supplied [FileProvider].
  FileRepository({
    required FileProvider fileProvider,
  }) : _fileProvider = fileProvider;

  /// Downloads a file based on the given [url].
  Future<dynamic> downloadFile({
    required String url,
    Map<String, dynamic> queryParameters = const <String, dynamic>{},
    bool forceRefresh = false,
    NetProgressCallback? onReceiveProgress,
  }) async {
    return await _fileProvider.downloadFile(
      url: url,
      queryParameters: queryParameters,
      forceRefresh: forceRefresh,
      onReceiveProgress: onReceiveProgress,
    );
  }
}
