import '../../../domain_layer/abstract_repositories.dart';
import '../../../domain_layer/models.dart';
import '../../mappings.dart';
import '../../providers.dart';

/// Repository that handles the pay to mobile flow.
class PayToMobileRepository implements PayToMobileRepositoryInterface {
  final PayToMobileProvider _provider;

  /// Creates [PayToMobileRepository].
  PayToMobileRepository({
    required PayToMobileProvider provider,
  }) : _provider = provider;

  /// Submits a new pay to mobile flow and returns a pay to mobile element.
  @override
  Future<PayToMobile> submit({
    required NewPayToMobile newPayToMobile,
  }) async {
    final payToMobileDTO = await _provider.submit(
      newPayToMobileDTO: newPayToMobile.toDTO(),
    );

    return payToMobileDTO.toPayToMobile();
  }
}
