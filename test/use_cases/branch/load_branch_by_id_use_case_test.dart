import 'package:equatable/equatable.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:layer_sdk/layer_sdk.dart';
import 'package:mocktail/mocktail.dart';

class MockBranchRepository extends Mock implements BranchRepositoryInterface {}

void main() {
  EquatableConfig.stringify = true;

  late MockBranchRepository _repository;
  late LoadBranchByIdUseCase _loadBranchByIdUseCase;

  final _mockedBranch = Branch();

  setUp(() {
    _repository = MockBranchRepository();
    _loadBranchByIdUseCase = LoadBranchByIdUseCase(
      repository: _repository,
    );

    when(() => _loadBranchByIdUseCase('branchId')).thenAnswer(
      (_) async => _mockedBranch,
    );
  });

  test('Should return a Branch', () async {
    final response = await _loadBranchByIdUseCase('branchId');

    expect(response, _mockedBranch);

    verify(() => _repository.getBranchById('branchId'));

    verifyNoMoreInteractions(_repository);
  });
}
