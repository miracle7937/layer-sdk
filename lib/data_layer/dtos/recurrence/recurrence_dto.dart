import 'package:collection/collection.dart';

import '../../helpers.dart';

/// Possible recurrence options
class RecurrenceDTO extends EnumDTO {
  /// recurrence is once
  static const once = RecurrenceDTO._internal('XS1');

  /// recurrence is daily
  static const daily = RecurrenceDTO._internal('XD1');

  /// recurrence is weekly
  static const weekly = RecurrenceDTO._internal('XD7');

  /// recurrence is bi weekly
  static const biweekly = RecurrenceDTO._internal('XD14');

  /// recurrence is monthly
  static const monthly = RecurrenceDTO._internal('XM1');

  /// recurrence is bi monthly
  static const bimonthly = RecurrenceDTO._internal('XM2');

  /// recurrence is quarterly
  static const quarterly = RecurrenceDTO._internal('XM3');

  /// recurrence is yearly
  static const yearly = RecurrenceDTO._internal('XY1');

  /// recurrence is end of the month
  static const endOfEachMonth = RecurrenceDTO._internal('XM1E');

  /// All the available recurrence values in a list
  static const List<RecurrenceDTO> values = [
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

  const RecurrenceDTO._internal(String value) : super.internal(value);

  /// Creates a [RecurrenceDTO] from a [String]
  static RecurrenceDTO? fromRaw(String? raw) => values.firstWhereOrNull(
        (val) => val.value == raw,
      );
}
