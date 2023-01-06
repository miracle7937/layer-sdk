import '../../helpers.dart';

/// Holds the data of the Profile returned when creating
/// a corporation using a specific customer ID.
class ProfileDTO {
  /// Address1
  String? address1;

  /// Address2
  String? address2;

  /// Address3
  String? address3;

  /// Address4
  String? address4;

  /// CBS Created
  DateTime? cbsCreated;

  /// Corporate Name
  String? corporateName;

  /// Country
  String? country;

  /// Customer ID
  String? customerID;

  /// Customer Type
  String? customerType;

  /// Date of Birth
  DateTime? dateOfBirth;

  /// Account Creation Date
  DateTime? accountCreationDate;

  /// National ID Number
  String? nationalIdNumber;

  /// Email
  String? email;

  /// Employee ID
  String? employeeID;

  /// Employer Name
  String? employerName;

  /// First Name
  String? firstName;

  /// Last Name
  String? lastName;

  /// Gender
  String? gender;

  /// ID Number
  String? idNumber;

  /// ID Type
  String? idType;

  /// Income
  double? income;

  /// Income Currency
  String? incomeCurrency;

  /// Language
  String? language;

  /// Managing Branch
  String? managingBranch;

  /// Mobile Number
  String? mobileNumber;

  /// Nationalities
  String? nationalities;

  /// Role
  String? role;

  /// Staff
  bool? staff;

  /// Creates a new [ProfileDTO]
  ProfileDTO({
    this.address1,
    this.address2,
    this.address3,
    this.address4,
    this.cbsCreated,
    this.corporateName,
    this.country,
    this.customerID,
    this.customerType,
    this.dateOfBirth,
    this.accountCreationDate,
    this.nationalIdNumber,
    this.email,
    this.employeeID,
    this.employerName,
    this.firstName,
    this.lastName,
    this.gender,
    this.idNumber,
    this.idType,
    this.income,
    this.incomeCurrency,
    this.language,
    this.managingBranch,
    this.mobileNumber,
    this.nationalities,
    this.role,
    this.staff,
  });

  /// Creates a [Profile] from a JSON
  factory ProfileDTO.fromJson(Map<String, dynamic> json) {
    return ProfileDTO(
      address1: json['address1'],
      address2: json['address2'],
      address3: json['address3'],
      address4: json['address4'],
      cbsCreated: JsonParser.parseStringDate(json['cbs_created']),
      corporateName: json['corporate_name'],
      country: json['country'],
      customerID: json['customer_id'],
      customerType: json['customer_type'],
      dateOfBirth: JsonParser.parseStringDate(json['dob']),
      accountCreationDate:
          JsonParser.parseStringDate(json['account_creation_date']),
      nationalIdNumber: json['account_creation_date'],
      email: json['email'],
      employeeID: json['employer_id'],
      employerName: json['employer_name'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      gender: json['gender'],
      idNumber: json['id_number'],
      idType: json['id_type'],
      income: JsonParser.parseDouble(json['income']),
      incomeCurrency: json['income_currency'],
      language: json['language'],
      managingBranch: json['managing_branch'],
      mobileNumber: json['mobile_number'],
      nationalities: json['nationalities'],
      role: json['role'],
      staff: json['staff'] ?? false,
    );
  }
}
