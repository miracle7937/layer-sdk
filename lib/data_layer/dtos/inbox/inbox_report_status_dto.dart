import '../../helpers.dart';

/// Enum that holds what is the status of a report
class InboxReportStatusDTO extends EnumDTO {
  const InboxReportStatusDTO._internal(String value) : super.internal(value);

  /// Status Deleted
  static const deleted = InboxReportStatusDTO._internal('D');

  /// Status Closed
  static const closed = InboxReportStatusDTO._internal('C');

  /// Status Closed
  static const unknown = InboxReportStatusDTO._internal('');

  /// A list containing all possible status
  static const List<InboxReportStatusDTO> values = [
    deleted,
    closed,
    unknown,
  ];

  /// Return a [InboxReportStatusDTO] based on a string
  static InboxReportStatusDTO fromRaw(String? value) {
    return values.firstWhere((it) => it.value == value,
        orElse: () => InboxReportStatusDTO.unknown);
  }
}
