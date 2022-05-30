import 'package:collection/collection.dart';

import '../../helpers.dart';

///Data transfer object representing the transfer status of a transfer
class TransferStatusDTO extends EnumDTO {
  /// Transfer has completed.
  static const completed = TransferStatusDTO._internal('C');

  /// Transfer is pending.
  static const pending = TransferStatusDTO._internal('P');

  /// Transfer is scheduled.
  static const scheduled = TransferStatusDTO._internal('S');

  /// Transfer failed.
  static const failed = TransferStatusDTO._internal('F');

  /// Transfer has been cancelled.
  static const cancelled = TransferStatusDTO._internal('X');

  /// Transfer was rejected.
  static const rejected = TransferStatusDTO._internal('R');

  /// Transfer has expired.
  static const pendingExpired = TransferStatusDTO._internal('E');

  /// Transfer is waiting for the OTP verification.
  static const otp = TransferStatusDTO._internal('O');

  /// The OTP for the transfer has expired.
  static const otpExpired = TransferStatusDTO._internal('T');

  /// Transfer has been deleted.
  static const deleted = TransferStatusDTO._internal('D');

  /// All the possible statuses of the transfer.
  static const List<TransferStatusDTO> values = [
    completed,
    pending,
    scheduled,
    failed,
    cancelled,
    rejected,
    pendingExpired,
    otp,
    otpExpired,
    deleted,
  ];

  const TransferStatusDTO._internal(String value) : super.internal(value);

  /// Creates a [TransferStatusDTO] from a `String`.
  static TransferStatusDTO? fromRaw(String? raw) => values.firstWhereOrNull(
        (val) => val.value == raw,
      );
}
