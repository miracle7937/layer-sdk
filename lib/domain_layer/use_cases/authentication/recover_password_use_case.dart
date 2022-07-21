import '../../../data_layer/providers.dart';
import '../../abstract_repositories.dart';

/// Use case that handles the user recover password flow.
class RecoverPasswordUseCase {
  final AuthenticationRepositoryInterface _repository;

  /// Creates a new [RecoverPasswordUseCase] instance.
  RecoverPasswordUseCase({
    required AuthenticationRepositoryInterface repository,
  }) : _repository = repository;

  /// Recovers the user's password belonging to `username`.
  /// 
  /// Returns [ForgotPasswordRequestStatus] depends on recover password
  /// process.
  Future<ForgotPasswordRequestStatus> call({
    required String username,
  }) =>
      _repository.recoverPassword(
        username: username,
      );
}
