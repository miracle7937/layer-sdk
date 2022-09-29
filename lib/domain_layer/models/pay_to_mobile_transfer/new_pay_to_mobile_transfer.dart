import 'package:equatable/equatable.dart';

import '../../models.dart';

/// Model representing a new pay to mobile transfer.
class NewPayToMobileTransfer extends Equatable {
  /// The source for this pay to mobile transfer.
  final NewTransferSource? source;

  /// The destination phone number.
  final String? destinationPhoneNumber;

  /// The currency.
  final Currency? currency;

  /// The amount of the transfer.
  final double? amount;

  /// The transaction code created by the sender.
  final String? transactionCode;

  /// The [PayToMobileTransferRequestType].
  final PayToMobileTransferRequestType? requestType;

  /// Whether if this should be saved into shortcuts.
  final bool saveToShortcut;

  /// The shortcut name;
  final String? shortcutName;

  /// Creates a new [NewPayToMobileTransfer].
  NewPayToMobileTransfer({
    this.source,
    this.destinationPhoneNumber,
    this.currency,
    this.amount,
    this.transactionCode,
    this.requestType,
    this.saveToShortcut = false,
    this.shortcutName,
  });

  /// Creates a copy with the passed values.
  NewPayToMobileTransfer copyWith({
    NewTransferSource? source,
    String? destinationPhoneNumber,
    Currency? currency,
    double? amount,
    String? transactionCode,
    PayToMobileTransferRequestType? requestType,
    bool? saveToShortcut,
    String? shortcutName,
  }) =>
      NewPayToMobileTransfer(
        source: source ?? this.source,
        destinationPhoneNumber:
            destinationPhoneNumber ?? this.destinationPhoneNumber,
        currency: currency ?? this.currency,
        amount: amount ?? this.amount,
        transactionCode: transactionCode ?? this.transactionCode,
        requestType: requestType ?? this.requestType,
        saveToShortcut: saveToShortcut ?? this.saveToShortcut,
        shortcutName: shortcutName ?? this.shortcutName,
      );

  @override
  List<Object?> get props => [
        source,
        destinationPhoneNumber,
        currency,
        amount,
        transactionCode,
        requestType,
        saveToShortcut,
        shortcutName,
      ];
}
