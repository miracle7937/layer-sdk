import '../../abstract_repositories.dart';
import '../../models.dart';

/// Use case to register new corporate customer
class RegisterCorporationUseCase {
  final CorporateRegistrationRepositoryInterface _repository;

  /// Creates a new [RegisterCorporationUseCase] instance
  RegisterCorporationUseCase({
    required CorporateRegistrationRepositoryInterface repository,
  }) : _repository = repository;

  /// Registers the corporate customer with required [customerId], [name]
  /// and [managingBranch]. Other parameters are optional.
  Future<List<QueueRequest>> call({
    required String customerId,
    required String name,
    required String managingBranch,
    DateTime? accountCreationDate,
    String customerType = '',
    String country = '',
    DateTime? dob,
    String mobileNumber = '',
    String email = '',
    String address1 = '',
    String address2 = '',
    String nationalIdNumber = '',
  }) =>
      _repository.registerCorporate(
        customerId: customerId,
        name: name,
        managingBranch: managingBranch,
        accountCreationDate: accountCreationDate,
        customerType: customerType,
        country: country,
        dob: dob,
        mobileNumber: mobileNumber,
        email: email,
        address1: address1,
        address2: address2,
        nationalIdNumber: nationalIdNumber,
      );
}
