import 'package:collection/collection.dart';

import '../../helpers.dart';

/// The status a process DTO can have.
class DPAStatusDTO extends EnumDTO {
  /// All
  static const all = DPAStatusDTO._('L');

  /// Active
  static const active = DPAStatusDTO._('A');

  /// Pending other user approval
  static const pendingOtherUserApproval = DPAStatusDTO._('P');

  /// Pending bank approval
  static const pendingBankApproval = DPAStatusDTO._('B');

  /// Completed
  static const completed = DPAStatusDTO._('C');

  /// Edit requested
  static const editRequested = DPAStatusDTO._('U');

  /// Cancelled
  static const cancelled = DPAStatusDTO._('X');

  /// Rejected
  static const rejected = DPAStatusDTO._('R');

  /// Failed
  static const failed = DPAStatusDTO._('F');

  //String get key => 'dpa_status_$value';

  /// Returns all the values available.
  static const List<DPAStatusDTO> values = [
    all,
    active,
    pendingOtherUserApproval,
    pendingBankApproval,
    completed,
    editRequested,
    cancelled,
    rejected,
    failed,
  ];

  const DPAStatusDTO._(String value) : super.internal(value);

  /// Creates a new [DPAStatusDTO] from a raw text.
  static DPAStatusDTO? fromRaw(String? raw) => values.firstWhereOrNull(
        (val) => val.value == raw,
      );
}
