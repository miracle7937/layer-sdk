import '../../../domain_layer/models.dart';
import '../../dtos.dart';

/// Extension that provides mappings for [CustomerLimitDTO].
extension CustomerLimitDTOMapping on CustomerLimitDTO {
  /// Maps into [CustomerLimit].
  CustomerLimit toCustomerLimit() => CustomerLimit(
        bankDaily: Limit(
          limit: limBnkDaily?.toDouble() ?? 0.0,
          usage: usageBnkDaily?.toDouble() ?? 0.0,
        ),
        bankMonthly: Limit(
          limit: limBnkMonthly?.toDouble() ?? 0.0,
          usage: usageBnkMonthly?.toDouble() ?? 0.0,
        ),
        billDaily: Limit(
          limit: limBillDaily?.toDouble() ?? 0.0,
          usage: usageBillDaily?.toDouble() ?? 0.0,
        ),
        billMonthly: Limit(
          limit: limBillMonthly?.toDouble() ?? 0.0,
          usage: usageBillMonthly?.toDouble() ?? 0.0,
        ),
        c2cDaily: Limit(
          limit: limC2CDaily?.toDouble() ?? 0.0,
          usage: usageC2CDaily?.toDouble() ?? 0.0,
        ),
        c2cMonthly: Limit(
          limit: limC2CMonthly?.toDouble() ?? 0.0,
          usage: usageC2CMonthly?.toDouble() ?? 0.0,
        ),
        cardDaily: Limit(
          limit: limCrdDaily?.toDouble() ?? 0.0,
          usage: usageCrdDaily?.toDouble() ?? 0.0,
        ),
        cardMonthly: Limit(
          limit: limCrdMonthly?.toDouble() ?? 0.0,
          usage: usageCrdMonthly?.toDouble() ?? 0.0,
        ),
        domesticDaily: Limit(
          limit: limDomDaily?.toDouble() ?? 0.0,
          usage: usageDomDaily?.toDouble() ?? 0.0,
        ),
        domesticMonthly: Limit(
          limit: limDomMonthly?.toDouble() ?? 0.0,
          usage: usageDomMonthly?.toDouble() ?? 0.0,
        ),
        internationalDaily: Limit(
          limit: limIntDaily?.toDouble() ?? 0.0,
          usage: usageIntDaily?.toDouble() ?? 0.0,
        ),
        internationalMonthly: Limit(
          limit: limIntMonthly?.toDouble() ?? 0.0,
          usage: usageIntMonthly?.toDouble() ?? 0.0,
        ),
        ownDaily: Limit(
          limit: limOwnDaily?.toDouble() ?? 0.0,
          usage: usageOwnDaily?.toDouble() ?? 0.0,
        ),
        ownMonthly: Limit(
          limit: limOwnMonthly?.toDouble() ?? 0.0,
          usage: usageLimOwnMonthly?.toDouble() ?? 0.0,
        ),
        topUpDaily: Limit(
          limit: limTopupDaily?.toDouble() ?? 0.0,
          usage: usageTopupDaily?.toDouble() ?? 0.0,
        ),
        prefCurrency: prefCurrency ?? '',
      );
}
