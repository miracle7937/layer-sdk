import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:location/location.dart';

import '../../cubits.dart';

/// Cubit that manages the last returned location from the device
class LocationCubit extends Cubit<LocationState> {
  /// The location plugin
  final Location _location;

  /// Creates [LocationCubit].
  LocationCubit({
    required Location location,
  })  : _location = location,
        super(
          LocationState(),
        );

  /// Sets a new location for the state
  Future<void> setLocation({
    required LocationData location,
  }) async =>
      emit(
        state.copyWith(
          busy: false,
          location: location,
        ),
      );

  /// Gets the location from the device
  ///
  /// The [timeoutDuration] is used for setting the timeout limit time for
  /// the [getLocation] method from the [Location] plugin
  Future<void> getLocation({
    Duration timeoutDuration = const Duration(seconds: 5),
  }) async {
    emit(
      state.copyWith(
        error: LocationError.none,
      ),
    );

    var isEnabled = await _location.serviceEnabled();

    if (!isEnabled) {
      isEnabled = await _location.requestService();
    }

    if (!isEnabled) {
      emit(
        state.copyWith(
          error: LocationError.serviceDisabled,
        ),
      );

      return;
    }

    var status = await _location.hasPermission();

    if (status == PermissionStatus.denied) {
      status = await _location.requestPermission();
    }

    if (status == PermissionStatus.denied ||
        status == PermissionStatus.deniedForever) {
      emit(
        state.copyWith(
          error: status == PermissionStatus.denied
              ? LocationError.permissionDenied
              : LocationError.permissionDeniedForever,
        ),
      );

      return;
    }

    emit(
      state.copyWith(
        busy: true,
      ),
    );

    try {
      final location = await _location.getLocation().timeout(timeoutDuration);

      emit(
        state.copyWith(
          busy: false,
          location: location,
        ),
      );
    } on TimeoutException catch (_) {
      emit(
        state.copyWith(
          busy: false,
          error: LocationError.timedOut,
        ),
      );

      rethrow;
    }
  }
}
