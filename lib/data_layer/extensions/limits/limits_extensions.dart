import '../../../domain_layer/models/limits/limits.dart';

/// Converter extension for the [LimitType] type.
extension ParseToJsonKey on LimitType {
  /// Converts type to localization key
  String toKey() {
    switch (this) {
      case LimitType.maxAmountInternationalBeneficiaries:
        return 'total_count';
      case LimitType.maxAmountDaily:
        return 'lim_daily';
      case LimitType.maxNumberofTransactionsDaily:
        return 'num_daily';
      case LimitType.maxAmountMonthly:
        return 'lim_monthly';
      case LimitType.maxNumberofTransactionsMonthly:
        return 'num_monthly';
      case LimitType.maxAmountperTransaction:
        return 'lim_transaction';
      default:
        return name.replaceRange(3, 3, '_').toLowerCase();
    }
  }

  /// Converts type to json field key
  String toJsonFieldKey(
    LimitGroupType limitGroupType,
  ) {
    return toKey().replaceRange(3, 3, '_${limitGroupType.string()}');
  }
}

/// Converter extension for the `LimitGroupType` type.
extension ParseToString on LimitGroupType {
  /// Converts type to string
  String string() {
    switch (this) {
      case LimitGroupType.internationalBeneficiary:
        return 'int_beneficiary';
      case LimitGroupType.bank:
        return 'bnk';
      case LimitGroupType.remittance:
        return 'mcsxb';
      case LimitGroupType.cardToCard:
        return 'c2c';
      case LimitGroupType.creditCard:
        return 'crd';
      case LimitGroupType.domestic:
        return 'dom';
      case LimitGroupType.international:
        return 'int';
      case LimitGroupType.walletPayment:
        return 'p2p';
      default:
        return name;
    }
  }

  /// Converts type to localization key
  String localizationKey() {
    return '${string()}_limits_group';
  }
}
