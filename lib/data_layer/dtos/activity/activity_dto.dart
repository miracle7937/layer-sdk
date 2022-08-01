import '../../dtos.dart';
import '../../helpers.dart';
import '../../mappings.dart';

///Data transfer object representing Activity
class ActivityDTO {
  /// The id of the [Activity]
  String? id;

  /// The status of the [Activity]
  String? status;

  /// The message of the [Activity]
  String? message;

  /// The [ActivityTypeDTO] of the [Activity]
  ActivityTypeDTO? type;

  /// The [ActivityActionTypeDTO] of the [Activity]
  List<ActivityActionTypeDTO>? actions;

  /// The updated time of the [Activity]
  DateTime? tsUpdated;

  /// The alertID of the [Activity]
  int? alertID;

  ///
  bool? read;

  /// The itemId of the [Activity]
  dynamic itemId;

  /// The item of the [Activity]
  dynamic item;

  ///Creates a new [ActivityDTO]
  ActivityDTO({
    this.id,
    this.status,
    this.message,
    this.type,
    this.actions,
    this.tsUpdated,
    this.alertID,
    this.read,
    this.itemId,
    this.item,
  });

  /// Creates a [ActivityDTO] from a JSON
  factory ActivityDTO.fromJson(Map<String, dynamic> json) {
    final type = json['type'] == null
        ? null
        : ActivityTypeDTO.fromRaw(
            json['type'],
          );

    return ActivityDTO(
      id: json['request_id'],
      type: type,
      itemId: json['type_item_id'],
      message: json['message'] ?? '',
      tsUpdated: JsonParser.parseDate(json['ts_updated']),
      alertID: json['alert_id'],
      item: json['item'] == null ? null : _parseItem(type!, json['item']),
      status: json['status'],
      read: json['read'] ?? false,
      actions: json['actions'] == null
          ? []
          : (json['actions'] as List).map((action) {
              return ActivityActionTypeDTO.fromRaw(action.toString())!;
            }).toList(),
    );
  }

  /// Returns a list of [TransferDTO] from a JSON
  static List<ActivityDTO> fromJsonList(List<Map<String, dynamic>> json) =>
      json.map(ActivityDTO.fromJson).toList();
}

dynamic _parseItem(ActivityTypeDTO type, Map<String, dynamic> json) {
  switch (type) {
    case ActivityTypeDTO.transfer:
    case ActivityTypeDTO.scheduledTransfer:
    case ActivityTypeDTO.recurringTransfer:
      return TransferDTO.fromJson(json);

    case ActivityTypeDTO.payment:
    case ActivityTypeDTO.scheduledPayment:
    case ActivityTypeDTO.recurringPayment:
    case ActivityTypeDTO.topupPayment:
    case ActivityTypeDTO.scheduledTopup:
    case ActivityTypeDTO.recurringTopup:
      return PaymentDTO.fromJson(json);

    case ActivityTypeDTO.dpa:
      return DPATaskDTO.fromJson(json);

    default:
      return json;
  }
}
