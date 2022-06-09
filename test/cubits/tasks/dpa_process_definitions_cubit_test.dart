import 'package:bloc_test/bloc_test.dart';
import 'package:equatable/equatable.dart';
import 'package:layer_sdk/data_layer/network.dart';
import 'package:layer_sdk/features/dpa.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockListProcessDefinitionsUseCase extends Mock
    implements ListProcessDefinitionsUseCase {}

final _repositoryList = <DPAProcessDefinition>[];

late MockListProcessDefinitionsUseCase _listUseCase;

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
    _listUseCase = MockListProcessDefinitionsUseCase();

    when(
      () => _listUseCase(),
    ).thenAnswer(
      (_) async => _repositoryList.toList(),
    );
  });

  blocTest<DPAProcessDefinitionsCubit, DPAProcessDefinitionsState>(
    'starts on empty state',
    build: () => DPAProcessDefinitionsCubit(
      definitionsUseCase: _listUseCase,
    ),
    verify: (c) => expect(c.state, DPAProcessDefinitionsState()),
  ); // starts on empty state

  blocTest<DPAProcessDefinitionsCubit, DPAProcessDefinitionsState>(
    'should load processes',
    build: () => DPAProcessDefinitionsCubit(
      definitionsUseCase: _listUseCase,
    ),
    act: (c) => c.load(),
    expect: () => [
      DPAProcessDefinitionsState(busy: true),
      DPAProcessDefinitionsState(
        definitions: _repositoryList,
      ),
    ],
    verify: (c) {
      verify(
        () => _listUseCase(
          onlyLatestVersions: true,
          filterSuspended: true,
          forceRefresh: false,
        ),
      ).called(1);
    },
  ); // should load tasks

  group('Error handling', () {
    setUp(() {
      when(
        () => _listUseCase(),
      ).thenThrow(
        NetException(message: 'Error'),
      );
    });

    blocTest<DPAProcessDefinitionsCubit, DPAProcessDefinitionsState>(
      'should deal with simple exceptions',
      build: () => DPAProcessDefinitionsCubit(
        definitionsUseCase: _listUseCase,
      ),
      act: (c) => c.load(),
      expect: () => [
        DPAProcessDefinitionsState(busy: true),
        DPAProcessDefinitionsState(
          errorStatus: DPAProcessDefinitionsErrorStatus.network,
        ),
      ],
      verify: (c) {
        verify(() => _listUseCase()).called(1);
      },
    ); // should deal with simple exceptions
  });
}
