import 'package:equatable/equatable.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:layer_sdk/features/dpa.dart';
import 'package:mocktail/mocktail.dart';

class MockDPARepository extends Mock implements DPARepositoryInterface {}

late MockDPARepository _repository;
late ListProcessDefinitionsUseCase _useCase;
late List<DPAProcessDefinition> _mockedDefinitions;

void main() {
  EquatableConfig.stringify = true;

  setUp(() {
    _repository = MockDPARepository();
    _useCase = ListProcessDefinitionsUseCase(
      repository: _repository,
    );

    _mockedDefinitions = List.generate(
      5,
      (index) => DPAProcessDefinition(
        section: DPAProcessDefinitionSection.request,
        id: index.toString(),
      ),
    );

    when(
      () => _repository.listProcessDefinitions(),
    ).thenAnswer(
      (_) async => _mockedDefinitions,
    );
  });

  test('Should return correct tasks', () async {
    final response = await _useCase();

    expect(response, _mockedDefinitions);

    verify(
      () => _repository.listProcessDefinitions(),
    ).called(1);
  });
}
