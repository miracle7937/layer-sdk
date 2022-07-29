import '../../dtos.dart';
import '../../helpers.dart';

/// Data transfer object representing a service
/// retrieved from the payment service.
class ServiceDTO {
  /// The service unique identifier
  int? serviceId;

  /// The biller to which this service belongs to
  BillerDTO? biller;

  /// The biller id linked to this service
  String? billerId;

  /// The name of the service
  String? name;

  /// The billing id tag of the service
  String? billingIdTag;

  /// The billing id tag help of the service
  String? billingIdTagHelp;

  /// The billing id description of the service
  String? billingIdDesc;

  /// Date this service was last created.
  DateTime? created;

  /// Date this service was last updated.
  DateTime? updated;

  /// The list of service fields for this service
  List<ServiceFieldDTO>? serviceFields;

  /// extra information sent that could be for specific cases
  ServiceExtraDTO? extra;

  /// Creates a new [ServiceDTO]
  ServiceDTO({
    this.serviceId,
    this.biller,
    this.billerId,
    this.name,
    this.billingIdTag,
    this.billingIdTagHelp,
    this.billingIdDesc,
    this.created,
    this.updated,
    this.serviceFields,
    this.extra,
  });

  /// Creates a new [ServiceDTO] from json
  factory ServiceDTO.fromJson(Map<String, dynamic> json) {
    return ServiceDTO(
      serviceId: json['service_id'],
      biller:
          json['biller'] != null ? BillerDTO.fromJson(json['biller']) : null,
      billerId: json['biller_id'],
      name: json['name'],
      billingIdTag: json['billing_id_tag'],
      billingIdTagHelp: json['billing_id_tag_help'],
      billingIdDesc: json['billing_id_desc'],
      created: JsonParser.parseDate(json['ts_created']),
      updated: JsonParser.parseDate(json['ts_updated']),
      extra: json['extra'] != null
          ? ServiceExtraDTO.fromJson(json['extra'])
          : null,
      serviceFields: json['service_fields'] != null
          ? ServiceFieldDTO.fromJsonList(json['service_fields'])
          : null,
    );
  }

  /// Creates a list of [ServiceDTO]s from the given JSON list.
  static List<ServiceDTO> fromJsonList(List<Map<String, dynamic>> json) {
    return json.map(ServiceDTO.fromJson).toList(growable: false);
  }

  /// Creates a JSON map from the model data
  Map<String, dynamic> toJson() {
    return {
      'service_id': serviceId,
      'biller_id': billerId,
      'name': name,
      'billing_id_tag': billingIdTag,
      'billing_id_tag_help': billingIdTagHelp,
      'billing_id_desc': billingIdDesc,
      'ts_created': created?.millisecondsSinceEpoch,
      'ts_updated': updated?.millisecondsSinceEpoch,
      'extra': extra?.toJson(),
    };
  }
}

/// This class represents the fields that come
/// in the service extra map
/// TODO: get better documentation from BE for these fields
class ServiceExtraDTO {
  /// max amount of the service ??
  num? maxAmount;

  /// min amount of the service ??
  num? minAmount;

  /// This field represents whether the service is static or dynamic
  bool? isStatic;

  /// This field specifies if we need to validate the fields
  bool? validateFields;

  /// amount of the service ??
  num? amount;

  /// Creates a new [ServiceExtraDTO]
  ServiceExtraDTO({
    this.maxAmount,
    this.minAmount,
    this.isStatic = true,
    this.validateFields = false,
    this.amount,
  });

  /// Creates a new [ServiceExtraDTO] from json
  factory ServiceExtraDTO.fromJson(Map<String, dynamic> json) {
    return ServiceExtraDTO(
      maxAmount: json['max_amount'],
      minAmount: json['min_amount'],
      isStatic: json['static_fields'],
      validateFields: json['static_fields'],
      amount: json['amount'],
    );
  }

  /// Creates a JSON map from the model data
  Map<String, dynamic> toJson() {
    return {
      'max_amount': maxAmount,
      'min_amount': minAmount,
      'static_fields': isStatic,
      'amount': amount,
    };
  }
}
