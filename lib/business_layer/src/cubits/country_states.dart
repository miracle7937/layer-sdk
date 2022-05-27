import 'dart:collection';

import 'package:equatable/equatable.dart';

import '../../../data_layer/data_layer.dart';

/// The available error status
enum CountriesErrorStatus {
  /// No errors
  none,

  /// Generic error
  generic,

  /// Network error
  network,
}

/// The state of the country cubit
class CountryState extends Equatable {
  /// A list of countries
  final UnmodifiableListView<Country> countries;

  /// True if the cubit is processing something.
  final bool busy;

  /// Holds the current error
  final CountriesErrorStatus error;

  /// The error message.
  final String? errorMessage;

  /// Creates a new [CustomersState].
  CountryState({
    Iterable<Country> countries = const <Country>[],
    this.busy = false,
    this.error = CountriesErrorStatus.none,
    this.errorMessage,
  }) : countries = UnmodifiableListView(countries);

  /// Creates a new state based on this one.
  CountryState copyWith({
    Iterable<Country>? countries,
    bool? busy,
    CountriesErrorStatus? error,
    String? errorMessage,
  }) =>
      CountryState(
        countries: countries ?? this.countries,
        busy: busy ?? this.busy,
        error: error ?? this.error,
        errorMessage: error == CountriesErrorStatus.none
            ? null
            : (errorMessage ?? this.errorMessage),
      );

  @override
  List<Object?> get props => [
        countries,
        busy,
        error,
        errorMessage,
      ];
}
