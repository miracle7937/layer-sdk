import 'package:equatable/equatable.dart';

import '../../../data_layer/dtos.dart';
import '../../models.dart';

/// An interface that should be extended by all the new transfer flows.
abstract class NewTransfer extends Equatable {
  /// The transfer type.
  final TransferType? type;

  /// The source.
  final NewTransferSource? source;

  /// The amount of the transfer.
  final double? amount;

  /// The transfer currency.
  final Currency? currency;

  /// The destination.
  final NewTransferDestination? destination;

  /// Creates a new [NewTransfer].
  NewTransfer({
    this.type,
    this.source,
    this.amount,
    this.currency,
    this.destination,
  });

  /// Creates a new [NewTransfer] with the passed values.
  NewTransfer copyWith();

  /// Converts a new transfer into a DTO to be used by the transfer services.
  NewTransferPayloadDTO toNewTransferPayloadDTO();

  /// Whether if the transfer is ready to be submitted or not.
  bool canBeSubmitted();
}
