import 'package:equatable/equatable.dart';
import 'package:location/location.dart';

///Enum that holds the possible errors for the location retrieving
enum LocationError {
  ///No error occurred while retrieving the location
  none,

  ///The service was not enabled
  serviceDisabled,

  ///The location permission was denied
  permissionDenied,

  ///The location permission was denied forever
  permissionDeniedForever,

  /// The request has timedout
  timedOut,
}

///A state representing the last retrieved location from the device
class LocationState extends Equatable {
  ///The last returned location from the device
  final LocationData? location;

  ///Whether the cubit is retrieving the location or not
  final bool busy;

  ///The error while retrieving the location
  final LocationError error;

  ///Creates a new [LocationState]
  const LocationState({
    this.location,
    this.busy = false,
    this.error = LocationError.none,
  });

  ///Copies the state with different values
  LocationState copyWith({
    LocationData? location,
    bool? busy,
    LocationError? error,
  }) =>
      LocationState(
        location: location ?? this.location,
        busy: busy ?? this.busy,
        error: error ?? this.error,
      );

  @override
  List<Object?> get props => [
        location,
        busy,
        error,
      ];
}
