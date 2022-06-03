import 'package:bloc_test/bloc_test.dart';
import 'package:equatable/equatable.dart';
import 'package:layer_sdk/_migration/flutter_layer/flutter_layer.dart';
import 'package:location/location.dart' as loc;
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockLocation extends Mock implements loc.Location {}

final _location = MockLocation();
final _serviceDisabledLocation = MockLocation();
final _permissionDeniedLocation = MockLocation();
final _permissionDeniedForeverLocation = MockLocation();

final _locationData = loc.LocationData.fromMap(
  {
    'latitude': 3.18582,
    'longitude': 1.39282,
  },
);

void main() {
  EquatableConfig.stringify = true;

  setUpAll(() {
    when(
      _location.serviceEnabled,
    ).thenAnswer(
      (_) async => true,
    );

    when(
      _location.hasPermission,
    ).thenAnswer(
      (_) async => loc.PermissionStatus.granted,
    );

    when(
      _location.getLocation,
    ).thenAnswer(
      (_) async => _locationData,
    );
    //_location

    when(
      _serviceDisabledLocation.serviceEnabled,
    ).thenAnswer(
      (_) async => false,
    );

    when(
      _serviceDisabledLocation.requestService,
    ).thenAnswer(
      (_) async => false,
    );
    //_serviceDisabled

    when(
      _permissionDeniedLocation.serviceEnabled,
    ).thenAnswer(
      (_) async => true,
    );

    when(
      _permissionDeniedLocation.hasPermission,
    ).thenAnswer(
      (_) async => loc.PermissionStatus.denied,
    );

    when(
      _permissionDeniedLocation.requestPermission,
    ).thenAnswer(
      (_) async => loc.PermissionStatus.denied,
    );
    //_permissionDenied

    when(
      _permissionDeniedForeverLocation.serviceEnabled,
    ).thenAnswer(
      (_) async => true,
    );

    when(
      _permissionDeniedForeverLocation.hasPermission,
    ).thenAnswer(
      (_) async => loc.PermissionStatus.denied,
    );

    when(
      _permissionDeniedForeverLocation.requestPermission,
    ).thenAnswer(
      (_) async => loc.PermissionStatus.deniedForever,
    );
    //_permissionDeniedForever
  });

  blocTest<LocationCubit, LocationState>(
    'starts on empty state',
    build: () => LocationCubit(
      location: _location,
    ),
    verify: (c) => expect(
      c.state,
      LocationState(),
    ),
  ); // starts on empty state

  blocTest<LocationCubit, LocationState>(
    'should emit location data',
    build: () => LocationCubit(
      location: _location,
    ),
    act: (c) => c.setLocation(location: _locationData),
    expect: () => [
      LocationState(
        busy: false,
        location: _locationData,
      ),
    ],
  ); // should emit location data

  blocTest<LocationCubit, LocationState>(
    'should fetch the location',
    build: () => LocationCubit(
      location: _location,
    ),
    act: (c) => c.getLocation(),
    expect: () => [
      LocationState(
        error: LocationError.none,
      ),
      LocationState(
        busy: true,
      ),
      LocationState(
        busy: false,
        location: _locationData,
      ),
    ],
    verify: (c) {
      verify(
        _location.serviceEnabled,
      ).called(1);

      verify(
        _location.hasPermission,
      ).called(1);

      verify(
        _location.getLocation,
      ).called(1);
    },
  ); // should fetch the location

  blocTest<LocationCubit, LocationState>(
    'should emit service disabled',
    build: () => LocationCubit(
      location: _serviceDisabledLocation,
    ),
    act: (c) => c.getLocation(),
    expect: () => [
      LocationState(
        error: LocationError.none,
      ),
      LocationState(
        error: LocationError.serviceDisabled,
      ),
    ],
    verify: (c) {
      verify(
        _serviceDisabledLocation.serviceEnabled,
      ).called(1);

      verify(
        _serviceDisabledLocation.requestService,
      ).called(1);
    },
  ); // should emit service disabled

  blocTest<LocationCubit, LocationState>(
    'should emit permission denied',
    build: () => LocationCubit(
      location: _permissionDeniedLocation,
    ),
    act: (c) => c.getLocation(),
    expect: () => [
      LocationState(
        error: LocationError.none,
      ),
      LocationState(
        error: LocationError.permissionDenied,
      ),
    ],
    verify: (c) {
      verify(
        _permissionDeniedLocation.serviceEnabled,
      ).called(1);

      verify(
        _permissionDeniedLocation.hasPermission,
      ).called(1);

      verify(
        _permissionDeniedLocation.requestPermission,
      ).called(1);
    },
  ); // should emit permission denied

  blocTest<LocationCubit, LocationState>(
    'should emit permission denied forever',
    build: () => LocationCubit(
      location: _permissionDeniedForeverLocation,
    ),
    act: (c) => c.getLocation(),
    expect: () => [
      LocationState(
        error: LocationError.none,
      ),
      LocationState(
        error: LocationError.permissionDeniedForever,
      ),
    ],
    verify: (c) {
      verify(
        _permissionDeniedForeverLocation.serviceEnabled,
      ).called(1);

      verify(
        _permissionDeniedForeverLocation.hasPermission,
      ).called(1);

      verify(
        _permissionDeniedForeverLocation.requestPermission,
      ).called(1);
    },
  ); // should emit permission denied forever
}
