import 'package:bloc/bloc.dart';

import '../../../../../../data_layer/network.dart';
import '../../../data_layer/data_layer.dart';
import '../../business_layer.dart';

///A cubit that holds the categories data
class CategoryCubit extends Cubit<CategoryState> {
  ///The repository
  final CategoryRepository repository;

  ///Crates a new [CategoryCubit] providing an [CategoryState]
  CategoryCubit({
    required this.repository,
  }) : super(CategoryState());

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
      final categories = await repository.list(
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
