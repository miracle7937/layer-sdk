import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geofencing/geofencing.dart';
import 'package:layer_sdk/business_layer/business_layer.dart';
import 'package:logging/logging.dart';
import 'package:permission_handler/permission_handler.dart';

import '../cubits.dart';

/// Mixin that exposes common methods for the geofencing feature
mixin GeofencingMixin {
  /// Gets the status of the location permissions needed for the
  /// geofencing feature
  Future<Map<Permission, PermissionStatus>>
      getGeofencingLocationStatusPermission(
    DevicePermissionsCubit devicePermissionsCubit,
  ) async {
    final whenInUse = await devicePermissionsCubit
        .getPermissionStatus(Permission.locationWhenInUse);

    final always = await devicePermissionsCubit
        .getPermissionStatus(Permission.locationAlways);

    return {
      Permission.locationWhenInUse: whenInUse,
      Permission.locationAlways: always,
    };
  }

  /// Requests the location permissions needed for the geofencing feature
  Future<Map<Permission, PermissionStatus>> requestGeofencingLocationPermission(
    DevicePermissionsCubit devicePermissionsCubit,
  ) async {
    final whenInUse = await Permission.locationWhenInUse.request();
    if (whenInUse != PermissionStatus.granted) {
      return {
        Permission.locationWhenInUse: whenInUse,
        Permission.locationAlways: PermissionStatus.denied,
      };
    }

    // I first request the permission and then I ask for the permission status
    // again cause on Android the [Permission.locationAlways] opens the
    // settings and the status must be requested again when that settings are
    // closed, otherwise, you will get [permissionDenied] even if the
    // permission was granted
    await Permission.locationAlways.request();
    final always = await devicePermissionsCubit
        .getPermissionStatus(Permission.locationAlways);

    return {
      Permission.locationWhenInUse: whenInUse,
      Permission.locationAlways: always,
    };
  }

  /// Determines if the [Platform] operating system has enough location
  /// permissions for enabling the geofencing feature.
  ///
  /// Since Android 10, both the [Permission.locationWhenInUse] and
  /// [Permission.locationAlways] permissions are needed for geofencing.
  /// On lower versions, the [Permission.locationAlways] will be automatically
  /// granted when you grant the [Permission.locationWhenInUse]
  ///
  /// On iOS,[Permission.locationWhenInUse] is mandatory for monitoring
  /// geofences when the app is running.
  /// [Permission.locationAlways] is optional. This will make geofence feature
  /// also work when the app is not running. So we need to make sure the user
  /// has granted [Permission.locationAlways] too.
  bool geofencingHasOSPermissions(
    Map<Permission, PermissionStatus> permissions,
  ) {
    if (Platform.isAndroid || Platform.isIOS) {
      return permissions[Permission.locationWhenInUse] ==
              PermissionStatus.granted &&
          permissions[Permission.locationAlways] == PermissionStatus.granted;
    }

    return false;
  }

  /// Changes the geofencing feature status
  Future<bool> changeGeofencingStatus(
    BuildContext context, {
    required bool enabled,
    required Future<List<GeofencingItem>?> Function() getGeofencingItems,
    ValueSetter<Map<Permission, PermissionStatus>>? onPermissionError,
  }) async {
    try {
      final geofencingCubit = context.read<GeofencingCubit>();

      if (enabled) {
        final locationPermissions = await requestGeofencingLocationPermission(
            context.read<DevicePermissionsCubit>());

        if (!geofencingHasOSPermissions(locationPermissions)) {
          if (onPermissionError != null) {
            onPermissionError(locationPermissions);
          }
          return false;
        }

        final items = await getGeofencingItems();

        if (items != null) {
          for (final item in items) {
            await geofencingCubit.addGeofences([item]);
          }
        }
      } else {
        await geofencingCubit.removeAllGeofences();
      }

      await context.read<StorageCubit>().preferencesStorage.setBool(
            key: GeofencingPlugin().geofencingSettingKey,
            value: enabled,
          );

      return true;
    } on Exception catch (e, s) {
      Logger('$e : $s');
      return false;
    }
  }

  /// Refreshes the geofences
  void refreshGeofences(
    GeofencingCubit geofencingCubit, {
    required Future<List<GeofencingItem>?> Function() getGeofencingItems,
  }) async {
    final items = await getGeofencingItems();

    if (items != null) {
      final currentGeofences = await geofencingCubit.getGeofences();
      final geofencesToRemove = currentGeofences
          .where((id) => !items.map((item) => item.id).contains(id))
          .toList();
      final geofencesToAdd =
          items.where((item) => !geofencesToRemove.contains(item.id));

      if (geofencesToRemove.isNotEmpty) {
        await geofencingCubit.removeGeofences(geofencesToRemove);
      }

      for (final item in geofencesToAdd) {
        await geofencingCubit.addGeofences([item]);
      }
    }
  }
}
