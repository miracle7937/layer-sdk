import '../../helpers.dart';

/// Enum that holds what is the sender type of a report message
class InboxReportSenderTypeDTO extends EnumDTO {
  const InboxReportSenderTypeDTO._internal(String value)
      : super.internal(value);

  /// Customer Type
  static const customer = InboxReportSenderTypeDTO._internal('customer');

  /// Public type
  static const public = InboxReportSenderTypeDTO._internal('public');

  /// Status Closed
  static const unknown = InboxReportSenderTypeDTO._internal('');

  /// A list containing all possible types
  static const List<InboxReportSenderTypeDTO> values = [
    customer,
    public,
    unknown,
  ];

  /// Return a [InboxReportSenderTypeDTO] based on a string
  static InboxReportSenderTypeDTO fromRaw(String? value) {
    return values.firstWhere((it) => it.value == value);
  }
}
