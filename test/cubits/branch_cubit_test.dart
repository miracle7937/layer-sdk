import 'package:bloc_test/bloc_test.dart';
import 'package:layer_sdk/business_layer/business_layer.dart';
import 'package:layer_sdk/data_layer/data_layer.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockBranchRepository extends Mock implements BranchRepository {}

late MockBranchRepository _repo;

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
      _repo = MockBranchRepository();

      when(
        () => _repo.list(),
      ).thenAnswer(
        (_) async => mockBranches,
      );
    },
  );

  blocTest<BranchCubit, BranchState>(
    'Starts with empty state',
    build: () => BranchCubit(
      repository: _repo,
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
      repository: _repo,
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
        () => _repo.list(forceRefresh: false),
      ).called(1);
    },
  );

  group('Exception tests', _exceptionTest);
}

void _exceptionTest() {
  setUp(() {
    when(
      () => _repo.list(),
    ).thenAnswer(
      (_) async => throw Exception('Some Error'),
    );
  });

  blocTest<BranchCubit, BranchState>(
    'Handles exceptions gracefully',
    build: () => BranchCubit(
      repository: _repo,
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
        () => _repo.list(forceRefresh: false),
      ).called(1);
    },
  );
}
