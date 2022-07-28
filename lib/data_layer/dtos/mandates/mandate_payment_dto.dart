import '../../helpers/enum_dto.dart';
import '../../helpers/json_parser.dart';

/// Class that holds data for Mandates that were paid
class MandatePaymentDTO {
  /// The payment id
  final int? paymentId;

  /// The mandateId
  final int? mandateId;

  /// The payment status
  final MandatePaymentStatusDTO? status;

  /// The payment currency
  final String? currency;

  /// The payment amount
  final double? amount;

  /// The payment reference
  final String? reference;

  /// The payment id on the bank
  final String? bankPaymentId;

  /// When it was created
  final DateTime? tsCreated;

  /// When it was updates
  final DateTime? tsUpdated;

  /// Creates a new [MandatePaymentDTO] instance
  MandatePaymentDTO({
    this.paymentId,
    this.mandateId,
    this.status,
    this.currency,
    this.amount,
    this.reference,
    this.bankPaymentId,
    this.tsCreated,
    this.tsUpdated,
  });

  /// Creates a [MandatePaymentDTO] from a json map
  factory MandatePaymentDTO.fromJson(Map<String, dynamic> json) {
    return MandatePaymentDTO(
      paymentId: JsonParser.parseInt(json['payment_id']),
      mandateId: JsonParser.parseInt(json['mandate_id']),
      status: MandatePaymentStatusDTO.fromRaw(json['status']),
      currency: json['currency'],
      amount: JsonParser.parseDouble(json['amount']),
      reference: json['reference'],
      bankPaymentId: json['bank_payment_id'],
      tsCreated: JsonParser.parseDate(json['ts_created']),
      tsUpdated: JsonParser.parseDate(json['ts_updated']),
    );
  }

  /// Return a list of [MandatePaymentDTO] from a json list
  static Future<List<MandatePaymentDTO>> fromJsonList(
    List<Map<String, dynamic>> json,
  ) async {
    return json.map(MandatePaymentDTO.fromJson).toList();
  }
}

/// Enum that holds the status of a [MandatePaymentDTO]
class MandatePaymentStatusDTO extends EnumDTO {
  const MandatePaymentStatusDTO._internal(String value) : super.internal(value);

  /// Payment with status active
  static const active = MandatePaymentStatusDTO._internal('A');

  /// Payment with status returning
  static const returning = MandatePaymentStatusDTO._internal("P");

  /// Payment with status accepted
  static const accepted = MandatePaymentStatusDTO._internal("C");

  /// Payment with status pending
  static const pending = MandatePaymentStatusDTO._internal("P");

  /// Payment with status declined
  static const declined = MandatePaymentStatusDTO._internal("R");

  /// Payment with status unknown
  static const unknown = MandatePaymentStatusDTO._internal("");

  /// A list of all possible statuses
  static final values = [
    active,
    returning,
    accepted,
    pending,
    declined,
    unknown,
  ];

  /// Parse a string to its respective status
  static MandatePaymentStatusDTO fromRaw(String? raw) {
    return values.firstWhere(
      (it) => it.value == raw,
      orElse: () => MandatePaymentStatusDTO.unknown,
    );
  }
}
