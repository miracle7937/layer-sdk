import 'package:bloc_test/bloc_test.dart';
import 'package:equatable/equatable.dart';
import 'package:layer_sdk/business_layer/business_layer.dart';
import 'package:layer_sdk/data_layer/data_layer.dart';
import 'package:layer_sdk/migration/data_layer/network.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockDPARepository extends Mock implements DPARepository {}

final _repositoryList = <DPAProcessDefinition>[];

late MockDPARepository _repository;

void main() {
  EquatableConfig.stringify = true;

  for (var i = 0; i < 23; ++i) {
    _repositoryList.add(
      DPAProcessDefinition(
        id: '$i',
        name: 'Process $i',
        key: 'process_$i',
        description: 'Description $i',
        suspended: false,
        version: i,
        deploymentId: 'deploy_$i',
        section: DPAProcessDefinitionSection.request,
      ),
    );
  }

  setUpAll(() {
    _repository = MockDPARepository();

    when(
      () => _repository.listProcessDefinitions(),
    ).thenAnswer(
      (_) async => _repositoryList.toList(),
    );
  });

  blocTest<DPAProcessDefinitionsCubit, DPAProcessDefinitionsState>(
    'starts on empty state',
    build: () => DPAProcessDefinitionsCubit(repository: _repository),
    verify: (c) => expect(c.state, DPAProcessDefinitionsState()),
  ); // starts on empty state

  blocTest<DPAProcessDefinitionsCubit, DPAProcessDefinitionsState>(
    'should load processes',
    build: () => DPAProcessDefinitionsCubit(repository: _repository),
    act: (c) => c.load(),
    expect: () => [
      DPAProcessDefinitionsState(busy: true),
      DPAProcessDefinitionsState(
        definitions: _repositoryList,
      ),
    ],
    verify: (c) {
      verify(() => _repository.listProcessDefinitions(
            onlyLatestVersions: true,
            filterSuspended: true,
            forceRefresh: false,
          )).called(1);
    },
  ); // should load tasks

  group('Error handling', () {
    setUp(() {
      when(
        () => _repository.listProcessDefinitions(),
      ).thenThrow(
        NetException(message: 'Error'),
      );
    });

    blocTest<DPAProcessDefinitionsCubit, DPAProcessDefinitionsState>(
      'should deal with simple exceptions',
      build: () => DPAProcessDefinitionsCubit(repository: _repository),
      act: (c) => c.load(),
      expect: () => [
        DPAProcessDefinitionsState(busy: true),
        DPAProcessDefinitionsState(
          errorStatus: DPAProcessDefinitionsErrorStatus.network,
        ),
      ],
      verify: (c) {
        verify(() => _repository.listProcessDefinitions()).called(1);
      },
    ); // should deal with simple exceptions
  });
}
