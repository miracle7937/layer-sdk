import 'package:equatable/equatable.dart';

import '../../models.dart';

/// Model representing a new pay to mobile.
class NewPayToMobile extends Equatable {
  /// The source account identifier for this pay to mobile.
  final String? accountId;

  /// The destination dial code.
  final String? dialCode;

  /// The destination phone number.
  final String? phoneNumber;

  /// The currency code.
  final String? currencyCode;

  /// The amount of the transfer.
  final double? amount;

  /// The transaction code created by the sender.
  final String? transactionCode;

  /// The [PayToMobileRequestType].
  final PayToMobileRequestType? requestType;

  /// Whether if this should be saved into shortcuts.
  final bool saveToShortcut;

  /// The shortcut name;
  final String? shortcutName;

  /// Creates a new [NewPayToMobile].
  NewPayToMobile({
    this.accountId,
    this.dialCode,
    this.phoneNumber,
    this.currencyCode,
    this.amount,
    this.transactionCode,
    this.requestType,
    this.saveToShortcut = false,
    this.shortcutName,
  });

  /// Creates a copy with the passed values.
  NewPayToMobile copyWith({
    String? accountId,
    String? dialCode,
    String? phoneNumber,
    String? currencyCode,
    double? amount,
    String? transactionCode,
    PayToMobileRequestType? requestType,
    bool? saveToShortcut,
    String? shortcutName,
  }) =>
      NewPayToMobile(
        accountId: accountId ?? this.accountId,
        dialCode: dialCode ?? this.dialCode,
        phoneNumber: phoneNumber ?? this.phoneNumber,
        currencyCode: currencyCode ?? this.currencyCode,
        amount: amount ?? this.amount,
        transactionCode: transactionCode ?? this.transactionCode,
        requestType: requestType ?? this.requestType,
        saveToShortcut: saveToShortcut ?? this.saveToShortcut,
        shortcutName: shortcutName ?? this.shortcutName,
      );

  @override
  List<Object?> get props => [
        accountId,
        dialCode,
        phoneNumber,
        currencyCode,
        amount,
        transactionCode,
        requestType,
        saveToShortcut,
        shortcutName,
      ];
}
