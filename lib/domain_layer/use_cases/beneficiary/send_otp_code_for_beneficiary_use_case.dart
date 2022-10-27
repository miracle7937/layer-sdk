import '../../abstract_repositories.dart';
import '../../models.dart';

/// A use case that sends the OTP code for a transfer ID.
class SendOTPCodeForBeneficiaryUseCase {
  final BeneficiaryRepositoryInterface _repository;

  /// Creates a new [SendOTPCodeForBeneficiaryUseCase] use case.
  const SendOTPCodeForBeneficiaryUseCase({
    required BeneficiaryRepositoryInterface repository,
  }) : _repository = repository;

  /// Returns a beneficiary resulting on sending the OTP code for the
  /// passed beneficiary id.
  Future<Beneficiary> call({
    required int beneficiaryId,
    required bool editMode,
  }) =>
      _repository.sendOTPCode(
        beneficiaryId: beneficiaryId,
        editMode: editMode,
      );
}
