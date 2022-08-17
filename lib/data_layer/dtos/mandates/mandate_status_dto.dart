import '../../helpers.dart';

/// DTO that holds info about the status of a [MandateDTO]
class MandateStatusDTO extends EnumDTO {
  /// Mandate with Active status
  static const active = MandateStatusDTO._internal('A');

  /// Mandate with Pending status
  static const pending = MandateStatusDTO._internal('P');

  /// Mandate with Rejecting status
  static const rejecting = MandateStatusDTO._internal('J');

  /// Mandate with Cancelling status
  static const cancelling = MandateStatusDTO._internal('E');

  /// Mandate with Cancelled status
  static const cancelled = MandateStatusDTO._internal('C');

  /// Mandate with Rejected status
  static const rejected = MandateStatusDTO._internal('R');

  /// Madate with no status defined
  static const unknown = MandateStatusDTO._internal('');

  /// A list of all possible [MandateStatusDTO]
  static const List<MandateStatusDTO> values = [
    active,
    pending,
    rejecting,
    cancelling,
    cancelled,
    rejected,
    unknown,
  ];

  const MandateStatusDTO._internal(String value) : super.internal(value);

  /// Creates a [MandateStatusDTO] from a [String]
  factory MandateStatusDTO(String? raw) => values.singleWhere(
        (val) => val.value == raw,
        orElse: () => MandateStatusDTO.unknown,
      );
}
