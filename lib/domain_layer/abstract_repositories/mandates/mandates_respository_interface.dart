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
  /// TODO - change the return type if the response is not just a 200
  Future<void> cancelMandate({required int mandateId});
}
