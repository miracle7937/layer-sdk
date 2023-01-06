/// Data transfer object representing the data
/// needed for corporate registration.
class CorporateRegistrationDTO {
  /// The customer id.
  ///
  /// It is needed when the registration endpoint is called to finalize
  /// the registration after calling the authentication endpoint.
  String? customerId;

  /// The account creation date
  DateTime? accountCreationDate;

  /// The customer name
  String? name;

  /// The customer type
  String? customerType;

  /// The managing branch
  String? managingBranch;

  /// The country
  String? country;

  /// The date of birth
  DateTime? dob;

  /// The mobile number
  String? mobileNumber;

  /// The email
  String? email;

  /// The first part address
  String? address1;

  /// The second part of address
  String? address2;

  /// The nationality id number
  String? nationalIdNumber;

  /// Creates [CorporateRegistrationDTO].
  CorporateRegistrationDTO({
    this.customerId,
    this.accountCreationDate,
    this.name,
    this.customerType,
    this.managingBranch,
    this.country,
    this.dob,
    this.mobileNumber,
    this.email,
    this.address1,
    this.address2,
    this.nationalIdNumber,
  });

  /// Returns a json map.
  Map<String, dynamic> toJson() {
    return {
      if (customerId != null) 'customer_id': customerId,
      if (accountCreationDate != null)
        'account_creation_date': accountCreationDate?.toIso8601String(),
      if (name != null) 'name': name,
      if (customerType != null) 'customer_type': customerType,
      if (managingBranch != null) 'managing_branch': managingBranch,
      if (country != null) 'country': country,
      if (dob != null) 'dob': dob?.toIso8601String(),
      if (mobileNumber != null) 'mobile_number': mobileNumber,
      if (email != null) 'email': email,
      if (address1 != null) 'address1': address1,
      if (address2 != null) 'address2': address2,
      if (nationalIdNumber != null) 'national_id_number': nationalIdNumber,
    };
  }
}
