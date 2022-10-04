import '../../models.dart';

/// Abstract repository for the pay to mobile flow.
abstract class PayToMobileRepositoryInterface {
  /// Submits a new pay to mobile and returns a pay to mobile element.
  Future<PayToMobile> submit({
    required NewPayToMobile newPayToMobile,
  });
}
