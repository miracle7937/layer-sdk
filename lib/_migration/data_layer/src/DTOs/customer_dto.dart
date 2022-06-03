import '../helpers.dart';

/// Holds the provider data for a Customer
///
/// This is basically the Customer from the core-banking
/// project with a new name.
class CustomerDTO {
  /// The id of the customer.
  String? id;

  /// The type of the customer.
  String? type;

  /// The current status of this customer.
  String? status;

  /// The title ('Mrs.', 'Mr.') this customer uses.
  String? title;

  /// The customer's first name.
  String? firstName;

  /// The customer's last name.
  String? lastName;

  /// The customer's middle names.
  String? middleName;

  /// The phone number associated with this customer.
  String? phoneNumber;

  /// The mobile phone number associated with this customer.
  String? mobileNumber;

  /// The fax phone number associated with this customer.
  String? faxNumber;

  /// The customer's e-mail.
  String? email;

  /// First line of the customer address.
  String? address1;

  /// Second line of the customer address.
  String? address2;

  /// Third line of the customer address.
  String? address3;

  /// The country where the customer resides.
  String? country;

  /// The city where the customer resides.
  String? city;

  /// The day of birth of the customer.
  DateTime? dob;

  /// If the customer is allowed to make payments.
  bool? canPay;

  /// If the customers is allowed to make internal transfers.
  bool? canTrfInternal;

  /// If the customers is allowed to make transfers between banks.
  bool? canTrfBank;

  /// If the customers is allowed to make domestic transfers.
  bool? canTrfDomestic;

  /// If the customers is allowed to make international transfers.
  bool? canTrfInternational;

  /// If the customers is allowed to receive transfers.
  bool? canReceiveTrf;

  /// If the customers has the electronic statement.
  bool? eStatement;

  /// If the customers is allowed to request a checkbook.
  bool? canRequestCheckBook;

  /// If the customers is allowed to request a card.
  bool? canRequestCard;

  /// If the customers is allowed to block a card.
  bool? canStopCard;

  /// If the customers uses the personal financial management.
  bool? hasPfm;

  /// Date this customer was created.
  DateTime? created;

  /// Date this customer was last updated.
  DateTime? updated;

  /// Date this customer was last synced with the bank.
  DateTime? synced;

  /// Iqama expiry of this customer
  DateTime? iqamaExpiry;

  /// Iqama number of this customer
  String? iqamaNumber;

  /// Customer nationality
  String? nationality;

  /// Customer mother's name
  String? motherName;

  /// Customer marital status
  String? maritalStatus;

  /// Date this customer was created.
  DateTime? cbsCreated;

  /// This customer's Core Banking Solution ID.
  String? cbsID;

  /// The bank branch that manages this customer.
  String? managingBranch;

  /// The customer information
  CustomerInformationDTO? customerInformation;

  /// This customer's bank verification number.
  String? bvn;

  /// This customer information file ID.
  String? cifId;

  /// This customer branch name
  String? branchName;

  /// This customer country name
  String? countryName;

  /// The code for what the customer does.
  String? profession;

  /// If this customer is part of the bank staff.
  bool? staff;

  /// The expiration date of the KYC.
  DateTime? kycExpiryDate;

  /// The grace period in days for expiring KYC.
  int? kycExpiryGracePeriod;

  /// The customer income.
  double? income;

  /// The currency for the income.
  String? incomeCurrency;

  /// The source of the income
  String? incomeSource;

  /// The customer's place of birth
  String? placeOfBirth;

  /// The customer's Conflict Prevention and Resolution (CPR)
  String? idNumber;

  /// The customer's CPR expiry date
  DateTime? idExpiry;

  /// The grace period in days for expiring CPR.
  int? idExpiryGracePeriod;

  /// Creates a new [CustomerDTO]
  CustomerDTO({
    this.id,
    this.type,
    this.status,
    this.title,
    this.firstName,
    this.lastName,
    this.middleName,
    this.phoneNumber,
    this.mobileNumber,
    this.faxNumber,
    this.email,
    this.canPay,
    this.canTrfInternal,
    this.canTrfBank,
    this.canTrfDomestic,
    this.canTrfInternational,
    this.canReceiveTrf,
    this.eStatement,
    this.canRequestCheckBook,
    this.canRequestCard,
    this.created,
    this.updated,
    this.synced,
    this.canStopCard,
    this.hasPfm,
    this.address1,
    this.address2,
    this.address3,
    this.country,
    this.city,
    this.dob,
    this.cbsID,
    this.managingBranch,
    this.customerInformation,
    this.bvn,
    this.cifId,
    this.cbsCreated,
    this.iqamaExpiry,
    this.iqamaNumber,
    this.nationality,
    this.motherName,
    this.maritalStatus,
    this.branchName,
    this.countryName,
    this.profession,
    this.staff,
    this.kycExpiryDate,
    this.kycExpiryGracePeriod,
    this.income,
    this.incomeCurrency,
    this.incomeSource,
    this.placeOfBirth,
    this.idNumber,
    this.idExpiry,
    this.idExpiryGracePeriod,
  });

  /// Creates a [CustomerDTO] from a JSON
  factory CustomerDTO.fromJson(Map<String, dynamic> json) => CustomerDTO(
        id: json['customer_id'],
        type: json['customer_type'],
        status: json['status'],
        title: json['title'],
        firstName: json['first_name'],
        lastName: json['last_name'],
        middleName: json['middle_name'],
        phoneNumber: json['phone_number'],
        mobileNumber: json['mobile_number'],
        faxNumber: json['fax_number'],
        email: json['email'],
        canPay: json['can_pay'] ?? true,
        canTrfInternal: json['can_trf_internal'] ?? true,
        canTrfBank: json['can_trf_bank'] ?? true,
        canTrfDomestic: json['can_trf_domestic'] ?? true,
        canTrfInternational: json['can_trf_intl'] ?? true,
        canReceiveTrf: json['can_receive_trf'] ?? true,
        eStatement: json['e_statement'] ?? false,
        canRequestCheckBook: json['can_request_chkbk'] ?? true,
        canRequestCard: json['can_request_card'] ?? true,
        created: JsonParser.parseDate(json['ts_created']),
        updated: JsonParser.parseDate(json['ts_update']),
        synced: JsonParser.parseDate(json['ts_synced']),
        canStopCard: json['can_stop_card'] ?? true,
        hasPfm: json['has_pfm'] ?? false,
        address1: json['address1'],
        address2: json['address2'],
        address3: json['address3'],
        country: json['country'],
        city: json['city'],
        dob: JsonParser.parseStringDate(json['dob']),
        cbsID: json['cbs_id'],
        managingBranch: json['managing_branch'],
        customerInformation: json['extra'] == null
            ? null
            : CustomerInformationDTO.fromJson(json['extra']).copyWith(
                passportExpiryDate: JsonParser.parseStringDate(
                  json['passport_expiry'],
                ),
                passportExpiryGracePeriod: json['passport_expiry_grace_period'],
              ),
        bvn: isNotEmpty(json['bvn'])
            ? json['bvn']
            : json['extra'] != null
                ? json['extra']['bvn']
                : null,
        cifId: isNotEmpty(json['account_nos'])
            ? json['account_nos']
            : json['extra'] != null
                ? json['extra']['account_nos']
                : null,
        cbsCreated: JsonParser.parseDate(json['cbs_created']),
        iqamaExpiry: null, //TODO: Read the field from BE
        iqamaNumber: '', //TODO: Read the field from BE
        nationality: json['nationalities'],
        motherName: json['mother_name'],
        maritalStatus: json['marital_status'],
        branchName: json['branch_name'],
        countryName: json['country_name'],
        profession: json['profession'],
        staff: json['staff'],
        kycExpiryDate: JsonParser.parseStringDate(json['kyc_expiry']),
        kycExpiryGracePeriod: json['kyc_expiry_grace_period'],
        income: JsonParser.parseDouble(json['income']),
        incomeCurrency: json['income_currency'],
        incomeSource: json['income_source'],
        placeOfBirth: json['pob'],
        idNumber: json['id_number'],
        idExpiry: JsonParser.parseStringDate(json['id_expiry']),
        idExpiryGracePeriod: json['id_expiry_grace_period'],
      );

  /// Create a JSON map from selected properties
  Map toJson() => {
        'first_name': firstName,
        'last_name': lastName,
        'address1': address1,
        'country': country,
        'mobile_number': mobileNumber,
        'dob': dob?.toIso8601String(),
        'branch_name': branchName,
        'country_name': countryName,
      };

  /// Returns a list of [CustomerDTO] from a JSON
  static List<CustomerDTO> fromJsonList(List<Map<String, dynamic>> json) =>
      json.map(CustomerDTO.fromJson).toList();
}

/// Holds the provider data for the extra information of a Customer
class CustomerInformationDTO {
  /// The name of the employer
  String? employerName;

  /// The address of the employer
  String? employerAddress;

  ///
  String? nextKinMobile;

  ///
  String? nextKinName;

  /// The occupation of the customer
  String? occupation;

  /// The expiry date of the customer's passport
  DateTime? passportExpiryDate;

  /// The grace period in days for the customer's passport.
  int? passportExpiryGracePeriod;

  /// The issue date of the customer's passport
  DateTime? passportIssueDate;

  /// The country code for the passport issuer.
  String? passportCountryIssuance;

  /// The country name for the passport issuer.
  String? passportCountryIssuanceDescription;

  /// The number of the customer's passport
  String? passportNumber;

  /// The customer's salary
  String? salary;

  /// The customer's source of funds
  String? sourceOfFunds;

  /// If the customer is a resident.
  String? isResident;

  /// The list of customer addresses
  List<AddressDTO>? addresses;

  /// Government position holder or PEP (politically exposed person)
  String? governmentPosition;

  /// Information when the customer is acting on behalf of a third party.
  String? thirdParty;

  /// Information when the customer is the ultimate beneficiary of the account.
  String? ultimateBeneficiary;

  /// The list of other names this customer had in the past.
  List<String>? otherNames;

  /// Customer's taxes outside the country.
  List<TaxDTO>? taxes;

  /// Customer's other nationalities
  List<NationalityDTO>? otherNationalities;

  /// The Foreign Account Tax Compliance Act (FATCA) status.
  bool? fatcaStatus;

  /// Nature and volume of business dealings.
  String? businessDealings;

  /// URL for the other party document.
  String? otherParty;

  /// URL for the beneficiary document.
  String? beneficiaryDocument;

  /// The company name this customer works on.
  String? companyName;

  /// The company type of the company this customer works on.
  String? companyType;

  /// Creates a new [CustomerInformationDTO]
  CustomerInformationDTO({
    this.employerName,
    this.employerAddress,
    this.nextKinMobile,
    this.nextKinName,
    this.occupation,
    this.passportExpiryDate,
    this.passportExpiryGracePeriod,
    this.passportIssueDate,
    this.passportCountryIssuance,
    this.passportCountryIssuanceDescription,
    this.passportNumber,
    this.salary,
    this.sourceOfFunds,
    this.isResident,
    this.addresses,
    this.governmentPosition,
    this.thirdParty,
    this.ultimateBeneficiary,
    this.otherNames,
    this.taxes,
    this.otherNationalities,
    this.fatcaStatus,
    this.businessDealings,
    this.otherParty,
    this.beneficiaryDocument,
    this.companyName,
    this.companyType,
  });

  /// Creates a [CustomerInformationDTO] from a JSON
  factory CustomerInformationDTO.fromJson(Map<String, dynamic> json) =>
      CustomerInformationDTO(
        employerName: json['employer_name'],
        employerAddress: json['employer_address'],
        nextKinMobile: json['next_of_kin_mobile_number'],
        nextKinName: json['next_of_kin'],
        occupation: json['occupation'],
        passportExpiryDate: JsonParser.parseStringDate(json['passport_expiry']),
        passportExpiryGracePeriod: json['passport_expiry_grace_period'],
        passportIssueDate: JsonParser.parseStringDate(
          json['passport_date_of_issuance'] ?? json['passport_issue_date'],
        ),
        passportCountryIssuance: json['passport_country_of_issuance'],
        passportCountryIssuanceDescription:
            json['passport_country_of_issuance_description'],
        passportNumber: json['passport_number'],
        sourceOfFunds: json['source_funds'],
        isResident: json['is_resident'],
        addresses: json['address_details'] == null
            ? null
            : AddressDTO.fromJsonList(json['address_details']),
        governmentPosition: json['pep'],
        thirdParty: json['representation'],
        ultimateBeneficiary: json['ultimate_beneficiary'],
        otherNames: json['other_names']?.split(','),
        taxes: json['tax_information'] == null
            ? null
            : TaxDTO.fromJsonList(json['tax_information']),
        otherNationalities: json['other_nationalities'] == null
            ? null
            : json['other_nationalities'] is List
                ? NationalityDTO.fromJsonList(json['other_nationalities'])
                : null,
        fatcaStatus: json['fatca_status'],
        salary: json['salary'],
        businessDealings: json['business'],
        otherParty: json['other_party'],
        beneficiaryDocument: json['beneficiary_document'],
        companyName: json['company_name'],
        companyType: json['company_type'],
      );

  /// Returns a list of [CustomerInformationDTO] from a JSON
  static List<CustomerInformationDTO> fromJsonList(
          List<Map<String, dynamic>> json) =>
      json.map(CustomerInformationDTO.fromJson).toList();

  /// Returns a copy of the customer DTO with select different values.
  CustomerInformationDTO copyWith({
    String? employerName,
    String? employerAddress,
    String? nextKinMobile,
    String? nextKinName,
    String? occupation,
    DateTime? passportExpiryDate,
    int? passportExpiryGracePeriod,
    DateTime? passportIssueDate,
    String? passportCountryIssuance,
    String? passportCountryIssuanceDescription,
    String? passportNumber,
    String? salary,
    String? sourceOfFunds,
    String? isResident,
    List<AddressDTO>? addresses,
    String? governmentPosition,
    String? thirdParty,
    String? ultimateBeneficiary,
    List<String>? otherNames,
    List<TaxDTO>? taxes,
    List<NationalityDTO>? otherNationalities,
    bool? fatcaStatus,
    String? businessDealings,
    String? otherParty,
    String? beneficiaryDocument,
    String? companyName,
    String? companyType,
  }) =>
      CustomerInformationDTO(
        employerName: employerName ?? this.employerName,
        employerAddress: employerAddress ?? this.employerAddress,
        nextKinMobile: nextKinMobile ?? this.nextKinMobile,
        nextKinName: nextKinName ?? this.nextKinName,
        occupation: occupation ?? this.occupation,
        passportExpiryDate: passportExpiryDate ?? this.passportExpiryDate,
        passportExpiryGracePeriod:
            passportExpiryGracePeriod ?? this.passportExpiryGracePeriod,
        passportIssueDate: passportIssueDate ?? this.passportIssueDate,
        passportCountryIssuance:
            passportCountryIssuance ?? this.passportCountryIssuance,
        passportCountryIssuanceDescription:
            passportCountryIssuanceDescription ??
                this.passportCountryIssuanceDescription,
        passportNumber: passportNumber ?? this.passportNumber,
        salary: salary ?? this.salary,
        sourceOfFunds: sourceOfFunds ?? this.sourceOfFunds,
        isResident: isResident ?? this.isResident,
        addresses: addresses ?? this.addresses,
        governmentPosition: governmentPosition ?? this.governmentPosition,
        thirdParty: thirdParty ?? this.thirdParty,
        ultimateBeneficiary: ultimateBeneficiary ?? this.ultimateBeneficiary,
        otherNames: otherNames ?? this.otherNames,
        taxes: taxes ?? this.taxes,
        otherNationalities: otherNationalities ?? this.otherNationalities,
        fatcaStatus: fatcaStatus ?? this.fatcaStatus,
        businessDealings: businessDealings ?? this.businessDealings,
        otherParty: otherParty ?? this.otherParty,
        beneficiaryDocument: beneficiaryDocument ?? this.beneficiaryDocument,
        companyName: companyName ?? this.companyName,
        companyType: companyType ?? this.companyType,
      );
}

/// Holds the provider data for the Customer addresses.
class AddressDTO {
  /// First line of the address
  String? address1;

  /// The area the customer lives in.
  String? area;

  /// The block number
  String? blockNumber;

  /// The building
  String? building;

  /// The email
  String? email;

  /// The mobile number
  String? mobileNumber;

  /// The road number
  String? roadNumber;

  /// Creates a new [AddressDTO]
  AddressDTO({
    this.address1,
    this.area,
    this.blockNumber,
    this.building,
    this.email,
    this.mobileNumber,
    this.roadNumber,
  });

  /// Returns a [AddressDTO] from a JSON
  factory AddressDTO.fromJson(Map<String, dynamic> json) => AddressDTO(
        address1: json['address1'],
        area: json['area'],
        blockNumber: json['block_number'],
        building: json['building'],
        email: json['email'],
        mobileNumber: json['mobile_number'],
        roadNumber: json['road_number'],
      );

  /// Returns a list of [AddressDTO] from a JSON
  static List<AddressDTO> fromJsonList(List<Map<String, dynamic>> json) =>
      json.map(AddressDTO.fromJson).toList();
}

/// Holds the provider data for the Customer tax inforamtion.
class TaxDTO {
  /// The taxing country name
  String? countryName;

  /// The taxing country code
  String? countryCode;

  /// The Taxpayer identification number (TIN)
  String? tin;

  /// Creates a new [TaxDTO]
  TaxDTO({
    this.countryName,
    this.countryCode,
    this.tin,
  });

  /// Creates a [TaxDTO] from a JSON
  factory TaxDTO.fromJson(Map<String, dynamic> json) => TaxDTO(
        countryName: json['country_name'],
        countryCode: json['country_code'],
        tin: json['tin'],
      );

  /// Creates a [TaxDTO] list from a JSON
  static List<TaxDTO> fromJsonList(List<Map<String, dynamic>> json) =>
      json.map(TaxDTO.fromJson).toList();
}

/// Holds the provider data for a Customer nationality.
class NationalityDTO {
  /// The country name
  String? countryName;

  /// The country code
  String? countryCode;

  /// Creates a new [NationalityDTO]
  NationalityDTO({
    this.countryName,
    this.countryCode,
  });

  /// Creates a [NationalityDTO] from a JSON
  factory NationalityDTO.fromJson(dynamic json) {
    if (json is String) {
      return NationalityDTO(countryCode: json);
    }

    return NationalityDTO(
      countryName: json['country_name'],
      countryCode: json['country_code'],
    );
  }

  /// Creates a [NationalityDTO] list from a JSON
  static List<NationalityDTO> fromJsonList(List<Map<String, dynamic>> json) =>
      json.map(NationalityDTO.fromJson).toList();
}
