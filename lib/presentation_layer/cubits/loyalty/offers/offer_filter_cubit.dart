import 'package:bloc/bloc.dart';

import '../../../cubits.dart';

/// Holds the state of the filters for the different offers cubits.
class OfferFilterCubit extends Cubit<OfferFilterState> {
  /// Creates a new [OfferFilterCubit].
  OfferFilterCubit()
      : super(
          OfferFilterState(),
        );

  /// Resets all the filters.
  void clearFilters() => emit(
        OfferFilterState(),
      );

  /// Changes the current applied filters.
  ///
  /// Pass null to the ones you want keep the current value.
  void changeFilters({
    Iterable<int>? categories,
    DateTime? from,
    DateTime? to,
  }) =>
      emit(
        state.copyWith(
          categories: categories,
          from: from,
          to: to,
        ),
      );

  /// Clears the from date from the filters.
  void clearFromDate() => emit(
        OfferFilterState(
          categories: state.categories,
          to: state.to,
        ),
      );

  /// Clears the to date from the filters.
  void clearToDate() => emit(
        OfferFilterState(
          categories: state.categories,
          from: state.from,
        ),
      );
}
