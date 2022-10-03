import 'package:dio/dio.dart';

import '../../../_migration/data_layer/data_layer.dart';
import '../../../data_layer/network.dart';

/// A use case to fetch the customers profile image
class LoadCustomerImageUseCase {
  final FileRepository _repository;
  final NetClient _netClient;

  /// Creates a new [LoadCustomerImageUseCase] instance
  LoadCustomerImageUseCase({
    required FileRepository repository,
    required NetClient netClient,
  })  : _repository = repository,
        _netClient = netClient;

  /// Loads the customer's image
  Future<dynamic> loadCustomerImage({
    required String imageURL,
  }) =>
      _repository.downloadFile(
        url: _netClient.netEndpoints.infobankingLink + imageURL,
        decodeResponse: true,
        responseType: ResponseType.plain,
        queryParameters: {"base64": true},
      );
}
