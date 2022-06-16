import 'package:equatable/equatable.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:layer_sdk/domain_layer/abstract_repositories.dart';
import 'package:layer_sdk/domain_layer/models.dart';
import 'package:layer_sdk/domain_layer/use_cases.dart';
import 'package:mocktail/mocktail.dart';

class MockConfigRepository extends Mock implements ConfigRepositoryInterface {}

void main() {
  EquatableConfig.stringify = true;

  late MockConfigRepository _repository;
  late LoadConfigUseCase _loadConfigUseCase;

  final _mockConfig = Config();

  setUp(() {
    _repository = MockConfigRepository();
    _loadConfigUseCase = LoadConfigUseCase(repository: _repository);

    when(() => _loadConfigUseCase()).thenAnswer(
      (_) async => _mockConfig,
    );
  });

  test('Should return the Config', () async {
    final response = await _loadConfigUseCase();

    expect(response, _mockConfig);

    verify(() => _repository.load());

    verifyNoMoreInteractions(_repository);
  });
}
