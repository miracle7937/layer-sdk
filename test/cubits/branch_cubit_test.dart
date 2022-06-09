import 'package:bloc_test/bloc_test.dart';
import 'package:layer_sdk/domain_layer/models.dart';
import 'package:layer_sdk/domain_layer/use_cases.dart';
import 'package:layer_sdk/presentation_layer/cubits.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockLoadBranchesUseCase extends Mock implements LoadBranchesUseCase {}

late MockLoadBranchesUseCase _mockLoadBranchesUseCase;

void main() {
  final mockBranches = List.generate(
    20,
    (index) => Branch(
      id: '$index',
      location: BranchLocation(
        name: 'Name $index',
      ),
    ),
  );

  setUpAll(
    () {
      _mockLoadBranchesUseCase = MockLoadBranchesUseCase();

      when(
        () => _mockLoadBranchesUseCase(),
      ).thenAnswer(
        (_) async => mockBranches,
      );
    },
  );

  blocTest<BranchCubit, BranchState>(
    'Starts with empty state',
    build: () => BranchCubit(
      loadBranchesUseCase: _mockLoadBranchesUseCase,
    ),
    verify: (c) {
      expect(
        c.state,
        BranchState(),
      );
    },
  );

  blocTest<BranchCubit, BranchState>(
    'Loads branches',
    build: () => BranchCubit(
      loadBranchesUseCase: _mockLoadBranchesUseCase,
    ),
    act: (c) => c.load(),
    expect: () => [
      BranchState(
        actions: {BranchBusyAction.load},
      ),
      BranchState(
        branches: mockBranches,
        error: BranchStateError.none,
        actions: {},
      )
    ],
    verify: (c) {
      verify(
        () => _mockLoadBranchesUseCase(forceRefresh: false),
      ).called(1);
    },
  );

  group('Exception tests', _exceptionTest);
}

void _exceptionTest() {
  setUp(() {
    when(
      () => _mockLoadBranchesUseCase(),
    ).thenAnswer(
      (_) async => throw Exception('Some Error'),
    );
  });

  blocTest<BranchCubit, BranchState>(
    'Handles exceptions gracefully',
    build: () => BranchCubit(
      loadBranchesUseCase: _mockLoadBranchesUseCase,
    ),
    act: (c) => c.load(),
    expect: () => [
      BranchState(
        actions: {BranchBusyAction.load},
      ),
      BranchState(
        error: BranchStateError.generic,
        actions: {},
      )
    ],
    errors: () => [
      isA<Exception>(),
    ],
    verify: (c) {
      verify(
        () => _mockLoadBranchesUseCase(forceRefresh: false),
      ).called(1);
    },
  );
}
