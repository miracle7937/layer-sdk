import 'package:flutter_test/flutter_test.dart';
import 'package:layer_sdk/domain_layer/abstract_repositories.dart';
import 'package:layer_sdk/domain_layer/models.dart';
import 'package:layer_sdk/domain_layer/use_cases.dart';
import 'package:mocktail/mocktail.dart';

class MockCorporateRegistrationRepository extends Mock
    implements CorporateRegistrationRepositoryInterface {}

late MockCorporateRegistrationRepository _repository;
late RegisterCorporateAgentUseCase _useCase;
late User _mock;
late QueueRequest _response;

final customerId = '11';

void main() {
  setUp(() {
    _repository = MockCorporateRegistrationRepository();
    _useCase = RegisterCorporateAgentUseCase(repository: _repository);

    _mock = User(
      id: '',
      customerId: 'customerId',
      customerName: 'customerName',
      username: 'username',
      email: 'email',
      mobileNumber: 'mobileNumber',
      firstName: 'firstName',
      lastName: 'lastName',
    );

    _response = QueueRequest(
      id: 'soooomething',
    );

    when(
      () => _repository.registerAgent(
        user: _mock,
        isEditing: any(named: 'isEditing'),
      ),
    ).thenAnswer(
      (_) async => _response,
    );
  });

  test('Should return correct response', () async {
    final result = await _useCase(
      user: _mock,
    );

    expect(result, _response);

    verify(
      () => _repository.registerAgent(
        user: _mock,
        isEditing: false,
      ),
    ).called(1);
  });
}
