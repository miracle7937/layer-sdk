import '../../models.dart';

/// An abstract repository for the corporate registration
abstract class CorporateRegistrationRepositoryInterface {
  /// Registers the corporate customer with required [customerId], [name]
  /// and [managingBranch]. Other parameters are optional.
  Future<List<QueueRequest>> registerCorporate({
    required String customerId,
    required String name,
    required String managingBranch,
    DateTime? accountCreationDate,
    String? customerType,
    String? country,
    DateTime? dob,
    String? mobileNumber,
    String? email,
    String? address1,
    String? address2,
    String? nationalIdNumber,
  });

  /// Register user with the data of passed [user].
  /// Is used to register new corporate agent.
  ///
  /// Used only by the DBO app.
  Future<QueueRequest> registerAgent({
    required User user,
    bool isEditing,
  });
}
