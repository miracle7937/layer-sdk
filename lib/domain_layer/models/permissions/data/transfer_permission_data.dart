import 'package:equatable/equatable.dart';

import '../../../../data_layer/extensions.dart';
import '../../../models.dart';

/// Permissions related to transfers.
class TransferPermissionData extends Equatable {
  /// Allowed currencies specific permissions.
  final BasePermissionData allowedCurrencies;

  /// Bank specific permissions.
  final BasePermissionData bank;

  /// Bulk specific permissions.
  final BasePermissionData bulk;

  /// Card specific permissions.
  final BasePermissionData card;

  /// Domestic specific permissions.
  final BasePermissionData domestic;

  /// Instant specific permissions.
  final BasePermissionData instant;

  /// International specific permissions.
  final BasePermissionData international;

  /// Limits specific permissions.
  final BasePermissionData limits;

  /// Merchant specific permissions.
  final BasePermissionData merchant;

  /// Mobile specific permissions.
  final BasePermissionData mobile;

  /// Own specific permissions.
  final BasePermissionData own;

  /// Reason specific permissions.
  final BasePermissionData reason;

  /// Creates a [TransferPermissionData] object.
  const TransferPermissionData({
    this.allowedCurrencies = const BasePermissionData(),
    this.bank = const BasePermissionData(),
    this.bulk = const BasePermissionData(),
    this.card = const BasePermissionData(),
    this.domestic = const BasePermissionData(),
    this.instant = const BasePermissionData(),
    this.international = const BasePermissionData(),
    this.limits = const BasePermissionData(),
    this.merchant = const BasePermissionData(),
    this.mobile = const BasePermissionData(),
    this.own = const BasePermissionData(),
    this.reason = const BasePermissionData(),
  });

  ///TODO: Temporary solution for filters
  bool get canDoAnyTransfer => true;

  @override
  List<Object> get props => [
        allowedCurrencies,
        bank,
        bulk,
        card,
        domestic,
        instant,
        international,
        limits,
        merchant,
        mobile,
        own,
        reason,
      ];

  /// Returns a copy of this permission with select different values.
  TransferPermissionData copyWith({
    BasePermissionData? allowedCurrencies,
    BasePermissionData? bank,
    BasePermissionData? bulk,
    BasePermissionData? card,
    BasePermissionData? domestic,
    BasePermissionData? instant,
    BasePermissionData? international,
    BasePermissionData? limits,
    BasePermissionData? merchant,
    BasePermissionData? mobile,
    BasePermissionData? own,
    BasePermissionData? reason,
  }) =>
      TransferPermissionData(
        allowedCurrencies: allowedCurrencies ?? this.allowedCurrencies,
        bank: bank ?? this.bank,
        bulk: bulk ?? this.bulk,
        card: card ?? this.card,
        domestic: domestic ?? this.domestic,
        instant: instant ?? this.instant,
        international: international ?? this.international,
        limits: limits ?? this.limits,
        merchant: merchant ?? this.merchant,
        mobile: mobile ?? this.mobile,
        own: own ?? this.own,
        reason: reason ?? this.reason,
      );

  @override
  String toString() => '<'
      '${[
        'allowedCurrencies: $allowedCurrencies',
        'bank: $bank',
        'bulk: $bulk',
        'card: $card',
        'domestic: $domestic',
        'instant: $instant',
        'international: $international',
        'limits: $limits',
        'merchant: $merchant',
        'mobile: $mobile',
        'own: $own',
        'reason: $reason',
      ].logJoin()}'
      '>';
}
