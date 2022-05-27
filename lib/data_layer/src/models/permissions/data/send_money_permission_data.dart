import 'package:equatable/equatable.dart';

import '../../../../extensions.dart';

/// Permissions related to sending money.
class SendMoneyPermissionData extends Equatable {
  /// User can send money to bank.
  final bool bank;

  /// User can send money in the country.
  final bool domestic;

  /// User can send money to him/herself.
  final bool own;

  /// Creates a [SendMoneyPermissionData] object.
  const SendMoneyPermissionData({
    this.bank = false,
    this.domestic = false,
    this.own = false,
  });

  @override
  List<Object> get props => [
        bank,
        domestic,
        own,
      ];

  /// Returns a copy of this permission with select different values.
  SendMoneyPermissionData copyWith({
    bool? bank,
    bool? domestic,
    bool? own,
  }) =>
      SendMoneyPermissionData(
        bank: bank ?? this.bank,
        domestic: domestic ?? this.domestic,
        own: own ?? this.own,
      );

  @override
  String toString() => '<'
      '${[
        '${bank.toLog('bank')}',
        '${domestic.toLog('domestic')}',
        '${own.toLog('own')}',
      ].logJoin()}'
      '>';
}
