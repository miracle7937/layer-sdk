import 'package:equatable/equatable.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:layer_sdk/domain_layer/abstract_repositories.dart';
import 'package:layer_sdk/domain_layer/models.dart';
import 'package:layer_sdk/domain_layer/use_cases.dart';
import 'package:mocktail/mocktail.dart';

class MockProductRepository extends Mock implements ProductRepositoryInterface {
}

void main() {
  EquatableConfig.stringify = true;

  late MockProductRepository _repository;
  late LoadProductsUseCase _loadProductUseCase;

  final _mockedProducts = List.generate(
    3,
    (index) => Product(id: '$index', name: 'foo'),
  );

  setUp(() {
    _repository = MockProductRepository();
    _loadProductUseCase = LoadProductsUseCase(repository: _repository);

    when(() => _loadProductUseCase()).thenAnswer(
      (_) async => _mockedProducts,
    );

    when(
      () => _loadProductUseCase(
        searchQuery: 'searchQuery',
      ),
    ).thenAnswer(
      (_) async => _mockedProducts.take(1).toList(),
    );

    when(
      () => _loadProductUseCase(
        productType: 'productType',
      ),
    ).thenAnswer(
      (_) async => _mockedProducts.take(1).toList(),
    );
  });

  test('Should return a list of Products', () async {
    final response = await _loadProductUseCase();

    expect(response, _mockedProducts);

    verify(() => _repository.list());

    verifyNoMoreInteractions(_repository);
  });

  test('Should return a filtered list of Products by searchQuery param',
      () async {
    final response = await _loadProductUseCase(
      searchQuery: 'searchQuery',
    );

    expect(response, _mockedProducts.take(1).toList());

    verify(() => _repository.list(searchQuery: 'searchQuery'));

    verifyNoMoreInteractions(_repository);
  });

  test('Should return a filtered list of Products by productType param',
      () async {
    final response = await _loadProductUseCase(
      productType: 'productType',
    );

    expect(response, _mockedProducts.take(1).toList());

    verify(() => _repository.list(productType: 'productType'));

    verifyNoMoreInteractions(_repository);
  });
}
