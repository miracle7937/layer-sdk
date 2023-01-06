import 'package:equatable/equatable.dart';

import '../../../domain_layer/models/limits/limits.dart';
import '../../dtos.dart';
import '../../extensions/limits/limits_extensions.dart';

/// Extension that provides mappings for [Limits]
extension LimitsMapping on Limits {
  /// Maps into a [LimitsDTO]
  LimitsDTO toLimitsDTO() => LimitsDTO(
        min: minTransferAmount,
        minBill: minBillPaymentperTxn,
        minTopup: minTopupAmountperTxn,
        limWalletBalance: limWalletBalance,
        limLinkedWalletBalance: limLinkedWalletBalance,
        limCumulativeDaily: limCumulativeDaily,
        minMcsxb: minRemittanceTransferAmount,
        json: {for (var groupLimits in limitsGroups) ...groupLimits.toJson()},
      );
}

/// Extension that provides mappings for [Limits]
extension LimitsDTOMapping on LimitsDTO {
  /// Maps into a [Limits]
  Limits toLimits() {
    final limitsGroups = LimitGroupType.values
        .map(
          (groupType) => LimitsGroup.fromJson(
            limitGroupType: groupType,
            json: json,
          ),
        )
        .toList();
    return Limits(
      minTransferAmount: min,
      minBillPaymentperTxn: minBill,
      minTopupAmountperTxn: minTopup,
      limWalletBalance: limWalletBalance,
      limLinkedWalletBalance: limLinkedWalletBalance,
      limCumulativeDaily: limCumulativeDaily,
      minRemittanceTransferAmount: minMcsxb,
      limitsGroups: limitsGroups,
      originalLimitsNotEmpty: json.isNotEmpty,
    );
  }
}

/// Represents details of limits for different types of transactions
class LimitsGroup extends Equatable {
  /// Type of transaction
  final LimitGroupType limitGroupType;

  /// List of limits
  final List<LimitHolder> limits;

  /// Creates [LimitsGroup]
  LimitsGroup({
    required this.limitGroupType,
    required this.limits,
  });

  /// Creates a [LimitsGroup] from a JSON
  factory LimitsGroup.fromJson({
    required LimitGroupType limitGroupType,
    required Map<String, dynamic> json,
  }) {
    final limits = LimitType.values.map(
      (limitType) {
        return LimitHolder(
          limitType: limitType,
          value: json[limitType.toJsonFieldKey(limitGroupType)],
        );
      },
    ).toList();
    return LimitsGroup(
      limitGroupType: limitGroupType,
      limits: limits,
    );
  }

  /// Encodes to a JSON.
  Map<String, dynamic> toJson() {
    final json = <String, dynamic>{
      for (var limit in limits)
        limit.limitType.toJsonFieldKey(limitGroupType): limit.value
    };
    return json;
  }

  @override
  List<Object?> get props => [
        limitGroupType,
        limits,
      ];
}
