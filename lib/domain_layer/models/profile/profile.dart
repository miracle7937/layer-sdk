import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';

import '../../models.dart';

/// All the customer's profile data needed by the application
class Profile extends Equatable {
  /// Customer ID
  final String customerID;

  /// Address1
  final String address1;

  /// Address2
  final String address2;

  /// Address3
  final String address3;

  /// Address4
  final String address4;

  /// CBS Created
  final DateTime? cbsCreated;

  /// Corporate Name
  final String corporateName;

  /// Country
  final String country;

  /// Customer Type
  final CustomerType? customerType;

  /// Date of Birth
  final DateTime? dateOfBirth;

  /// Account Creation Date
  final DateTime? accountCreationDate;

  /// National ID Number
  final String nationalIdNumber;

  /// Email
  final String email;

  /// Employee ID
  final String employeeID;

  /// Employer Name
  final String employerName;

  /// First Name
  final String firstName;

  /// Last Name
  final String lastName;

  /// Gender
  final String gender;

  /// ID Number
  final String idNumber;

  /// ID Type
  final String idType;

  /// Income
  final double income;

  /// Income Currency
  final String incomeCurrency;

  /// Language
  final String language;

  /// Managing Branch
  final String managingBranch;

  /// Mobile Number
  final String mobileNumber;

  /// Profile nationalities.
  final UnmodifiableListView<String> nationalities;

  /// Role
  final String role;

  /// Staff
  final bool? staff;

  /// Creates a new [Profile]
  Profile({
    this.customerID = '',
    this.address1 = '',
    this.address2 = '',
    this.address3 = '',
    this.address4 = '',
    this.cbsCreated,
    this.corporateName = '',
    this.country = '',
    this.customerType,
    this.dateOfBirth,
    this.accountCreationDate,
    this.nationalIdNumber = '',
    this.email = '',
    this.employeeID = '',
    this.employerName = '',
    this.firstName = '',
    this.lastName = '',
    this.gender = '',
    this.idNumber = '',
    this.idType = '',
    this.income = 0.0,
    this.incomeCurrency = '',
    this.language = '',
    this.managingBranch = '',
    this.mobileNumber = '',
    Iterable<String>? nationalities,
    this.role = '',
    this.staff,
  }) : nationalities = UnmodifiableListView(nationalities ?? <String>[]);

  /// Returns a copy of the profile modified by the provided data.
  Profile copyWith({
    String? customerID,
    String? address1,
    String? address2,
    String? address3,
    String? address4,
    DateTime? cbsCreated,
    String? corporateName,
    String? country,
    CustomerType? customerType,
    DateTime? dateOfBirth,
    DateTime? accountCreationDate,
    String? nationalIdNumber,
    String? email,
    String? employeeID,
    String? employerName,
    String? firstName,
    String? lastName,
    String? gender,
    String? idNumber,
    String? idType,
    double? income,
    String? incomeCurrency,
    String? language,
    String? managingBranch,
    String? mobileNumber,
    Iterable<String>? nationalities,
    String? role,
    bool? staff,
  }) =>
      Profile(
        customerID: customerID ?? this.customerID,
        address1: address1 ?? this.address1,
        address2: address2 ?? this.address2,
        address3: address3 ?? this.address3,
        address4: address4 ?? this.address4,
        cbsCreated: cbsCreated ?? this.cbsCreated,
        corporateName: corporateName ?? this.corporateName,
        country: country ?? this.country,
        customerType: customerType ?? this.customerType,
        dateOfBirth: dateOfBirth ?? this.dateOfBirth,
        accountCreationDate: accountCreationDate ?? this.accountCreationDate,
        nationalIdNumber: nationalIdNumber ?? this.nationalIdNumber,
        email: email ?? this.email,
        employeeID: employeeID ?? this.employeeID,
        employerName: employerName ?? this.employerName,
        firstName: firstName ?? this.firstName,
        lastName: lastName ?? this.lastName,
        gender: gender ?? this.gender,
        idNumber: idNumber ?? this.idNumber,
        idType: idType ?? this.idType,
        income: income ?? this.income,
        incomeCurrency: incomeCurrency ?? this.incomeCurrency,
        language: language ?? this.language,
        managingBranch: managingBranch ?? this.managingBranch,
        mobileNumber: mobileNumber ?? this.mobileNumber,
        nationalities: nationalities ?? this.nationalities,
        role: role ?? this.role,
        staff: staff ?? this.staff,
      );

  @override
  List<Object?> get props => [
        customerID,
        address1,
        address2,
        address3,
        address4,
        cbsCreated,
        corporateName,
        country,
        customerType,
        dateOfBirth,
        accountCreationDate,
        nationalIdNumber,
        email,
        employeeID,
        employerName,
        firstName,
        lastName,
        gender,
        idNumber,
        idType,
        income,
        incomeCurrency,
        language,
        managingBranch,
        mobileNumber,
        nationalities,
        role,
        staff,
      ];
}
