import '../../helpers.dart';

/// Data transfer object representing beneficiaries
/// retrieved from the payment service.
class BillerDTO {
  /// The unique id of the biller
  String? billerId;

  /// The name of the biller
  String? name;

  /// The category code of the biller
  String? categoryCode;

  /// The category description of the biller
  String? categoryDesc;

  /// The website of the biller
  String? website;

  /// The email of the biller
  String? email;

  /// The phone number of the biller
  String? phoneNumber;

  /// The date of creation of the biller
  DateTime? created;

  /// The last date the biller was updated
  DateTime? updated;

  /// The status of the biller
  /// TODO: check with BE possible values
  String? status;

  /// The image url of the biller
  String? imageUrl;

  /// Creates a new [BillerDTO]
  BillerDTO({
    this.billerId,
    this.name,
    this.categoryCode,
    this.categoryDesc,
    this.website,
    this.email,
    this.phoneNumber,
    this.created,
    this.updated,
    this.status,
    this.imageUrl,
  });

  /// Creates a [BillerDTO] from a JSON
  factory BillerDTO.fromJson(Map<String, dynamic> json) {
    return BillerDTO(
      billerId: json['biller_id'],
      name: json['name'],
      categoryCode: json['category_code'],
      categoryDesc: json['category_desc'],
      website: json['website'],
      email: json['email'],
      phoneNumber: json['phone_number'],
      created: JsonParser.parseDate(json['ts_created']),
      updated: JsonParser.parseDate(json['ts_updated']),
      status: json['status'],
      imageUrl: json['image_url'],
    );
  }
}
