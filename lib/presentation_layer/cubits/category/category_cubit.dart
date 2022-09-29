import 'package:bloc/bloc.dart';

import '../../../../../../data_layer/network.dart';
import '../../../domain_layer/use_cases.dart';
import 'category_state.dart';

///A cubit that holds the categories data
class CategoryCubit extends Cubit<CategoryState> {
  final LoadCategoriesUseCase _loadCategoriesUseCase;

  ///Crates a new [CategoryCubit] providing an [LoadCategoriesUseCase]
  CategoryCubit({
    required LoadCategoriesUseCase loadCategoriesUseCase,
  })  : _loadCategoriesUseCase = loadCategoriesUseCase,
        super(CategoryState());

  ///Loads all the categories
  Future<void> loadCategories({
    bool forceRefresh = true,
  }) async {
    emit(
      state.copyWith(
        isBusy: true,
        error: CategoryStateError.none,
      ),
    );

    try {
      final categories = await _loadCategoriesUseCase(
        forceRefresh: forceRefresh,
      );

      emit(
        state.copyWith(
          isBusy: false,
          categories: categories,
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          isBusy: false,
          error: e is NetException
              ? CategoryStateError.network
              : CategoryStateError.generic,
          errorMessage: e is NetException ? e.message : null,
        ),
      );

      rethrow;
    }
  }
}
