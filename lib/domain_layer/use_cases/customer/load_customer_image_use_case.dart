import 'dart:typed_data';

import '../../abstract_repositories.dart';

/// Use case to get the customer's image
class LoadCustomerImageUseCase {
  final CustomerRepositoryInterface _repository;

  /// Creates a new [LoadCustomerImageUseCase]
  LoadCustomerImageUseCase({
    required CustomerRepositoryInterface repository,
  }) : _repository = repository;

  /// Fetches the currently logged in customer image
  Future<Uint8List?> call({required String imageURL}) =>
      _repository.getCustomerImage(
        imageURL: imageURL,
      );
}
