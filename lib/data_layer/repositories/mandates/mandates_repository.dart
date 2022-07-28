import '../../../domain_layer/abstract_repositories.dart';
import '../../../domain_layer/models/mandates/mandate.dart';
import '../../mappings.dart';
import '../../providers.dart';

/// Handles Mandates data
class MandatesRepository implements MandateRepositoryInterface {
  final MadatesProvider _provider;

  ///  Creates a new repository with the supplied [MadatesProvider]
  MandatesRepository({required MadatesProvider provider})
      : _provider = provider;

  @override
  Future<List<Mandate>> listMandates({
    int? mandateId,
    int? limit,
    int? offset,
  }) async {
    final mandates = await _provider.listAllMandates(
      mandateId: mandateId,
      limit: limit,
      offset: offset,
    );

    return mandates.map((m) => m.toMandate()).toList(growable: false);
  }

  @override
  Future<Map<String, dynamic>> cancelMandate({
    required int mandateId,
    String? otpValue,
    String? otpType,
  }) async {
    final result = await _provider.cancelMandate(
      mandateId: mandateId,
      otpValue: otpValue,
      otpType: otpType,
    );
    return result;
  }
}
