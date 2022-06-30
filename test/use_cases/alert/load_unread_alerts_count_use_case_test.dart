import 'package:equatable/equatable.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:layer_sdk/domain_layer/abstract_repositories.dart';
import 'package:layer_sdk/domain_layer/use_cases.dart';
import 'package:mocktail/mocktail.dart';

class MockAlertRepository extends Mock implements AlertRepositoryInterface {}

void main() {
  EquatableConfig.stringify = true;

  late MockAlertRepository _repository;
  late LoadUnreadAlertsUseCase _loadUnreadAlertUseCase;

  final _mockInt = 1;

  setUp(() {
    _repository = MockAlertRepository();
    _loadUnreadAlertUseCase = LoadUnreadAlertsUseCase(repository: _repository);

    when(() => _loadUnreadAlertUseCase()).thenAnswer(
      (_) async => _mockInt,
    );
  });

  test('Should return the number of unread alerts', () async {
    final response = await _loadUnreadAlertUseCase();

    expect(response, _mockInt);

    verify(() => _repository.getUnreadAlertsCount());

    verifyNoMoreInteractions(_repository);
  });
}
