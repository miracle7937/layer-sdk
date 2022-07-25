import 'package:collection/collection.dart';

import '../../helpers.dart';

///Data transfer object representing the processing type of a transfer
class TransferProcessingTypeDTO extends EnumDTO {
  ///Recurrence only once
  static const instant = TransferProcessingTypeDTO._internal('I');

  ///Daily recurrence
  static const nextDay = TransferProcessingTypeDTO._internal('A');

  ///All the available processing types of a transfer
  static const List<TransferProcessingTypeDTO> values = [
    instant,
    nextDay,
  ];

  const TransferProcessingTypeDTO._internal(String value)
      : super.internal(value);

  /// Creates a [TransferProcessingTypeDTO] from a [String]
  static TransferProcessingTypeDTO? fromRaw(String? raw) =>
      values.firstWhereOrNull(
        (val) => val.value == raw,
      );
}
