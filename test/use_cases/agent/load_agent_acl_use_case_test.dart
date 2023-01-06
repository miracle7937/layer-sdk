import 'package:flutter_test/flutter_test.dart';
import 'package:layer_sdk/domain_layer/abstract_repositories.dart';
import 'package:layer_sdk/domain_layer/models.dart';
import 'package:layer_sdk/domain_layer/use_cases.dart';
import 'package:mocktail/mocktail.dart';

class MockACLRepository extends Mock implements ACLRepositoryInterface {}

late MockACLRepository _repository;
late LoadAgentACLUseCase _useCase;
late List<AgentACL> _acls;

void main() {
  setUp(() {
    _repository = MockACLRepository();
    _useCase = LoadAgentACLUseCase(repository: _repository);

    _acls = List.generate(
      5,
      (index) => AgentACL(accountId: index.toString()),
    );

    when(
      () => _useCase(
        userId: any(named: 'userId'),
        status: any(named: 'status'),
        username: any(named: 'username'),
      ),
    ).thenAnswer(
      (_) async => _acls,
    );
  });

  test('Should return correct ACLs list', () async {
    final result = await _useCase(
      username: 'something',
      status: 'somethingElse',
      userId: 'somethingTotallyDifferent',
    );

    expect(result, _acls);

    verify(
      () => _useCase(
        userId: any(named: 'userId'),
        status: any(named: 'status'),
        username: any(named: 'username'),
      ),
    ).called(1);
  });
}
