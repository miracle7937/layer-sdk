import 'package:flutter_test/flutter_test.dart';
import 'package:layer_sdk/domain_layer/abstract_repositories.dart';
import 'package:layer_sdk/domain_layer/models.dart';
import 'package:layer_sdk/domain_layer/use_cases.dart';
import 'package:mocktail/mocktail.dart';

class MockCorporateRegistrationRepository extends Mock
    implements CorporateRegistrationRepositoryInterface {}

late MockCorporateRegistrationRepository _repository;
late RegisterCorporationUseCase _useCase;
late QueueRequest _response;

late String _customerId;
late String _managingBranch;
late String _name;

void main() {
  setUp(() {
    _repository = MockCorporateRegistrationRepository();
    _useCase = RegisterCorporationUseCase(repository: _repository);

    _response = QueueRequest(
      id: 'soooomething',
    );

    _customerId = 'ayy';
    _managingBranch = 'lmao';
    _name = 'somename';

    when(
      () => _repository.registerCorporate(
        customerId: _customerId,
        managingBranch: _managingBranch,
        name: _name,
        address1: any(named: 'address1'),
        address2: any(named: 'address2'),
        customerType: any(named: 'customerType'),
        country: any(named: 'country'),
        mobileNumber: any(named: 'mobileNumber'),
        email: any(named: 'email'),
        nationalIdNumber: any(named: 'nationalIdNumber'),
      ),
    ).thenAnswer(
      (_) async => [_response],
    );
  });

  test('Should return correct response', () async {
    final result = await _useCase(
      name: _name,
      customerId: _customerId,
      managingBranch: _managingBranch,
    );

    expect(result, [_response]);

    verify(
      () => _repository.registerCorporate(
        customerId: _customerId,
        managingBranch: _managingBranch,
        name: _name,
        address1: any(named: 'address1'),
        address2: any(named: 'address2'),
        customerType: any(named: 'customerType'),
        country: any(named: 'country'),
        mobileNumber: any(named: 'mobileNumber'),
        email: any(named: 'email'),
        nationalIdNumber: any(named: 'nationalIdNumber'),
      ),
    ).called(1);
  });
}
