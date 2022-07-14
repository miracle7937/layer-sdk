import '../../../data_layer/repositories.dart';

/// Use case that sets token
class UpdateUserTokenUseCase {
  final AuthenticationRepository _repository;

  /// Creates a new [UpdateUserTokenUseCase] instance.
  UpdateUserTokenUseCase({
    required AuthenticationRepository repository,
  }) : _repository = repository;

  /// Sets token with the `token` value.
  Future<void> call({String? token}) async {
    _repository.token = token;
  }
}
