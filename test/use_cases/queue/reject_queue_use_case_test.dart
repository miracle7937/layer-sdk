import 'package:equatable/equatable.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:layer_sdk/domain_layer/abstract_repositories.dart';
import 'package:layer_sdk/domain_layer/use_cases.dart';
import 'package:mocktail/mocktail.dart';

class MockQueueRepository extends Mock implements QueueRepositoryInterface {}

void main() {
  EquatableConfig.stringify = true;

  late MockQueueRepository _repository;
  late RejectQueueUseCase _rejectQueueUseCase;

  final _mockedBool = true;

  setUp(() {
    _repository = MockQueueRepository();
    _rejectQueueUseCase = RejectQueueUseCase(repository: _repository);

    when(
      () => _rejectQueueUseCase(
        '1',
        isRequest: any(
          named: 'isRequest',
        ),
      ),
    ).thenAnswer(
      (_) async => _mockedBool,
    );
  });

  test('Should return a true value', () async {
    final response = await _rejectQueueUseCase('1', isRequest: true);

    expect(response, _mockedBool);

    verify(
      () => _repository.reject(
        '1',
        isRequest: any(
          named: 'isRequest',
        ),
      ),
    );

    verifyNoMoreInteractions(_repository);
  });
}
