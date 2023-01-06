import 'package:flutter_test/flutter_test.dart';
import 'package:layer_sdk/domain_layer/abstract_repositories.dart';
import 'package:layer_sdk/domain_layer/models.dart';
import 'package:layer_sdk/domain_layer/use_cases.dart';
import 'package:mocktail/mocktail.dart';

class MockACLRepository extends Mock implements ACLRepositoryInterface {}

late MockACLRepository _repository;
late UpdateAgentCardVisibilityUseCase _useCase;
late Customer _successCorporation;
late Customer _failureCorporation;
late User _agent;

void main() {
  setUp(() {
    _repository = MockACLRepository();
    _useCase = UpdateAgentCardVisibilityUseCase(repository: _repository);

    _successCorporation = Customer(id: 'success!');
    _failureCorporation = Customer(id: 'failure!');
    _agent = User(id: 'someUser');

    when(
      () => _repository.updateAgentCardVisibility(
        cards: any(named: 'cards'),
        corporation: _successCorporation,
        agent: _agent,
      ),
    ).thenAnswer(
      (_) async => true,
    );

    when(
      () => _repository.updateAgentCardVisibility(
        cards: any(named: 'cards'),
        corporation: _failureCorporation,
        agent: _agent,
      ),
    ).thenAnswer(
      (_) async => false,
    );
  });

  test('Should return false', () async {
    final result = await _useCase(
      corporation: _failureCorporation,
      agent: _agent,
      cards: [],
    );

    expect(result, false);

    verify(
      () => _useCase(
        cards: any(named: 'cards'),
        corporation: _failureCorporation,
        agent: _agent,
      ),
    ).called(1);
  });

  test('Should return true', () async {
    final result = await _useCase(
      corporation: _successCorporation,
      agent: _agent,
      cards: [],
    );

    expect(result, true);

    verify(
      () => _useCase(
        cards: any(named: 'cards'),
        corporation: _successCorporation,
        agent: _agent,
      ),
    ).called(1);
  });
}
