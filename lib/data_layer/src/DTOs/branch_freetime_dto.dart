import 'package:meta/meta.dart' show immutable;

import '../helpers.dart';
import '../helpers/enum_dto.dart' show EnumDTO;

/// Class that hold all available timeframes in a specific date,
/// when a branch opens, when it closes, the status of that day
@immutable
class BranchFreeTimeDTO {
  /// Selected Date
  final DateTime? date;

  /// Status of the selected day
  final BranchDayStatusDTO? dayStatus;

  /// Time slot used in the value matrix 
  final int? slotTime;

  /// The first hour available
  final DateTime? startTime;

  /// The last hour available
  final DateTime? stopTime;

  /// A list with the times available during that day
  final List<bool>? value;

  /// Creates a new [BranchFreeTimeDTO]
  BranchFreeTimeDTO({
    this.date,
    this.dayStatus,
    this.slotTime,
    this.startTime,
    this.stopTime,
    this.value,
  });

  /// Creates a new [BranchFreeTimeDTO] from a json map
  factory BranchFreeTimeDTO.fromJson(Map json) {
    return BranchFreeTimeDTO(
      date: JsonParser.parseStringDate(json['date']),
      slotTime: JsonParser.parseInt(json['slotTime']),
      startTime: json['start_time'] == null
          ? null
          : JsonParser.parseStringDate('${json['date']}T${json['start_time']}'),
      stopTime: json['stop_time'] == null
          ? null
          : JsonParser.parseStringDate('${json['date']}T${json['stop_time']}'),
      value: json['value'] == null ? null : List<bool>.from(json['value']),
      dayStatus: BranchDayStatusDTO(json['day_status']),
    );
  }

  /// Returns a list of [BranchFreeTimeDTO] from a list of json
  static List<BranchFreeTimeDTO> fromJsonList(List json) {
    return json.map((time) => BranchFreeTimeDTO.fromJson(time)).toList();
  }
}

/// Enum class that indicates the status of a date
class BranchDayStatusDTO extends EnumDTO {
  /// If is a all free day
  static const free = BranchDayStatusDTO._internal('F');

  /// Mixed day
  static const mixed = BranchDayStatusDTO._internal('M');

  /// Branch is closed
  static const closed = BranchDayStatusDTO._internal('O');

  /// Branch is busy
  static const busy = BranchDayStatusDTO._internal('B');

  /// Status unknown
  static const unknown = BranchDayStatusDTO._internal('');

  /// All possible status
  static const List<BranchDayStatusDTO> values = [
    free,
    mixed,
    closed,
    busy,
  ];

  /// Constructor
  const BranchDayStatusDTO._internal(String value) : super.internal(value);

  /// Find [BranchDayStatusDTO] based in the letter passed
  factory BranchDayStatusDTO(String? raw) => values.singleWhere(
        (val) => val.value == raw,
        orElse: () => BranchDayStatusDTO.unknown,
      );
}
