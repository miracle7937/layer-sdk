import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geofencing/geofencing.dart';

import 'geofencing_state.dart';

///Cubit that manages the geofence monitoring on the device
class GeofencingCubit extends Cubit<GeofencingState> {
  /// The [GeofencingPlugin]
  final GeofencingPlugin _geofencingPlugin;

  /// Creates [GeofencingCubit].
  ///
  /// The geofencingPlugin parameter is passed for testing purposses
  GeofencingCubit({
    GeofencingPlugin? geofencingPlugin,
  })  : _geofencingPlugin = geofencingPlugin ?? GeofencingPlugin(),
        super(GeofencingState());

  /// Gets the current geofence ids
  Future<List<String>> getGeofences() async {
    final geofences = await _geofencingPlugin.getCurrentGeofences();

    emit(
      state.copyWith(
        geofences: geofences,
      ),
    );

    return geofences;
  }

  /// Add new geofences for monitoring
  Future<void> addGeofences(List<GeofencingItem> items) async {
    emit(
      state.copyWith(
        error: GeofencingError.none,
      ),
    );

    try {
      await _geofencingPlugin.addGeofences(geofences: items);
      await getGeofences();
    } on PlatformException {
      emit(
        state.copyWith(
          error: GeofencingError.generic,
        ),
      );
    }
  }

  /// Removes and stops the monitoring for the passed geofence ids
  Future<void> removeGeofences(List<String> geofenceIds) async {
    emit(
      state.copyWith(
        error: GeofencingError.none,
      ),
    );

    try {
      await _geofencingPlugin.removeGeofences(geofenceIds: geofenceIds);
      await getGeofences();
    } on PlatformException {
      emit(
        state.copyWith(
          error: GeofencingError.generic,
        ),
      );
    }
  }

  /// Removes and stops the monitoring for all the existing geofences
  Future<void> removeAllGeofences() async {
    emit(
      state.copyWith(
        error: GeofencingError.none,
      ),
    );

    try {
      await _geofencingPlugin.removeAllGeofences();
      await getGeofences();
    } on PlatformException {
      emit(
        state.copyWith(
          error: GeofencingError.generic,
        ),
      );
    }
  }
}
