import 'package:bloc_test/bloc_test.dart';
import 'package:equatable/equatable.dart';
import 'package:layer_sdk/domain_layer/models.dart';
import 'package:layer_sdk/domain_layer/use_cases.dart';
import 'package:layer_sdk/presentation_layer/cubits.dart';
import 'package:layer_sdk/presentation_layer/utils.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/expect.dart';
import 'package:test/scaffolding.dart';

class LoadProductsUseCaseMock extends Mock implements LoadProductsUseCase {}

void main() {
  EquatableConfig.stringify = true;

  late ProductCubit _cubit;
  late LoadProductsUseCase _loadProductsUseCase;

  final _mockedProducts = List.generate(
    3,
    (index) => Product(id: '$index', name: 'foo'),
  );

  setUp(() {
    _loadProductsUseCase = LoadProductsUseCaseMock();
    _cubit = ProductCubit(loadProductsUseCase: _loadProductsUseCase);

    when(
      () => _loadProductsUseCase(forceRefresh: false, limit: 20, offset: 0),
    ).thenAnswer((_) async => _mockedProducts);

    when(
      () => _loadProductsUseCase(forceRefresh: true, limit: 20, offset: 0),
    ).thenThrow(
      Exception('Some error'),
    );
  });

  blocTest<ProductCubit, ProductState>(
    'Starts with empty state',
    build: () => _cubit,
    verify: (c) => expect(
      c.state,
      ProductState(
        products: [],
        busy: true,
        error: ProductStateError.none,
        errorMessage: '',
        pagination: Pagination(limit: 20),
      ),
    ),
  );

  blocTest<ProductCubit, ProductState>(
    'Load method returns a list of products',
    build: () => _cubit,
    act: (c) => c.load(),
    expect: () => [
      ProductState(
        busy: true,
        error: ProductStateError.none,
        errorMessage: '',
        pagination: Pagination(limit: 20),
      ),
      ProductState(
        products: _mockedProducts,
        busy: false,
        error: ProductStateError.none,
        pagination:
            Pagination(limit: 20).paginate(loadMore: false).refreshCanLoadMore(
                  loadedCount: _mockedProducts.length,
                ),
      ),
    ],
    verify: (c) {
      verify(
        () => _loadProductsUseCase(forceRefresh: false, limit: 20, offset: 0),
      ).called(1);
    },
  );

  blocTest<ProductCubit, ProductState>(
    'Returns a generic error',
    build: () => _cubit,
    act: (c) => c.load(forceRefresh: true),
    expect: () => [
      ProductState(
        busy: true,
        error: ProductStateError.none,
        errorMessage: '',
        pagination: Pagination(limit: 20),
      ),
      ProductState(
        busy: false,
        error: ProductStateError.generic,
        pagination: Pagination(limit: 20),
      ),
    ],
    verify: (c) {
      verify(
        () => _loadProductsUseCase(forceRefresh: true, limit: 20, offset: 0),
      ).called(1);
    },
  );
}
