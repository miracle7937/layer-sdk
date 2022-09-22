import '../../abstract_repositories.dart';
import '../../models.dart';

/// Use case that requests a new Stripe secret key used for account top ups.
class GetAccountTopUpSecretUseCase {
  final AccountRepositoryInterface _repository;

  /// Creates a new [GetAccountTopUpSecretUseCase] instance.
  GetAccountTopUpSecretUseCase({
    required AccountRepositoryInterface repository,
  }) : _repository = repository;

  /// Requests a new Stripe secret key for account top ups.
  Future<AccountTopUpRequest> call({
    required String accountId,
    required String currency,
    required double amount,
  }) =>
      _repository.getAccountTopUpSecret(
        accountId: accountId,
        currency: currency,
        amount: amount,
      );
}
