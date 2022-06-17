import 'dart:collection';

import 'package:equatable/equatable.dart';

import '../../../../domain_layer/models.dart';

/// The available errors.
enum CategoryStateError {
  /// No errors reported.
  none,

  /// Generic error.
  generic,

  /// Network error.
  network,
}

///The state of the category cubit
class CategoryState extends Equatable {
  ///If the cubit is processing something
  final bool isBusy;

  ///The list of [Category]
  final UnmodifiableListView<Category> categories;

  /// Holds the current error
  final CategoryStateError error;

  /// Holds the error message
  final String? errorMessage;

  ///Function for checking if the all the categories are selected
  bool isAllSelected(List<int> selected) =>
      categories.where((e) => selected.contains(e.id)).length ==
      categories.length;

  ///Creates a new [CategoryState]
  CategoryState({
    this.isBusy = false,
    Iterable<Category> categories = const <Category>[],
    this.error = CategoryStateError.none,
    this.errorMessage,
  }) : categories = UnmodifiableListView(categories);

  ///Copies the object with different values
  CategoryState copyWith({
    bool? isBusy,
    Iterable<Category>? categories,
    CategoryStateError? error,
    String? errorMessage,
  }) =>
      CategoryState(
        isBusy: isBusy ?? this.isBusy,
        categories: categories ?? this.categories,
        error: error ?? this.error,
        errorMessage: error == CategoryStateError.none
            ? null
            : (errorMessage ?? this.errorMessage),
      );

  @override
  List<Object?> get props => [
        isBusy,
        categories,
        error,
        errorMessage,
      ];
}
