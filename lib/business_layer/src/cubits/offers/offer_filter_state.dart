import 'dart:collection';

import 'package:equatable/equatable.dart';

/// Keeps the filter details for the offers
class OfferFilterState extends Equatable {
  /// The categories for filtering the offers
  final UnmodifiableListView<int> categories;

  /// The start date for filtering the offers
  final DateTime? from;

  /// The end date for filtering the offers
  final DateTime? to;

  ///Creates a new [OfferFilterData]
  OfferFilterState({
    Iterable<int> categories = const <int>[],
    this.from,
    this.to,
  }) : categories = UnmodifiableListView<int>(categories);

  /// Gets the total of filters types applied
  int get appliedCount =>
      (categories.isNotEmpty ? 1 : 0) + (from != null || to != null ? 1 : 0);

  ///Copies this offer filter with different values
  OfferFilterState copyWith({
    Iterable<int>? categories,
    DateTime? from,
    DateTime? to,
  }) =>
      OfferFilterState(
        categories: categories ?? this.categories,
        from: from ?? this.from,
        to: to ?? this.to,
      );

  @override
  List<Object?> get props => [
        categories,
        from,
        to,
      ];
}
