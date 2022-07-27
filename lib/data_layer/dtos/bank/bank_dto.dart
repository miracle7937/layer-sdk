import '../../dtos.dart';
import '../../helpers.dart';

/// Data transfer object that represents a bank.
class BankDTO {
  /// The bic/swift code for the bank.
  String? bic;

  /// The bank name.
  String? name;

  /// First field for the address.
  String? address1;

  /// Second field for the address.
  String? address2;

  /// The code for the country the bank is based.
  String? countryCode;

  /// Date when the bank was created.
  DateTime? created;

  /// Last time the bank was updated.
  DateTime? updated;

  /// The country this bank is based.
  CountryDTO? country;

  /// The transfer type for this bank.
  TransferTypeDTO? transferType;

  /// The image url.
  String? imageUrl;

  /// The category.
  /// TODO: check with BE what are the available options and map into an enum.
  String? category;

  /// The bank code
  String? code;

  /// The branch code.
  String? branchCode;

  /// The branch name.
  String? branchName;

  /// Creates a new [BankDTO].
  BankDTO({
    this.bic,
    this.name,
    this.address1,
    this.address2,
    this.countryCode,
    this.created,
    this.updated,
    this.country,
    this.transferType,
    this.imageUrl,
    this.category,
    this.code,
    this.branchCode,
    this.branchName,
  });

  /// Creates a [BankDTO] from a json.
  factory BankDTO.fromJson(Map<String, dynamic> json) {
    print(json);
    return BankDTO(
      bic: json['bic'],
      name: json['name'],
      address1: json['address1'],
      address2: json['address2'],
      countryCode: json['country_code'],
      created: JsonParser.parseDate(json['ts_created']),
      updated: JsonParser.parseDate(json['ts_updated']),
      transferType: TransferTypeDTO.fromRaw(json['type']),
      country:
          json['country'] != null ? CountryDTO.fromJson(json['country']) : null,
      imageUrl: json['image_url'],
      category: json['category'],
      code: json['bank_code'],
      branchCode: json['branch_code'],
      branchName: json['branch_name'],
    );
  }

  /// Returns a list of [BankDTO] from a JSON
  static List<BankDTO> fromJsonList(List<Map<String, dynamic>> json) =>
      json.map(BankDTO.fromJson).toList();
}
