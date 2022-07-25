import '../../dtos.dart';

/// Class that holds data for Mandates
class MandateDTO {
  /// The Id of the mandate
  final int? mandateId;

  /// Account used on the mandate
  final String? fromAccount;

  /// Card number used on the mandate
  final String? fromCard;

  /// Status of the mandate
  final MandateStatusDTO? mandateStatus;

  /// Reference for the mandate
  final String? reference;

  /// Id of the bank used in the mandate
  final int? bankMandateId;

  /// When it was created
  final DateTime? createdAt;

  /// Last time it was updated
  final DateTime? updatedAt;

  /// Creates a new [MandateDTO] instance
  MandateDTO({
    this.mandateId,
    this.fromAccount,
    this.fromCard,
    this.mandateStatus,
    this.reference,
    this.bankMandateId,
    this.createdAt,
    this.updatedAt,
  });

  /// Returns a [MandateDTO] object from json map
  factory MandateDTO.fromJson(Map<String, dynamic> json) {
    return MandateDTO(
      mandateId: json['mandate_id']?.toInt(),
      fromAccount: json['from_account'],
      fromCard: json['from_card'],
      mandateStatus: MandateStatusDTO(json['status'] ?? ''),
      reference: json['reference'],
      bankMandateId: json['bank_mandate_id']?.toInt(),
      createdAt: json['ts_created'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['ts_created'])
          : null,
      updatedAt: json['ts_updated'] != null
          ? DateTime.fromMillisecondsSinceEpoch(json['ts_updated'])
          : null,
    );
  }

  /// Return a list of [MandateDTO] from a json list
  static Future<List<MandateDTO>> fromJsonList(
    List<Map<String, dynamic>> json,
  ) async {
    return json.map(MandateDTO.fromJson).toList();
  }
}
