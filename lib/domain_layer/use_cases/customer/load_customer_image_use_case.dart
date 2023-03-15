import '../../abstract_repositories.dart';

/// A use case to fetch the customers profile image
class LoadCustomerImageUseCase {
  final CustomerRepositoryInterface _repository;

  /// Creates a new [LoadCustomerImageUseCase] instance
  LoadCustomerImageUseCase({
    required CustomerRepositoryInterface repository,
  }) : _repository = repository;

  /// Loads the customer's image
  Future<dynamic> call({
    required String imageURL,
  }) =>
      _repository.loadCustomerImage(
        imageURL: imageURL,
      );
}
