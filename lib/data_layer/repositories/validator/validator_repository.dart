import '../../../domain_layer/abstract_repositories.dart';
import '../../providers.dart';

/// A repository that can be used to validate
class ValidatorRepository implements ValidatorRepositoryInterface {
  final ValidatorProvider _provider;

  /// Creates a new [ValidatorRepository]
  ValidatorRepository({
    required ValidatorProvider provider,
  }) : _provider = provider;

  @override
  Future<void> validateTransactionPin({
    required String txnPin,
    required String userId,
  }) {
    final result = _provider.validateTransactionPin(
      txnPin: txnPin,
      userId: userId,
    );

    return result;
  }
}
