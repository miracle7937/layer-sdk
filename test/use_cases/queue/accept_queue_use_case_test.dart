import 'package:equatable/equatable.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:layer_sdk/domain_layer/abstract_repositories.dart';
import 'package:layer_sdk/domain_layer/use_cases.dart';
import 'package:mocktail/mocktail.dart';

class MockQueueRepository extends Mock implements QueueRepositoryInterface {}

void main() {
  EquatableConfig.stringify = true;

  late MockQueueRepository _repository;
  late AcceptQueueUseCase _acceptQueueUseCase;

  final _mockedBool = true;

  setUp(() {
    _repository = MockQueueRepository();
    _acceptQueueUseCase = AcceptQueueUseCase(repository: _repository);

    when(() => _acceptQueueUseCase('1', isRequest: true)).thenAnswer(
      (_) async => _mockedBool,
    );
  });

  test('Should return a true value', () async {
    final response = await _acceptQueueUseCase('1', isRequest: true);

    expect(response, _mockedBool);

    verify(() => _repository.accept('1', isRequest: true));

    verifyNoMoreInteractions(_repository);
  });
}
