import 'package:bloc_test/bloc_test.dart';
import 'package:equatable/equatable.dart';
import 'package:layer_sdk/business_layer/business_layer.dart';
import 'package:layer_sdk/data_layer/data_layer.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockCategoryRepository extends Mock implements CategoryRepository {}

late MockCategoryRepository _repo;
late MockCategoryRepository _errorHandlingRepo;

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
    _repo = MockCategoryRepository();
    _errorHandlingRepo = MockCategoryRepository();

    when(
      () => _repo.list(
        forceRefresh: false,
      ),
    ).thenAnswer(
      (_) async => mockedCategories.toList(),
    );

    when(
      () => _errorHandlingRepo.list(
        forceRefresh: true,
      ),
    ).thenThrow(_netException);

    when(
      () => _errorHandlingRepo.list(
        forceRefresh: false,
      ),
    ).thenThrow(_genericException);
  });

  blocTest<CategoryCubit, CategoryState>(
    'Starts with empty state',
    build: () => CategoryCubit(repository: _repo),
    verify: (c) => expect(
      c.state,
      CategoryState(),
    ),
  );

  blocTest<CategoryCubit, CategoryState>(
    'Handles Exception when loading the categories',
    build: () => CategoryCubit(repository: _errorHandlingRepo),
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
      verify(() => _errorHandlingRepo.list(
            forceRefresh: false,
          )).called(1);
      verifyNoMoreInteractions(_errorHandlingRepo);
    },
  );

  blocTest<CategoryCubit, CategoryState>(
    'Handles NetException when loading the categories',
    build: () => CategoryCubit(repository: _errorHandlingRepo),
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
      verify(() => _errorHandlingRepo.list(
            forceRefresh: true,
          )).called(1);
      verifyNoMoreInteractions(_errorHandlingRepo);
    },
  );

  blocTest<CategoryCubit, CategoryState>(
    'Check if the error is successfully cleared after a failure',
    build: () => CategoryCubit(repository: _errorHandlingRepo),
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
      verify(() => _errorHandlingRepo.list(
            forceRefresh: true,
          )).called(1);
      verifyNoMoreInteractions(_errorHandlingRepo);
    },
  );

  blocTest<CategoryCubit, CategoryState>(
    'Retrieves the categories successfully',
    build: () => CategoryCubit(repository: _repo),
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
      verify(() => _repo.list(
            forceRefresh: false,
          )).called(1);
      verifyNoMoreInteractions(_repo);
    },
  );
}
