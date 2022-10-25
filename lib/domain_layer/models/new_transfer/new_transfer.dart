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

  /// Whether if the transfer should be saved to a shortcut.
  ///
  /// Default is `false`
  final bool saveToShortcut;

  /// The shortcut name.
  final String? shortcutName;

  /// The note for the new transfer.
  final String? note;

  /// The id of the new transfer
  final int? transferId;

  /// Device uid;
  final String? deviceUID;

  /// Creates a new [NewTransfer].
  const NewTransfer({
    this.type,
    this.source,
    this.amount,
    this.currency,
    this.destination,
    this.saveToShortcut = false,
    this.shortcutName,
    this.note,
    this.transferId,
    this.deviceUID,
  });

  /// Creates a new [NewTransfer] with the passed values.
  NewTransfer copyWith();

  /// Converts a new transfer into a DTO to be used by the transfer services.
  NewTransferPayloadDTO toNewTransferPayloadDTO();

  /// Whether if the transfer is ready to be submitted or not.
  bool canBeSubmitted();
}
