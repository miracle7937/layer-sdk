import 'package:equatable/equatable.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:layer_sdk/domain_layer/abstract_repositories.dart';
import 'package:layer_sdk/domain_layer/models.dart';
import 'package:layer_sdk/domain_layer/use_cases.dart';
import 'package:mocktail/mocktail.dart';

class MockQueueRepository extends Mock implements QueueRepositoryInterface {}

void main() {
  EquatableConfig.stringify = true;

  late MockQueueRepository _repository;
  late LoadQueuesUseCase _loadQueueUseCase;

  final _mockedQueueRequests = List.generate(3, (index) => QueueRequest());

  setUp(() {
    _repository = MockQueueRepository();
    _loadQueueUseCase = LoadQueuesUseCase(repository: _repository);

    when(() => _loadQueueUseCase()).thenAnswer(
      (_) async => _mockedQueueRequests,
    );
  });

  test('Should return a List of QueueRequest', () async {
    final response = await _loadQueueUseCase();

    expect(response, _mockedQueueRequests);

    verify(() => _repository.list());

    verifyNoMoreInteractions(_repository);
  });
}
