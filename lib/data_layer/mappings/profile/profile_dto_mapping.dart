import 'package:collection/collection.dart';

import '../../../domain_layer/models.dart';
import '../../dtos.dart';
import '../../mappings.dart';

/// Extension that provides mappings for [ProfileDTO]
extension ProfileDTOMapping on ProfileDTO {
  /// Maps into a [Profile]
  Profile toProfile() => Profile(
        customerID: customerID ?? '',
        address1: address1 ?? '',
        address2: address2 ?? '',
        address3: address3 ?? '',
        address4: address4 ?? '',
        cbsCreated: cbsCreated,
        corporateName: corporateName ?? '',
        country: country ?? '',
        customerType: customerType?.toCustomerType(),
        dateOfBirth: dateOfBirth,
        accountCreationDate: accountCreationDate,
        nationalIdNumber: nationalIdNumber ?? '',
        email: email ?? '',
        employeeID: employeeID ?? '',
        employerName: employerName ?? '',
        firstName: firstName ?? '',
        lastName: lastName ?? '',
        gender: gender ?? '',
        idNumber: idNumber ?? '',
        idType: idType ?? '',
        income: income ?? 0.0,
        incomeCurrency: incomeCurrency ?? '',
        language: language ?? '',
        managingBranch: managingBranch ?? '',
        mobileNumber: mobileNumber ?? '',
        nationalities: nationalities?.split(';').whereNotNull(),
        role: role ?? '',
        staff: staff,
      );
}
