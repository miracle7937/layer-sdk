import 'package:equatable/equatable.dart';

import '../../../data_layer/mappings/limits/limits_mapping.dart';

/// Limit types
enum LimitType {
  /// Maximum amount per Transaction
  maxAmountperTransaction,

  /// Maximum daily amount
  maxAmountDaily,

  /// Maximum monthly amount
  maxAmountMonthly,

  /// Maximum number of transactions per day
  maxNumberofTransactionsDaily,

  /// Maximum number of transactions per month
  maxNumberofTransactionsMonthly,

  /// Number of international beneficiaries a customer can have
  maxAmountInternationalBeneficiaries,
}

/// Types of limits by transaction type
enum LimitGroupType {
  /// Own
  own,

  /// Bank
  bank,

  /// Domestic
  domestic,

  /// International
  international,

  /// Bill Payment
  bill,

  /// Credit Card
  creditCard,

  /// TopUp Payment
  topup,

  /// Card to Card
  cardToCard,

  /// Bulk
  bulk,

  /// WPS
  payroll,

  /// Wallet Payment
  walletPayment,

  /// Remittance
  remittance,

  /// International Beneficiary
  internationalBeneficiary,
}

/// Data class for limits information
class Limits extends Equatable {
  /// Minimum Transfer Amount
  final int? minTransferAmount;

  /// Minimum Bill Payment Amount per transaction
  final int? minBillPaymentperTxn;

  /// Minimum Topup Amount per transaction
  final int? minTopupAmountperTxn;

  /// Customer cumulative limit
  final int? limCumulativeDaily;

  /// None CASA Wallet Balance Limit
  final int? limWalletBalance;

  /// CASA Wallet Balance Limit
  final int? limLinkedWalletBalance;

  /// Minimum Remittance Transfer Amount
  final int? minRemittanceTransferAmount;

  /// Limits list grouped by type of transaction
  final List<LimitsGroup> limitsGroups;

  /// To save limits we must use PUT or POST call,
  /// depending on following situation:
  /// when we get limits and response is empty array - POST, otherwise - PUT.
  /// Thus this variable stores data if received array of limits is not empty.
  final bool originalLimitsNotEmpty;

  /// Creates new [Limits]
  Limits({
    required this.originalLimitsNotEmpty,
    this.minTransferAmount,
    this.minBillPaymentperTxn,
    this.minTopupAmountperTxn,
    this.limCumulativeDaily,
    this.limWalletBalance,
    this.limLinkedWalletBalance,
    this.minRemittanceTransferAmount,
    this.limitsGroups = const [],
  });

  @override
  List<Object?> get props => [
        minTransferAmount,
        minBillPaymentperTxn,
        minTopupAmountperTxn,
        limCumulativeDaily,
        limWalletBalance,
        limLinkedWalletBalance,
        minRemittanceTransferAmount,
        limitsGroups,
        originalLimitsNotEmpty,
      ];
}

/// Keeps the data of limit
class LimitHolder extends Equatable {
  /// Limit type
  final LimitType limitType;

  /// Value
  final int? value;

  /// Creates new [LimitHolder]
  LimitHolder({
    required this.limitType,
    this.value,
  });

  @override
  List<Object?> get props => [
        limitType,
        value,
      ];
}
