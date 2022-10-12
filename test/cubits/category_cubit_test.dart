import 'package:bloc_test/bloc_test.dart';
import 'package:equatable/equatable.dart';
import 'package:layer_sdk/data_layer/network.dart';
import 'package:layer_sdk/domain_layer/models.dart';
import 'package:layer_sdk/domain_layer/use_cases.dart';
import 'package:layer_sdk/presentation_layer/cubits.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockLoadCategoryUseCase extends Mock implements LoadCategoriesUseCase {}

late MockLoadCategoryUseCase _loadCategoryUseCase;
late MockLoadCategoryUseCase _errorLoadCategoryUseCase;

final _netException = NetException(message: 'Server timed out');
final _genericException = Exception();

void main() {
  EquatableConfig.stringify = true;

  final mockedCategories = List.generate(
    7,
    (index) => Category(
      id: index,
    ),
  );

  setUp(() {
    _loadCategoryUseCase = MockLoadCategoryUseCase();
    _errorLoadCategoryUseCase = MockLoadCategoryUseCase();

    when(
      () => _loadCategoryUseCase(
        forceRefresh: false,
      ),
    ).thenAnswer(
      (_) async => mockedCategories.toList(),
    );

    when(
      () => _errorLoadCategoryUseCase(
        forceRefresh: true,
      ),
    ).thenThrow(_netException);

    when(
      () => _errorLoadCategoryUseCase(
        forceRefresh: false,
      ),
    ).thenThrow(_genericException);
  });

  blocTest<CategoryCubit, CategoryState>(
    'Starts with empty state',
    build: () => CategoryCubit(loadCategoriesUseCase: _loadCategoryUseCase),
    verify: (c) => expect(
      c.state,
      CategoryState(),
    ),
  );

  blocTest<CategoryCubit, CategoryState>(
    'Handles Exception when loading the categories',
    build: () => CategoryCubit(
      loadCategoriesUseCase: _errorLoadCategoryUseCase,
    ),
    act: (c) => c.loadCategories(forceRefresh: false),
    expect: () => [
      CategoryState(
        isBusy: true,
        error: CategoryStateError.none,
      ),
      CategoryState(
        isBusy: false,
        error: CategoryStateError.generic,
      ),
    ],
    verify: (c) {
      verify(() => _errorLoadCategoryUseCase(
            forceRefresh: false,
          )).called(1);
      verifyNoMoreInteractions(_errorLoadCategoryUseCase);
    },
  );

  blocTest<CategoryCubit, CategoryState>(
    'Handles NetException when loading the categories',
    build: () => CategoryCubit(
      loadCategoriesUseCase: _errorLoadCategoryUseCase,
    ),
    act: (c) => c.loadCategories(forceRefresh: true),
    expect: () => [
      CategoryState(
        isBusy: true,
        error: CategoryStateError.none,
      ),
      CategoryState(
        isBusy: false,
        error: CategoryStateError.network,
        errorMessage: _netException.message,
      ),
    ],
    verify: (c) {
      verify(() => _errorLoadCategoryUseCase(
            forceRefresh: true,
          )).called(1);
      verifyNoMoreInteractions(_errorLoadCategoryUseCase);
    },
  );

  blocTest<CategoryCubit, CategoryState>(
    'Check if the error is successfully cleared after a failure',
    build: () => CategoryCubit(
      loadCategoriesUseCase: _errorLoadCategoryUseCase,
    ),
    seed: () => CategoryState(
      isBusy: false,
      error: CategoryStateError.network,
      errorMessage: _netException.message,
    ),
    act: (c) => c.loadCategories(forceRefresh: true),
    expect: () => [
      CategoryState(
        isBusy: true,
        error: CategoryStateError.none,
        errorMessage: null,
      ),
      CategoryState(
        isBusy: false,
        error: CategoryStateError.network,
        errorMessage: _netException.message,
      ),
    ],
    verify: (c) {
      verify(() => _errorLoadCategoryUseCase(
            forceRefresh: true,
          )).called(1);
      verifyNoMoreInteractions(_errorLoadCategoryUseCase);
    },
  );

  blocTest<CategoryCubit, CategoryState>(
    'Retrieves the categories successfully',
    build: () => CategoryCubit(loadCategoriesUseCase: _loadCategoryUseCase),
    act: (c) => c.loadCategories(forceRefresh: false),
    expect: () => [
      CategoryState(
        isBusy: true,
        error: CategoryStateError.none,
      ),
      CategoryState(
        isBusy: false,
        categories: mockedCategories,
      ),
    ],
    verify: (c) {
      verify(() => _loadCategoryUseCase(
            forceRefresh: false,
          )).called(1);
      verifyNoMoreInteractions(_loadCategoryUseCase);
    },
  );
}
