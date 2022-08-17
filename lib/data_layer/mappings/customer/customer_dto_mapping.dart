import 'package:collection/collection.dart';

import '../../../domain_layer/models.dart';
import '../../dtos.dart';
import '../../errors.dart';

/// Extension that provides mappings for [CustomerDTO].
extension CustomerDTOMapping on CustomerDTO {
  /// Maps into a [Customer].
  Customer toCustomer(DPAMappingCustomData customData) => Customer(
        id: id ?? '',
        status: status?.toCustomerStatus() ?? CustomerStatus.unknown,
        type: type?.toCustomerType() ?? CustomerType.unknown,
        personalData: PersonalCustomerData(
          title: title ?? '',
          isResident: customerInformation?.isResident == "Y",
          passport: toPassport(),
          dateOfBirth: dob,
          placeOfBirth: placeOfBirth ?? '',
          employment: toEmploymentDetails(),
          kyc: toKYC(),
          iqama: toIqama(),
          maritalStatus: maritalStatus?.toCustomerMaritalStatus() ??
              CustomerMaritalStatus.unknown,
          motherName: motherName ?? '',
          nextOfKin: toNextOfKin(),
          thirdParty: customerInformation?.thirdParty ?? '',
          ultimateBeneficiary: _valid(customerInformation?.ultimateBeneficiary),
          taxes: customerInformation?.taxes?.map((e) => e.toTax()),
          otherNationalities: customerInformation?.otherNationalities?.map(
            (e) => e.toNationality(),
          ),
          beneficiaryDocument: toBeneficiaryDocument(customData),
          otherParty: toOtherPartyDocument(customData),
          company: CustomerCompany(
            name: customerInformation?.companyName ?? '',
            type: customerInformation?.companyType ?? '',
          ),
          billerId: customerInformation?.billerId,
        ),
        corporateData: CorporateCustomerData(
          kyc: toKYC(),
          company: CustomerCompany(
            name: customerInformation?.companyName ?? '',
            type: customerInformation?.companyType ?? '',
          ),
        ),
        firstName: firstName ?? '',
        middleName: middleName ?? '',
        lastName: lastName ?? '',
        nationalities: nationality?.split(';').whereNotNull(),
        created: created,
        eStatement: eStatement ?? false,
        isStaff: staff ?? false,
        branchName: branchName ?? '',
        managingBranch: managingBranch ?? '',
        governmentPosition: _valid(customerInformation?.governmentPosition),
        otherNames: customerInformation?.otherNames?.where(
              (name) => name.isValid,
            ) ??
            <String>[],
        vaultDisclaimer: false, // TODO: get data from the backend
        fatcaStatus: customerInformation?.fatcaStatus ?? false,
        addresses: toAddresses(),
        cpr: toCPR(),
      );

  /// Returns the text only if the text is valid.
  String _valid(String? text) => (text?.isValid ?? false ? text : null) ?? '';

  /// Returns the list of customer addresses
  Iterable<Address> toAddresses() {
    final list = <Address>[];

    if (address1 != null || address2 != null || address3 != null) {
      list.add(
        Address(
          addressLines: [address1, address2, address3].whereNotNull(),
          email: email ?? '',
          mobileNumber: mobileNumber ?? '',
          countryName: countryName ?? '',
          fax: faxNumber ?? '',
          country: country ?? '',
          phone: phoneNumber ?? '',
          city: city ?? '',
        ),
      );
    }

    for (final element in customerInformation?.addresses ?? <AddressDTO>[]) {
      list.add(
        Address(
          addressLines: [element.address1].whereNotNull(),
          area: element.area ?? '',
          blockNumber: element.blockNumber ?? '',
          building: element.building ?? '',
          email: element.email ?? email ?? '',
          mobileNumber: element.mobileNumber ?? mobileNumber ?? '',
          phone: phoneNumber ?? '',
          fax: faxNumber ?? '',
          roadNumber: element.roadNumber ?? '',
          country: country ?? '',
          countryName: countryName ?? '',
          city: city ?? '',
        ),
      );
    }

    return list;
  }

  /// Maps into a [Passport].
  Passport toPassport() => Passport(
        number: customerInformation?.passportNumber ?? '',
        issuanceDate: customerInformation?.passportIssueDate,
        expirationDate: customerInformation?.passportExpiryDate,
        issuanceCountry: customerInformation?.passportCountryIssuance ?? '',
        issuanceCountryDescription:
            customerInformation?.passportCountryIssuanceDescription ?? '',
      );

  /// Maps into a [EmploymentDetails].
  EmploymentDetails toEmploymentDetails() => EmploymentDetails(
        type: profession?.toEmploymentType() ?? EmploymentType.unknown,
        occupation: customerInformation?.occupation ?? '',
        employerName: customerInformation?.employerName ?? '',
        employerAddress: customerInformation?.employerAddress ?? '',
        incomeRange: customerInformation?.salary ?? (income ?? 0.0).toString(),
        incomeSource: incomeSource ?? '',
        fundsSource: customerInformation?.sourceOfFunds ?? '',
        businessDealings: customerInformation?.businessDealings ?? '',
      );

  /// Maps into a [Iqama].
  Iqama toIqama() => Iqama(
        number: iqamaNumber ?? '',
        expiry: iqamaExpiry,
      );

  /// Maps into a [CPR].
  CPR toCPR() => CPR(
        number: idNumber ?? '',
        expiry: idExpiry,
      );

  /// Maps into a [NextOfKin].
  NextOfKin toNextOfKin() => NextOfKin(
        name: customerInformation?.nextKinName ?? '',
        relationship: '', // TODO: get data from the backend
        mobile: customerInformation?.nextKinMobile ?? '',
      );

  /// Maps into a [KYC].
  KYC toKYC() {
    final kycList = [
      if (kycExpiryDate != null)
        KYC(
          expirationDate: kycExpiryDate,
          gracePeriod: kycExpiryGracePeriod ?? 0,
        ),
      if (idExpiry != null)
        KYC(
          expirationDate: idExpiry,
          gracePeriod: idExpiryGracePeriod ?? 0,
        ),
      if (customerInformation?.passportExpiryDate != null)
        KYC(
          expirationDate: customerInformation?.passportExpiryDate,
          gracePeriod: customerInformation?.passportExpiryGracePeriod ?? 0,
        ),
    ];

    if (kycList.isEmpty) {
      return KYC(
        status: KYCStatus.valid,
        gracePeriod: 0,
        expirationDate: null,
      );
    }

    final kyc = kycList.reduce((a, b) {
      if (a.endOfGracePeriod == b.endOfGracePeriod) {
        return a.expirationDate!.isBefore(b.expirationDate!) ? a : b;
      }

      return a.endOfGracePeriod!.isBefore(b.endOfGracePeriod!) ? a : b;
    });

    final now = DateTime.now();

    final status = kyc.expirationDate!.isAfter(now)
        ? KYCStatus.valid
        : kyc.endOfGracePeriod!.isAfter(now)
            ? KYCStatus.gracePeriod
            : KYCStatus.expired;

    return kyc.copyWith(
      status: status,
      idGracePeriod: idExpiryGracePeriod,
      kycGracePeriod: kycExpiryGracePeriod,
      passportGracePeriod: customerInformation?.passportExpiryGracePeriod,
    );
  }

  /// Formats the beneficiary document suffix to a complete URL.
  String toBeneficiaryDocument(DPAMappingCustomData customData) {
    if (customerInformation?.beneficiaryDocument?.isEmpty ?? true) {
      return '';
    }

    final document = customerInformation!.beneficiaryDocument!;
    return '${customData.fileBaseURL}/$document';
  }

  /// Formats the other party document suffix to a complete URL.
  String toOtherPartyDocument(DPAMappingCustomData customData) {
    if (customerInformation?.otherParty?.isEmpty ?? true) {
      return '';
    }

    final document = customerInformation!.otherParty!;
    return '${customData.fileBaseURL}/$document';
  }
}

/// Extension that provides customer mappings for [String].
extension CustomerStringMapping on String {
  /// Checks invalid values.
  bool get isValid => isNotEmpty && toLowerCase() != 'no';

  /// Maps into a [CustomerStatus].
  CustomerStatus toCustomerStatus() {
    switch (this) {
      case 'A':
        return CustomerStatus.active;

      case 'D':
        return CustomerStatus.disabled;

      case 'S':
        return CustomerStatus.suspended;

      case 'B':
        return CustomerStatus.blocked;

      case 'E':
        return CustomerStatus.deceased;

      default:
        return CustomerStatus.unknown;
    }
  }

  /// Maps into a [CustomerMaritalStatus].
  CustomerMaritalStatus toCustomerMaritalStatus() {
    switch (this) {
      case 'M':
        return CustomerMaritalStatus.married;

      case 'D':
        return CustomerMaritalStatus.divorced;

      case 'W':
        return CustomerMaritalStatus.widowed;

      case 'S':
        return CustomerMaritalStatus.single;

      default:
        return CustomerMaritalStatus.unknown;
    }
  }

  /// Maps into a [EmploymentType].
  EmploymentType toEmploymentType() {
    switch (trim().toUpperCase()) {
      case 'E':
        return EmploymentType.employed;

      case 'S':
        return EmploymentType.selfEmployed;

      case 'U':
        return EmploymentType.unemployed;

      case 'R':
        return EmploymentType.retired;

      case 'D':
        return EmploymentType.student;

      case 'H':
        return EmploymentType.homemaker;

      default:
        return EmploymentType.unknown;
    }
  }
}

/// Extension that provides mappings for [CustomerType].
extension CustomerTypeMapping on CustomerType {
  /// Maps into a [String].
  String toJSONString() {
    switch (this) {
      case CustomerType.personal:
        return 'P';

      case CustomerType.corporate:
        return 'C';

      case CustomerType.joint:
        return 'J';

      case CustomerType.unknown:
        return '';
    }
  }
}

Map<CustomerType, String> _customerTypeMapping = {
  CustomerType.personal: 'P',
  CustomerType.corporate: 'C',
  CustomerType.joint: 'J',
};

/// Extension that provides mappings for [CustomerType]
extension CustomerTypeDTOMapping on CustomerType {
  /// Maps into a [CustomerDTOType]
  String toCustomerDTOType() {
    final result = _customerTypeMapping[this];

    if (result != null) return result;

    throw MappingException(from: CustomerType, to: String);
  }
}

/// Extension that provides customer mappings for String
extension CustomerDTOStringMapping on String {
  /// Maps into a [CustomerType]
  CustomerType toCustomerType() {
    for (final entry in _customerTypeMapping.entries) {
      if (entry.value == this) return entry.key;
    }

    throw MappingException(from: String, to: CustomerType);
  }
}

/// Extension that provides mappings for [CustomerSort]
extension CustomerSortMapping on CustomerSort {
  /// Maps into a [String].
  String toFieldName() {
    switch (this) {
      case CustomerSort.name:
        return 'full_name';

      case CustomerSort.id:
        return 'customer_id';

      case CustomerSort.country:
        return 'country';

      case CustomerSort.registered:
        return 'ts_created';

      case CustomerSort.managingBranch:
        return 'managing_branch';
    }
  }
}

/// Extension that provides mappings for [KYCExpiredFilter]
extension CustomerKYCExpiredFilterMapping on KYCExpiredFilter {
  /// Maps into a [bool].
  bool? toBoolean() {
    switch (this) {
      case KYCExpiredFilter.valid:
        return false;

      case KYCExpiredFilter.expired:
        return true;

      case KYCExpiredFilter.all:
        return null;
    }
  }
}

/// Extension that provides mappings for [TaxDTO]
extension TaxDTOMapping on TaxDTO {
  /// Maps into a [Tax]
  Tax toTax() => Tax(
        countryName: countryName ?? '',
        countryCode: countryCode ?? '',
        tin: tin ?? '',
      );
}

/// Extension that provides mappings for [NationalityDTO]
extension NationalityDTOMapping on NationalityDTO {
  /// Maps into a [Nationality]
  Nationality toNationality() => Nationality(
        countryName: countryName ?? '',
        countryCode: countryCode ?? '',
      );
}

/// Extension that provides mappings for [KYCGracePeriodType]
extension KYCGracePeriodTypeDTOMapping on KYCGracePeriodType {
  /// Maps the enum value into the corresponding json value.
  String toJson() {
    switch (this) {
      case KYCGracePeriodType.passport:
        return 'passport_expiry_grace_period';

      case KYCGracePeriodType.id:
        return 'id_expiry_grace_period';

      case KYCGracePeriodType.kyc:
        return 'kyc_expiry_grace_period';
    }
  }
}
