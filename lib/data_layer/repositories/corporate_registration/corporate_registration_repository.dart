import '../../../domain_layer/abstract_repositories.dart';
import '../../../domain_layer/models.dart';
import '../../dtos.dart';
import '../../mappings.dart';
import '../../providers.dart';

/// A repository that can be used to register a corporate customer.
class CorporateRegistrationRepository
    implements CorporateRegistrationRepositoryInterface {
  final CorporateRegistrationProvider _provider;

  /// Creates [CorporateRegistrationRepository].
  CorporateRegistrationRepository({
    required CorporateRegistrationProvider provider,
  }) : _provider = provider;

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
  }) async {
    final dtos = await _provider.registerCorporate(
      dto: CorporateRegistrationDTO(
        customerId: customerId,
        accountCreationDate: accountCreationDate,
        name: name,
        customerType: customerType,
        managingBranch: managingBranch,
        country: country,
        dob: dob,
        mobileNumber: mobileNumber,
        email: email,
        address1: address1,
        address2: address2,
        nationalIdNumber: nationalIdNumber,
      ),
    );

    return dtos.map((dto) => dto.toQueueRequest()).toList();
  }

  /// Register user with the data of passed [user].
  /// Is used to register new corporate agent.
  ///
  /// Used only by the DBO app.
  @override
  Future<QueueRequest> registerAgent({
    required User user,
    bool isEditing = false,
  }) async {
    final dto = await _provider.registerAgent(
      dto: user.toUserDTO(),
      isEditing: isEditing,
    );

    return dto.toQueueRequest();
  }
}
