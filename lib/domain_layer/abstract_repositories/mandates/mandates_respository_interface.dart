import '../../models.dart';

/// The abstract repository for the Mandates
abstract class MandateRepositoryInterface {
  /// Fetches Mandates data and parses to [Mandate] models
  Future<List<Mandate>> listMandates({
    int? mandateId,
    int? limit,
    int? offset,
  });

  /// DELETE a Mandate
  Future<SecondFactorType?> cancelMandate({
    required int mandateId,
    String? otpValue,
    SecondFactorType? otpType,
  });
}
