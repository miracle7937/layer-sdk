import 'package:collection/collection.dart';

import '../../helpers.dart';

///Data transfer object representing the recurrence of a transfer
class TransferRecurrenceDTO extends EnumDTO {
  ///Recurrence only once
  static const once = TransferRecurrenceDTO._internal('XS1');

  ///Daily recurrence
  static const daily = TransferRecurrenceDTO._internal('XD1');

  ///Weekly recurrence
  static const weekly = TransferRecurrenceDTO._internal('XD7');

  ///Biweekly recurrence
  static const biweekly = TransferRecurrenceDTO._internal('XD14');

  ///Monthly recurrence
  static const monthly = TransferRecurrenceDTO._internal('XM1');

  ///Bimonthly recurrence
  static const bimonthly = TransferRecurrenceDTO._internal('XM2');

  ///Quarterly recurrence
  static const quarterly = TransferRecurrenceDTO._internal('XM3');

  ///Yearly recurrence
  static const yearly = TransferRecurrenceDTO._internal('XY1');

  ///End of each month recurrence
  static const endOfEachMonth = TransferRecurrenceDTO._internal('XM1E');

  ///All the available recurrences of a transfer
  static const List<TransferRecurrenceDTO> values = [
    once,
    daily,
    weekly,
    biweekly,
    monthly,
    bimonthly,
    quarterly,
    yearly,
    endOfEachMonth,
  ];

  const TransferRecurrenceDTO._internal(String value) : super.internal(value);

  /// Creates a [TransferRecurrenceDTO] from a [String]
  static TransferRecurrenceDTO? fromRaw(String? raw) => values.firstWhereOrNull(
        (val) => val.value == raw,
      );
}
