import '../../dtos.dart';

///Data transfer object representing the bulk detail of a transfer
class BulkDetailDTO {
  ///The bulk detail id
  int? id;

  ///The [TransferStatusDTO] status
  TransferStatusDTO? transferStatus;

  ///Creates a new [BulkDetailDTO] object
  BulkDetailDTO({
    this.id,
    this.transferStatus,
  });

  /// Creates a [BulkDetailDTO] from a JSON
  factory BulkDetailDTO.fromJson(Map<String, dynamic> json) => BulkDetailDTO(
        id: json['item_id'],
        transferStatus: TransferStatusDTO.fromRaw(json['status']),
      );

  /// Creates a List of [BulkDetailDTO] from list of JSON
  static List<BulkDetailDTO> fromJsonList(List<Map<String, dynamic>> json) =>
      json.map(BulkDetailDTO.fromJson).toList();
}
