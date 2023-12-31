import 'package:bloc/bloc.dart';

import '../../../../../data_layer/network.dart';
import '../../../domain_layer/models.dart';
import '../../../domain_layer/use_cases.dart';
import '../../extensions.dart';
import '../../utils.dart';
import 'product_state.dart';

/// Cubit that manages Product data
class ProductCubit<Equatable> extends Cubit<ProductState> {
  final LoadProductsUseCase _loadProductsUseCase;

  String? _searchQuery;

  /// Creates a new [ProductCubit]
  ProductCubit({
    required LoadProductsUseCase loadProductsUseCase,
    Iterable<Product> initialSelectedProducts = const <Product>[],
    int limit = 20,
  })  : _loadProductsUseCase = loadProductsUseCase,
        super(
          ProductState(
            selectedProducts: initialSelectedProducts,
            initiallySelectedProducts: initialSelectedProducts,
            pagination: Pagination(
              limit: limit,
            ),
          ),
        );

  /// Loads the next page of products and adds them to the list
  Future<void> loadMore({
    bool forceRefresh = false,
  }) {
    return load(
      forceRefresh: forceRefresh,
      loadMore: true,
    );
  }

  /// Loads the cubit products
  Future<void> load({
    bool loadMore = false,
    bool forceRefresh = false,
    String? searchQuery,
  }) async {
    _searchQuery = searchQuery;
    emit(
      state.copyWith(
        busy: true,
        error: ProductStateError.none,
        busyAction: loadMore
            ? ProductBusyAction.loadingMore
            : ProductBusyAction.loading,
      ),
    );

    try {
      final newPage = state.pagination.paginate(loadMore: loadMore);
      final response = await _loadProductsUseCase(
        offset: newPage.offset,
        limit: newPage.limit,
        forceRefresh: forceRefresh,
        searchQuery: _searchQuery,
      );

      Iterable<Product> products = newPage.firstPage
          ? response
          : [
              ...state.products,
              ...response,
            ];

      emit(
        state.copyWith(
          busy: false,
          errorMessage: '',
          error: ProductStateError.none,
          products: products,
          pagination: newPage.refreshCanLoadMore(
            loadedCount: response.length,
          ),
        ),
      );
    } on Exception catch (e, st) {
      logException(e, st);
      emit(
        state.copyWith(
          busy: false,
          error: e is NetException
              ? ProductStateError.network
              : ProductStateError.generic,
          errorMessage: e is NetException ? e.message : null,
        ),
      );

      rethrow;
    }
  }

  /// Add an item to the list of selected [Product]
  void addSelectedProduct(Product product) {
    emit(
      state.copyWith(
        selectedProducts: [...state.selectedProducts, product],
      ),
    );
  }

  /// Removes an item from the list of selected [Product]
  void removeSelectedProduct(Product product) {
    emit(
      state.copyWith(
        selectedProducts: state.selectedProducts.toList()
          ..removeWhere(
            (p) => p.id == product.id,
          ),
      ),
    );
  }

  /// Returns a boolean describing whether the
  /// provided product is selected or not
  bool isSelected(Product product) {
    return state.selectedProducts.indexWhere((e) => e.id == product.id) > -1;
  }
}
