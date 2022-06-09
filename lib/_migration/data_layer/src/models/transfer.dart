import 'package:equatable/equatable.dart';

import '../../../../domain_layer/models.dart';
import '../../models.dart';

///The transfer data used by the application
class Transfer extends Equatable {
  /// The transfer id.
  final int? id;

  /// The currency used in this transfer.
  final String? currency;

  /// The amount of the transfer.
  final double? amount;

  /// Whether the `amount` should be shown
  final bool amountVisible;

  /// The source [Account].
  final Account? fromAccount;

  /// The destination [Account].
  final Account? toAccount;

  /// The source [BankingCard].
  final BankingCard? fromCard;

  /// The destination [BankingCard].
  final BankingCard? toCard;

  /// The source mobile number.
  final String? fromMobile;

  /// The destination mobile number.
  final String? toMobile;

  /// The destination [Beneficiary].
  final Beneficiary? toBeneficiary;

  /// The transfer recurrence.
  final TransferRecurrence recurrence;

  /// The transfer creation date.
  final DateTime? created;

  /// The transfer status.
  final TransferStatus? status;

  /// The transfer type.
  final TransferType? type;

  ///The future date when the transfer should happen
  final DateTime? scheduledDate;

  ///Creates a new immutable [Transfer]
  Transfer({
    this.id,
    this.currency,
    this.amount,
    this.amountVisible = true,
    this.fromAccount,
    this.toAccount,
    this.fromCard,
    this.toCard,
    this.fromMobile,
    this.toMobile,
    this.toBeneficiary,
    this.recurrence = TransferRecurrence.none,
    this.created,
    this.status,
    this.type,
    this.scheduledDate,
  });

  /// Returns the transfer id as `String`.
  String? get transferId => id?.toString();

  @override
  List<Object?> get props => [
        id,
        currency,
        amount,
        amountVisible,
        fromAccount,
        toAccount,
        fromCard,
        toCard,
        fromMobile,
        toMobile,
        toBeneficiary,
        recurrence,
        created,
        status,
        type,
        scheduledDate,
      ];
}
