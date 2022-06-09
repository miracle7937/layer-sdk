import 'package:equatable/equatable.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:layer_sdk/layer_sdk.dart';
import 'package:mocktail/mocktail.dart';

class MockBranchRepository extends Mock implements BranchRepositoryInterface {}

void main() {
  EquatableConfig.stringify = true;

  late MockBranchRepository _repository;
  late LoadBranchesUseCase _loadBranchesUseCase;

  final _mockedBranches = List.generate(
    3,
    (index) => Branch(),
  );

  setUp(() {
    _repository = MockBranchRepository();
    _loadBranchesUseCase = LoadBranchesUseCase(
      repository: _repository,
    );

    when(() => _loadBranchesUseCase()).thenAnswer(
      (_) async => _mockedBranches,
    );

    when(() => _loadBranchesUseCase(searchQuery: 'searchQuery')).thenAnswer(
      (_) async => _mockedBranches.take(1).toList(),
    );
  });

  test('Should return a list of Roles', () async {
    final response = await _loadBranchesUseCase();

    expect(response, _mockedBranches);

    verify(() => _repository.list());

    verifyNoMoreInteractions(_repository);
  });

  test('Should return a filtered list of Roles by searchQuery param', () async {
    final response = await _loadBranchesUseCase(searchQuery: 'searchQuery');

    expect(response, _mockedBranches.take(1).toList());

    verify(() => _repository.list(searchQuery: 'searchQuery'));

    verifyNoMoreInteractions(_repository);
  });
}
