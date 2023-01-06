import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';

import '../../models.dart';

/// The genders a customer can have.
enum CustomerGender {
  /// Female.
  female,

  /// Male.
  male,

  /// Unknown.
  unknown,
}

/// The status a customer can have.
enum CustomerStatus {
  /// Active.
  active,

  /// Disabled.
  disabled,

  /// Suspended.
  suspended,

  /// Blocked.
  blocked,

  /// Deceased.
  deceased,

  /// Unknown.
  unknown,
}

/// The type of a customer.
enum CustomerType {
  /// A person.
  personal,

  /// A corporation.
  corporate,

  /// A joint-venture.
  joint,

  /// Unknown.
  unknown,
}

/// Available marital statuses for the Customer.
enum CustomerMaritalStatus {
  /// Married status.
  married,

  /// Single status.
  single,

  /// Divorced status.
  divorced,

  /// Widowed status.
  widowed,

  /// Unknown.
  unknown,
}

/// The customer data used by the application.
class Customer extends Equatable {
  /// The customer id. Required.
  final String id;

  /// The current status of the customer.
  ///
  /// Defaults to [CustomerStatus.unknown].
  final CustomerStatus status;

  /// The customer type.
  ///
  /// Defaults to [CustomerType.personal].
  final CustomerType type;

  /// Holds the extra data for a personal customer.
  ///
  /// If the customer is a corporation, this will be always null.
  final PersonalCustomerData? personalData;

  /// Holds the extra data for a corporate customer.
  ///
  /// If the customer is not a corporation, this will be always null.
  final CorporateCustomerData? corporateData;

  /// The customer's first name.
  final String firstName;

  /// The customer's last name.
  final String lastName;

  /// The customer's middle name.
  final String middleName;

  /// The list of customer addresses
  final UnmodifiableListView<Address> addresses;

  /// Customer nationalities.
  final UnmodifiableListView<String> nationalities;

  /// The date the customer was created.
  final DateTime? created;

  /// If the customers has the electronic statement enabled.
  final bool eStatement;

  /// The customer's Conflict Prevention and Resolution (CPR) data.
  final CPR cpr;

  /// If the customers is part of the staff.
  ///
  /// Defaults to `false`.
  final bool isStaff;

  /// The customers branch name.
  final String branchName;

  /// The branch that manages this customer.
  final String managingBranch;

  /// Government position holder or PEP (politically exposed person)
  final String governmentPosition;

  /// The list of other names this customer had in the past.
  final UnmodifiableListView<String> otherNames;

  /// If the customer has signed the vault disclaimer.
  ///
  /// Defaults to `false`.
  final bool vaultDisclaimer;

  /// The Foreign Account Tax Compliance Act (FATCA) status.
  final bool fatcaStatus;

  /// The day of birth of the customer.
  final DateTime? dob;

  /// Creates a new immutable [Customer]
  Customer({
    required this.id,
    this.status = CustomerStatus.unknown,
    this.type = CustomerType.personal,
    PersonalCustomerData? personalData,
    CorporateCustomerData? corporateData,
    this.firstName = '',
    this.lastName = '',
    this.middleName = '',
    Iterable<Address>? addresses,
    Iterable<String>? nationalities,
    this.created,
    this.dob,
    this.eStatement = false,
    this.cpr = const CPR(),
    this.isStaff = false,
    this.branchName = '',
    this.managingBranch = '',
    this.governmentPosition = '',
    Iterable<String>? otherNames,
    this.vaultDisclaimer = false,
    this.fatcaStatus = false,
  })  : addresses = UnmodifiableListView(
          addresses ?? <Address>[],
        ),
        nationalities = UnmodifiableListView(nationalities ?? <String>[]),
        otherNames = UnmodifiableListView(otherNames ?? <String>[]),
        personalData = type == CustomerType.corporate
            ? null
            : (personalData ?? PersonalCustomerData()),
        corporateData = type == CustomerType.corporate
            ? (corporateData ?? CorporateCustomerData())
            : null;

  /// Returns the full name of this customer.
  String get fullName => [
        firstName.trim(),
        middleName.trim(),
        lastName.trim(),
      ].where((e) => e.isNotEmpty).join(' ');

  /// Returns the customer's main nationality.
  ///
  /// Right now, we just get the first one, if any.
  String get mainNationality =>
      nationalities.isNotEmpty ? nationalities.first : '';

  /// Returns the customer's email address
  String get email => addresses.isNotEmpty ? addresses.first.email : '';

  /// The customer's mobile phone number
  String get mobile => addresses.isNotEmpty ? addresses.first.mobileNumber : '';

  /// Returns the customer's country name
  String get countryName => addresses.isNotEmpty ? addresses.first.country : '';

  /// Returns the code of the country the customer is based on.
  String get country => addresses.isNotEmpty ? addresses.first.country : '';

  /// Returns the customer's city name
  String get city => addresses.isNotEmpty ? addresses.first.city : '';

  /// Returns the customer's phone number.
  String get phone => addresses.isNotEmpty ? addresses.first.phone : '';

  /// Returns the customer's fax number.
  String get fax => addresses.isNotEmpty ? addresses.first.fax : '';

  @override
  List<Object?> get props => [
        id,
        status,
        type,
        personalData,
        corporateData,
        firstName,
        lastName,
        middleName,
        addresses,
        nationalities,
        created,
        eStatement,
        cpr,
        isStaff,
        branchName,
        managingBranch,
        governmentPosition,
        otherNames,
        vaultDisclaimer,
        fatcaStatus,
      ];

  /// Returns a copy of the customer with select different values.
  Customer copyWith({
    String? id,
    CustomerStatus? status,
    CustomerType? type,
    PersonalCustomerData? personalData,
    CorporateCustomerData? corporateData,
    String? firstName,
    String? lastName,
    String? middleName,
    Iterable<Address>? addresses,
    Iterable<String>? nationalities,
    DateTime? created,
    bool? eStatement,
    CPR? cpr,
    bool? isStaff,
    String? branchName,
    String? managingBranch,
    String? governmentPosition,
    Iterable<String>? otherNames,
    bool? vaultDisclaimer,
    bool? fatcaStatus,
  }) =>
      Customer(
        id: id ?? this.id,
        status: status ?? this.status,
        type: type ?? this.type,
        personalData: personalData ?? this.personalData,
        corporateData: corporateData ?? this.corporateData,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        middleName: middleName ?? this.middleName,
        addresses: addresses ?? this.addresses,
        nationalities: nationalities ?? this.nationalities,
        created: created ?? this.created,
        eStatement: eStatement ?? this.eStatement,
        cpr: cpr ?? this.cpr,
        isStaff: isStaff ?? this.isStaff,
        branchName: branchName ?? this.branchName,
        managingBranch: managingBranch ?? this.managingBranch,
        governmentPosition: governmentPosition ?? this.governmentPosition,
        otherNames: otherNames ?? this.otherNames,
        vaultDisclaimer: vaultDisclaimer ?? this.vaultDisclaimer,
        fatcaStatus: fatcaStatus ?? this.fatcaStatus,
      );
}

/// Holds data that is specific for the personal customer.
class PersonalCustomerData extends Equatable {
  /// The customer's title, for instance 'Mrs.' or 'Mr.'.
  final String title;

  /// If the customer is a resident.
  ///
  /// Defaults to `false`.
  final bool isResident;

  /// The customer passport information.
  final Passport passport;

  /// The customer's postalCode
  final String? postalCode;

  /// The DOB of the customer.
  final DateTime? dateOfBirth;

  /// The customer's place of birth.
  final String placeOfBirth;

  /// The customer employment details.
  final EmploymentDetails employment;

  /// The Know-Your-Customer data.
  final KYC kyc;

  /// The Iqama (Kingdom of Saudi Arabia government residency card) details.
  final Iqama iqama;

  /// Customer marital status.
  ///
  /// Defaults to [CustomerMaritalStatus.unknown].
  final CustomerMaritalStatus maritalStatus;

  /// The customer's mother's name.
  final String motherName;

  /// Holds the data for the next of kin.
  final NextOfKin nextOfKin;

  /// Information when the customer is acting on behalf of a third party.
  final String thirdParty;

  /// Information when the customer is the ultimate beneficiary of the account.
  final String ultimateBeneficiary;

  /// Customer's taxes outside the country.
  final UnmodifiableListView<Tax> taxes;

  /// Customer's other nationalities
  final UnmodifiableListView<Nationality> otherNationalities;

  /// URL for the other party document.
  final String otherParty;

  /// URL for the beneficiary document.
  final String beneficiaryDocument;

  /// The Company this customer works to.
  final CustomerCompany company;

  /// Selected biller id
  final String? billerId;

  /// Creates a new [PersonalCustomerData].
  PersonalCustomerData({
    this.title = '',
    this.isResident = false,
    this.passport = const Passport(),
    this.postalCode,
    this.dateOfBirth,
    this.placeOfBirth = '',
    this.employment = const EmploymentDetails(),
    this.kyc = const KYC(),
    this.iqama = const Iqama(),
    this.maritalStatus = CustomerMaritalStatus.unknown,
    this.motherName = '',
    this.nextOfKin = const NextOfKin(),
    this.thirdParty = '',
    this.ultimateBeneficiary = '',
    this.beneficiaryDocument = '',
    this.otherParty = '',
    this.company = const CustomerCompany(),
    Iterable<Tax>? taxes,
    Iterable<Nationality>? otherNationalities,
    this.billerId,
  })  : taxes = UnmodifiableListView(taxes ?? <Tax>[]),
        otherNationalities = UnmodifiableListView(
          otherNationalities ?? <Nationality>[],
        );

  /// Returns if there's any data for the passport.
  bool get hasPassport => !passport.isEmpty;

  @override
  List<Object?> get props => [
        title,
        isResident,
        passport,
        postalCode,
        dateOfBirth,
        placeOfBirth,
        employment,
        kyc,
        iqama,
        maritalStatus,
        motherName,
        nextOfKin,
        thirdParty,
        ultimateBeneficiary,
        taxes,
        otherNationalities,
        company,
        billerId,
      ];

  /// Returns a copy of the personal data with select different values.
  PersonalCustomerData copyWith({
    String? title,
    bool? isResident,
    Passport? passport,
    String? postalCode,
    DateTime? dateOfBirth,
    String? placeOfBirth,
    EmploymentDetails? employment,
    KYC? kyc,
    Iqama? iqama,
    CustomerMaritalStatus? maritalStatus,
    String? motherName,
    NextOfKin? nextOfKin,
    String? thirdParty,
    String? ultimateBeneficiary,
    Iterable<Tax>? taxes,
    Iterable<Nationality>? otherNationalities,
    CustomerCompany? company,
    String? billerId,
  }) =>
      PersonalCustomerData(
        title: title ?? this.title,
        isResident: isResident ?? this.isResident,
        passport: passport ?? this.passport,
        postalCode: postalCode ?? this.postalCode,
        dateOfBirth: dateOfBirth ?? this.dateOfBirth,
        placeOfBirth: placeOfBirth ?? this.placeOfBirth,
        employment: employment ?? this.employment,
        kyc: kyc ?? this.kyc,
        iqama: iqama ?? this.iqama,
        maritalStatus: maritalStatus ?? this.maritalStatus,
        motherName: motherName ?? this.motherName,
        nextOfKin: nextOfKin ?? this.nextOfKin,
        thirdParty: thirdParty ?? this.thirdParty,
        ultimateBeneficiary: ultimateBeneficiary ?? this.ultimateBeneficiary,
        taxes: taxes ?? this.taxes,
        otherNationalities: otherNationalities ?? this.otherNationalities,
        company: company ?? this.company,
        billerId: billerId ?? this.billerId,
      );
}

/// Holds data that is specific for the corporate customer.
class CorporateCustomerData extends Equatable {
  /// The Know-Your-Customer data.
  final KYC kyc;

  /// The Company this customer represents.
  final CustomerCompany company;

  /// Creates a new [PersonalCustomerData].
  const CorporateCustomerData({
    this.kyc = const KYC(),
    this.company = const CustomerCompany(),
  });

  @override
  List<Object?> get props => [
        kyc,
        company,
      ];

  /// Returns a copy of the corporate data with select different values.
  CorporateCustomerData copyWith({
    KYC? kyc,
    CustomerCompany? company,
  }) =>
      CorporateCustomerData(
        kyc: kyc ?? this.kyc,
        company: company ?? this.company,
      );
}

/// Holds the address data
class Address extends Equatable {
  /// Addresses list
  final UnmodifiableListView<String> addressLines;

  /// Address area
  final String area;

  /// Address block number
  final String blockNumber;

  /// Address building
  final String building;

  /// Address email
  final String email;

  /// Address road number
  final String roadNumber;

  /// Address country code
  final String country;

  /// Address country name
  final String countryName;

  /// Address city name
  final String city;

  /// Address mobile number
  final String mobileNumber;

  /// Address phone number.
  final String phone;

  /// Adress fax number.
  final String fax;

  /// Creates a new [Address]
  Address({
    Iterable<String>? addressLines,
    this.area = '',
    this.blockNumber = '',
    this.building = '',
    this.email = '',
    this.roadNumber = '',
    this.country = '',
    this.countryName = '',
    this.city = '',
    this.mobileNumber = '',
    this.phone = '',
    this.fax = '',
  }) : addressLines = UnmodifiableListView(addressLines ?? <String>[]);

  @override
  List<Object> get props => [
        addressLines,
        area,
        blockNumber,
        building,
        email,
        roadNumber,
        country,
        countryName,
        city,
        mobileNumber,
        phone,
        fax,
      ];

  /// Returns a copy of the address with select different values.
  Address copyWith({
    Iterable<String>? addressLines,
    String? area,
    String? blockNumber,
    String? building,
    String? email,
    String? roadNumber,
    String? city,
    String? country,
    String? countryName,
    String? mobileNumber,
    String? phone,
    String? fax,
  }) =>
      Address(
        addressLines: addressLines ?? this.addressLines,
        area: area ?? this.area,
        blockNumber: blockNumber ?? this.blockNumber,
        building: building ?? this.building,
        email: email ?? this.email,
        roadNumber: roadNumber ?? this.roadNumber,
        country: countryName ?? this.country,
        countryName: countryName ?? this.countryName,
        city: city ?? this.city,
        mobileNumber: mobileNumber ?? this.mobileNumber,
        phone: phone ?? this.phone,
        fax: fax ?? this.fax,
      );
}

/// Holds the tax data
class Tax extends Equatable {
  /// The taxing country name
  final String countryName;

  /// The taxing country code
  final String countryCode;

  /// The Taxpayer identification number (TIN)
  final String tin;

  /// Creates a new [Tax]
  const Tax({
    this.countryName = '',
    this.countryCode = '',
    this.tin = '',
  });

  @override
  List<Object> get props => [
        countryName,
        countryCode,
        tin,
      ];

  /// Returns a copy of the tax info with select different values.
  Tax copyWith({
    String? countryName,
    String? countryCode,
    String? tinAvailable,
    String? tin,
  }) =>
      Tax(
        countryName: countryName ?? this.countryName,
        countryCode: countryCode ?? this.countryCode,
        tin: tin ?? this.tin,
      );
}

/// Holds the nationality data
class Nationality extends Equatable {
  /// The country name
  final String countryName;

  /// The country code
  final String countryCode;

  /// Creates a new [Nationality]
  const Nationality({
    this.countryName = '',
    this.countryCode = '',
  });

  @override
  List<Object> get props => [
        countryName,
        countryCode,
      ];

  /// Returns a copy of the nationality with select different values.
  Nationality copyWith({
    String? countryName,
    String? countryCode,
  }) =>
      Nationality(
        countryName: countryName ?? this.countryName,
        countryCode: countryCode ?? this.countryCode,
      );
}
