import 'package:bloc_test/bloc_test.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:layer_sdk/_migration/flutter_layer/flutter_layer.dart';
import 'package:layer_sdk/_migration/flutter_layer/src/cubits/location/geofencing_state.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockGeofencingPlugin extends Mock implements GeofencingPlugin {}

final _plugin = MockGeofencingPlugin();
final _addingPlugin = MockGeofencingPlugin();
final _removedAllPlugin = MockGeofencingPlugin();
final _failingRemovedAllPlugin = MockGeofencingPlugin();

final _currentGeofences = ['1'];
final _geofencesAfterAdding = ['1', '2'];
final _emptyGeofences = <String>[];

final _geofence = GeofencingItem(
  id: '2',
  title: '',
  message: '',
  latitude: 0.0,
  longitude: 0.0,
);

final _geofenceToRemove = '2';

final _failingGeofence = GeofencingItem(
  id: '3',
  title: '',
  message: '',
  latitude: 0.0,
  longitude: 0.0,
);

final _failingGeofenceToRemove = '3';

void main() {
  EquatableConfig.stringify = true;

  setUpAll(() {
    when(
      _plugin.getCurrentGeofences,
    ).thenAnswer(
      (_) async => _currentGeofences,
    );

    when(
      _addingPlugin.getCurrentGeofences,
    ).thenAnswer(
      (_) async => _geofencesAfterAdding,
    );

    when(
      () => _addingPlugin.addGeofences(
        geofences: [_geofence],
      ),
    ).thenAnswer((_) async => _geofencesAfterAdding);

    when(
      () => _addingPlugin.addGeofences(
        geofences: [_failingGeofence],
      ),
    ).thenThrow(PlatformException(code: ''));

    when(
      () => _plugin.removeGeofences(geofenceIds: [_geofenceToRemove]),
    ).thenAnswer((_) async => _currentGeofences);

    when(
      () => _plugin.removeGeofences(geofenceIds: [_failingGeofenceToRemove]),
    ).thenThrow(PlatformException(code: ''));

    when(
      _removedAllPlugin.removeAllGeofences,
    ).thenAnswer((_) async => _emptyGeofences);

    when(
      _failingRemovedAllPlugin.removeAllGeofences,
    ).thenThrow(PlatformException(code: ''));
  });

  blocTest<GeofencingCubit, GeofencingState>(
    'starts on empty state',
    build: () => GeofencingCubit(
      geofencingPlugin: _plugin,
    ),
    verify: (c) => expect(
      c.state,
      GeofencingState(),
    ),
  );

  blocTest<GeofencingCubit, GeofencingState>(
    'should emit the current geofences',
    build: () => GeofencingCubit(
      geofencingPlugin: _plugin,
    ),
    act: (c) => c.getGeofences(),
    expect: () => [
      GeofencingState(
        geofences: _currentGeofences,
        error: GeofencingError.none,
      ),
    ],
    verify: (c) {
      verify(
        _plugin.getCurrentGeofences,
      ).called(1);
    },
  );

  blocTest<GeofencingCubit, GeofencingState>(
    'should add the geofence and emit the current geofences '
    'with the added one',
    build: () => GeofencingCubit(
      geofencingPlugin: _addingPlugin,
    ),
    act: (c) => c.addGeofences([_geofence]),
    expect: () => [
      GeofencingState(
        error: GeofencingError.none,
      ),
      GeofencingState(
        geofences: _geofencesAfterAdding,
        error: GeofencingError.none,
      ),
    ],
    verify: (c) {
      verify(
        () => _addingPlugin.addGeofences(geofences: [_geofence]),
      ).called(1);

      verify(
        _addingPlugin.getCurrentGeofences,
      ).called(1);
    },
  );

  blocTest<GeofencingCubit, GeofencingState>(
    'tries to add the geofences but a platform exception happens',
    build: () => GeofencingCubit(
      geofencingPlugin: _addingPlugin,
    ),
    act: (c) => c.addGeofences([_failingGeofence]),
    expect: () => [
      GeofencingState(
        error: GeofencingError.none,
      ),
      GeofencingState(
        error: GeofencingError.generic,
      ),
    ],
    verify: (c) {
      verify(
        () => _addingPlugin.addGeofences(geofences: [_failingGeofence]),
      ).called(1);
    },
  );

  blocTest<GeofencingCubit, GeofencingState>(
    'should remove the geofence and emit the current geofences '
    'without the removed one',
    build: () => GeofencingCubit(
      geofencingPlugin: _plugin,
    ),
    act: (c) => c.removeGeofences([_geofenceToRemove]),
    expect: () => [
      GeofencingState(
        error: GeofencingError.none,
      ),
      GeofencingState(
        geofences: _currentGeofences,
        error: GeofencingError.none,
      ),
    ],
    verify: (c) {
      verify(
        () => _plugin.removeGeofences(geofenceIds: [_geofenceToRemove]),
      ).called(1);

      verify(
        _plugin.getCurrentGeofences,
      ).called(1);
    },
  );

  blocTest<GeofencingCubit, GeofencingState>(
    'tries to remove a geofence but a platform exception happens',
    build: () => GeofencingCubit(
      geofencingPlugin: _plugin,
    ),
    act: (c) => c.removeGeofences([_failingGeofenceToRemove]),
    expect: () => [
      GeofencingState(
        error: GeofencingError.none,
      ),
      GeofencingState(
        error: GeofencingError.generic,
      ),
    ],
    verify: (c) {
      verify(
        () => _plugin.removeGeofences(geofenceIds: [_failingGeofenceToRemove]),
      ).called(1);
    },
  );

  blocTest<GeofencingCubit, GeofencingState>(
    'should remove all the goefences and emit the current geofences',
    build: () => GeofencingCubit(
      geofencingPlugin: _removedAllPlugin,
    ),
    act: (c) => c.removeAllGeofences(),
    expect: () => [
      GeofencingState(
        geofences: _emptyGeofences,
        error: GeofencingError.none,
      ),
    ],
    verify: (c) {
      verify(
        _removedAllPlugin.removeAllGeofences,
      ).called(1);

      verify(
        _removedAllPlugin.getCurrentGeofences,
      ).called(1);
    },
  );

  blocTest<GeofencingCubit, GeofencingState>(
    'tries to remove all the geofences but a platform exception happens',
    build: () => GeofencingCubit(
      geofencingPlugin: _failingRemovedAllPlugin,
    ),
    act: (c) => c.removeAllGeofences(),
    expect: () => [
      GeofencingState(
        error: GeofencingError.none,
      ),
      GeofencingState(
        error: GeofencingError.generic,
      ),
    ],
    verify: (c) {
      verify(
        _failingRemovedAllPlugin.removeAllGeofences,
      ).called(1);
    },
  );
}
