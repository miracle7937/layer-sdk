import 'dart:collection';

import 'package:equatable/equatable.dart';

///Enum that holds the possible errors for the location retrieving
enum GeofencingError {
  /// No error occurred
  none,

  /// Generic error
  generic,
}

///A state representing the geofence monitoring for the device
class GeofencingState extends Equatable {
  /// The current geofence ids being monitored
  final UnmodifiableListView<String> geofences;

  /// The [GeofencingError]
  final GeofencingError error;

  ///Creates a new [GeofencingState]
  GeofencingState({
    Iterable<String> geofences = const [],
    this.error = GeofencingError.none,
  }) : geofences = UnmodifiableListView(geofences);

  /// Creates a new instance of [GeofencingState] based on the current instance
  GeofencingState copyWith({
    Iterable<String>? geofences,
    GeofencingError? error,
  }) {
    return GeofencingState(
      geofences: geofences ?? this.geofences,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [
        geofences,
        error,
      ];
}
