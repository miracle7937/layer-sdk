import '../../abstract_repositories.dart';
import '../../models.dart';

/// Use case responsible for load product by id
class LoadProductByProductIdUseCase {
  final ProductRepositoryInterface _repository;

  /// Creates a new [LoadProductByProductIdUseCase] instance
  LoadProductByProductIdUseCase({
    required ProductRepositoryInterface repository,
  }) : _repository = repository;

  /// Callable method to fetch [Product] by `productId`
  Future<Product> call(String productId) {
    return _repository.fetchProduct(productId);
  }
}
