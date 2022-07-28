import '../../abstract_repositories.dart';

/// Use case for canceling Mandates
class CancelMandateUseCase {
  final MandateRepositoryInterface _repo;

  /// Creates a new [CancelMandateUseCase] instance
  CancelMandateUseCase({
    required MandateRepositoryInterface repository,
  }) : _repo = repository;

  /// Callable that cancels a Mandate
  Future<Map<String, dynamic>> call({
    required int mandateId,
    String? otpValue,
    String? otpType,
  }) {
    return _repo.cancelMandate(
      mandateId: mandateId,
      otpValue: otpValue,
      otpType: otpType,
    );
  }
}
