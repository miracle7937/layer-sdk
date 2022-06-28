import 'dart:collection';

import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart' show immutable;

import '../../../domain_layer/models.dart';
import '../../utils.dart';

/// The available errors that might occur when fetching products.
enum ProductStateError {
  /// No errors reported.
  none,

  /// Generic error.
  generic,

  /// Network error.
  network,
}

/// Which loading action the cubit is doing
enum ProductBusyAction {
  /// if loading the first time
  loading,

  /// If is loading more data
  loadingMore,
}

/// State of the [ProductsCubit]
@immutable
class ProductState extends Equatable {
  /// State error type
  final ProductStateError error;

  /// State error message
  final String errorMessage;

  /// Holds Pagination data
  final Pagination pagination;

  /// If cubit is processing
  final bool busy;

  /// Which loading action is being done by the cubit
  final ProductBusyAction busyAction;

  /// The available products
  final UnmodifiableListView<Product> products;

  /// The selected products
  final UnmodifiableListView<Product> selectedProducts;

  /// A copy of the original selected products
  /// use for comparison purposes
  final UnmodifiableListView<Product> initiallySelectedProducts;

  /// Creates a new [ProductState]
  ProductState({
    this.error = ProductStateError.none,
    this.errorMessage = '',
    this.busy = true,
    Iterable<Product> products = const <Product>[],
    Iterable<Product> selectedProducts = const <Product>[],
    Iterable<Product> initiallySelectedProducts = const <Product>[],
    this.pagination = const Pagination(limit: 100),
    this.busyAction = ProductBusyAction.loading,
  })  : products = UnmodifiableListView(products),
        selectedProducts = UnmodifiableListView(selectedProducts),
        initiallySelectedProducts =
            UnmodifiableListView(initiallySelectedProducts);

  /// Copies the object with different values
  ProductState copyWith({
    ProductStateError? error,
    String? errorMessage,
    Pagination? pagination,
    bool? busy,
    Iterable<Product>? products,
    Iterable<Product>? selectedProducts,
    Iterable<Product>? initiallySelectedProducts,
    ProductBusyAction? busyAction,
  }) {
    return ProductState(
      error: error ?? this.error,
      errorMessage: errorMessage ?? this.errorMessage,
      pagination: pagination ?? this.pagination,
      busy: busy ?? this.busy,
      products: products ?? this.products,
      selectedProducts: selectedProducts ?? this.selectedProducts,
      initiallySelectedProducts:
          initiallySelectedProducts ?? this.initiallySelectedProducts,
      busyAction: busyAction ?? this.busyAction,
    );
  }

  /// Getter that shows if the products selected are different
  /// from the initially selected products
  bool get didSelectedProductsChanged {
    if (initiallySelectedProducts.isEmpty) {
      if (selectedProducts.isNotEmpty) {
        return true;
      }
      return false;
    }
    // [initiallySelectedProducts] is not empty at this stage
    if (initiallySelectedProducts.length != selectedProducts.length) {
      if (selectedProducts.isEmpty) {
        return false;
      }
      return true;
    }
    return initiallySelectedProducts.indexWhere((e1) {
          return selectedProducts.indexWhere((e2) => e1.id == e2.id) == -1;
        }) >
        -1;
  }

  @override
  List<Object?> get props {
    return [
      error,
      errorMessage,
      pagination,
      busy,
      products,
      selectedProducts,
      busyAction,
      initiallySelectedProducts,
    ];
  }
}
