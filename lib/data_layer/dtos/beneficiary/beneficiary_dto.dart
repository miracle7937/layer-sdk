import 'package:collection/collection.dart';

import '../../dtos.dart';
import '../../helpers.dart';

/// Data transfer object representing beneficiaries
/// retrieved from the txn service.
class BeneficiaryDTO {
  /// The id of the customer.
  int? beneficiaryId;

  /// The otp Id.
  int? otpId;

  /// The beneficiary's first name.
  String? firstName;

  /// The beneficiary's last name.
  String? lastName;

  /// The beneficiary's middle name.
  String? middleName;

  /// The nickname associated with this beneficiary.
  String? nickname;

  /// The transfer type associated with this beneficiary.
  TransferTypeDTO? type;

  /// The current status of this beneficiary.
  BeneficiaryDTOStatus? status;

  /// The account number associated with this beneficiary.
  String? accountNumber;

  /// The name of the bank where this beneficiary is a customer.
  String? bankName;

  /// The beneficiary's currency.
  String? currency;

  /// The beneficiary's address.
  String? rcptAddress1;

  /// The beneficiary's address.
  String? rcptAddress2;

  /// The beneficiary's address.
  String? rcptAddress3;

  /// The beneficiary's country code.
  String? rcptCountryCode;

  /// The beneficiary's bank address.
  String? bankAddress1;

  /// The beneficiary's bank address.
  String? bankAddress2;

  /// The beneficiary's bank country code.
  String? bankCountryCode;

  /// The beneficiary's bank swift code.
  String? bankSwift;

  /// Date this beneficiary was created.
  DateTime? created;

  /// Date this beneficiary was last updated.
  DateTime? updated;

  /// A description of the beneficiary.
  String? description;

  /// The beneficiary's routing code.
  String? routingCode;

  /// The beneficiary's second factor type.
  SecondFactorTypeDTO? secondFactor;

  /// The beneficiary's Bank image url
  String? bankImageUrl;

  /// Extra data fo this beneficiary.
  String? extra;

  /// Creates a new [BeneficiaryDTO]
  BeneficiaryDTO({
    this.beneficiaryId,
    this.otpId,
    this.firstName,
    this.lastName,
    this.middleName,
    this.nickname,
    this.type,
    this.status,
    this.accountNumber,
    this.bankName,
    this.currency,
    this.rcptAddress1,
    this.rcptAddress2,
    this.rcptAddress3,
    this.rcptCountryCode,
    this.bankAddress1,
    this.bankAddress2,
    this.bankCountryCode,
    this.bankSwift,
    this.created,
    this.updated,
    this.description,
    this.routingCode,
    this.secondFactor,
    this.bankImageUrl,
    this.extra,
  });

  /// Creates a [BeneficiaryDTO] from a JSON
  factory BeneficiaryDTO.fromJson(Map<String, dynamic> json) => BeneficiaryDTO(
        beneficiaryId: json['beneficiary_id'],
        otpId: json['otp_id'],
        firstName: json['rcpt_first_name'],
        middleName: json['rcpt_middle_name'],
        lastName: json['rcpt_last_name'],
        nickname: json['nickname'],
        type: TransferTypeDTO.fromRaw(json['type']),
        status: BeneficiaryDTOStatus.fromRaw(json['status']),
        currency: json['currency'],
        accountNumber: json['account_number'],
        rcptAddress1: json['rcpt_address_1'],
        rcptAddress2: json['rcpt_address_2'],
        rcptAddress3: json['rcpt_address_3'],
        rcptCountryCode: json['rcpt_country_code'],
        bankAddress1: json['bank_address_1'],
        bankAddress2: json['bank_address_2'],
        bankCountryCode: json['bank_country_code'],
        bankName: json['bank_name'],
        bankSwift: json['bank_swift'],
        created: JsonParser.parseDate(json['ts_created']),
        updated: JsonParser.parseDate(json['ts_updated']),
        description: json['description'],
        routingCode: json['routing_code'],
        secondFactor: SecondFactorTypeDTO.fromRaw(json['second_factor']),
        bankImageUrl: json['bank_image_url'],
        extra: json['extra'],
      );

  /// Returns a list of [BeneficiaryDTO] from a JSON
  static List<BeneficiaryDTO> fromJsonList(List<Map<String, dynamic>> json) =>
      json.map(BeneficiaryDTO.fromJson).toList();

  // {
  // bool verifyOTP = false,
  // isPatch = false,
  // isShortcut = false,
  // bool includeBeneficiaryID = false,
  // }
  /// Creates a new JSON from this [BeneficiaryDTO].
  Map<String, dynamic> toJson({
    bool isEditing = false,
    bool isVerifyOtp = false,
  }) {
    var json = <String, dynamic>{
      'nickname': nickname,
      'rcpt_first_name': firstName,
      'rcpt_middle_name': middleName,
      'rcpt_last_name': lastName,
      'account_number': accountNumber,
      'rcpt_address_1': rcptAddress1,
      'rcpt_address_2': rcptAddress2,
      'rcpt_address_3': rcptAddress3,
      'rcpt_country_code': rcptCountryCode,
      'bank_address_1': bankAddress1,
      'bank_address_2': bankAddress2,
      'bank_country_code': bankCountryCode,
      'bank_name': bankName,
      'bank_swift': bankSwift,
      'routing_code': routingCode,
      'currency': currency,
      if (isEditing || isVerifyOtp) 'beneficiary_id': beneficiaryId,
      'type': type?.value,
      // 'otp_id': verifyOTP ? otpID : null,
      // 'image': _base64Image,
      // 'image_url': isShortcut ? imageUrl : null,
      // 'rcpt_id_number': cprNumber,
      // 'extra': extra,
      // 'provider': qrProvider?.value,
      // 'additional_info': additionalInfo,
      'visible': true,
    };
    // if (visible != null && !visible!) {
    //   json['visible'] = false;
    // } else {
    //   json['visible'] = isShortcut ? false : true;
    // }

    // //TODO(MO): it is becoming messy with too much configs, consider refactoring
    // //Added this config separately, so we know exactly what it is doing
    // if (includeBeneficiaryID) {
    //   json['account_number'] = null;
    //   json['beneficiary_id'] = beneficiaryID;
    //   if (isNotEmpty(extra)) {
    //     try {
    //       var decodedExtra = jsonDecode(extra!);
    //       if (decodedExtra is Map) {
    //         decodedExtra['masked_card_number'] = accountNumber;
    //         final String encodedExtra = jsonEncode(decodedExtra);
    //         json['extra'] = encodedExtra;
    //       }
    //     } catch (error) {}
    //   } else {
    //     json['extra'] = jsonEncode({'masked_card_number': accountNumber});
    //   }
    // }

    return json;
  }
}

/// The beneficiary status
class BeneficiaryDTOStatus extends EnumDTO {
  /// beneficiary is active
  static const active = BeneficiaryDTOStatus._internal('A');

  /// beneficiary is pending approval
  static const pending = BeneficiaryDTOStatus._internal('P');

  /// beneficiary is deleted
  static const deleted = BeneficiaryDTOStatus._internal('D');

  /// beneficiary is rejected
  static const rejected = BeneficiaryDTOStatus._internal('R');

  /// beneficiary is pending otp
  static const otp = BeneficiaryDTOStatus._internal('O');

  /// TODO: clarify with BE what this status represents
  static const system = BeneficiaryDTOStatus._internal('S');

  /// All the available beneficiary status in a list
  static const List<BeneficiaryDTOStatus> values = [
    active,
    pending,
    deleted,
    rejected,
    otp,
    system
  ];

  const BeneficiaryDTOStatus._internal(String value) : super.internal(value);

  /// Creates a [BeneficiaryDTOStatus] from a [String]
  static BeneficiaryDTOStatus? fromRaw(String? raw) => values.firstWhereOrNull(
        (val) => val.value == raw,
      );
}
