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
  late LoadProductByProductIdUseCase _loadProductByProductIdUseCase;

  final _mockedProduct = Product(id: '1', name: 'foo');

  setUp(() {
    _repository = MockProductRepository();
    _loadProductByProductIdUseCase = LoadProductByProductIdUseCase(
      repository: _repository,
    );

    when(() => _loadProductByProductIdUseCase('productId')).thenAnswer(
      (_) async => _mockedProduct,
    );
  });

  test('Should return an Product', () async {
    final response = await _loadProductByProductIdUseCase('productId');

    expect(response, _mockedProduct);

    verify(() => _repository.fetchProduct('productId'));

    verifyNoMoreInteractions(_repository);
  });
}
