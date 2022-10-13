import 'package:flutter_test/flutter_test.dart';
import 'package:layer_sdk/domain_layer/abstract_repositories.dart';
import 'package:layer_sdk/domain_layer/models.dart';
import 'package:layer_sdk/domain_layer/use_cases.dart';
import 'package:mocktail/mocktail.dart';

class MockCategoryRepository extends Mock
    implements CategoryRepositoryInterface {}

late MockCategoryRepository _repository;
late LoadCategoriesUseCase _useCase;

final _mockedCategories = List.generate(
  5,
  (index) => Category(),
);

void main() {
  setUp(() {
    _repository = MockCategoryRepository();
    _useCase = LoadCategoriesUseCase(repository: _repository);

    when(
      () => _repository.list(),
    ).thenAnswer((_) async => _mockedCategories);
  });

  test('Should return a list of categories', () async {
    final result = await _useCase();

    expect(result, _mockedCategories);

    verify(
      () => _repository.list(),
    ).called(1);
  });
}
