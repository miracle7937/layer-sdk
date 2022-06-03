// ignore_for_file: prefer_mixin

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geofencing/geofencing.dart';
import '../../../../business_layer/business_layer.dart';

import '../../cubits.dart';
import '../../mixins.dart';

/// Widget that gets notified when a user presses on a geofence
/// notification
class GeofencingNotification extends StatefulWidget {
  /// Whether the geofencing notification is enabled or not
  final bool enabled;

  /// The distance, in meters, that the geofences will trigger if you
  /// get nearby
  final int triggeringDistance;

  /// The timer, in hours, that the geofences will trigger if it
  /// was previously triggered
  final int notificationTimer;

  /// [ValueSetter] for when a geofence notification is pressed
  /// and the app is in background or foreground
  final ValueSetter<String> onGeofence;

  /// [ValueSetter] for when the app gets launched from a geofence
  /// notification being pressed
  final ValueSetter<String> onLaunchFromGeofence;

  /// [VoidCallback] that will be called when the geofencing
  /// setting is enabled but there are no location permissions for using
  /// the geofence monitoring.
  final VoidCallback onGeofencingFeatureDisabled;

  /// An optional future [List] of [GeofencingItem] for reseting the geofences
  /// when the app is launched
  final Future<List<GeofencingItem>?> Function()? getGeofencingItems;

  /// The child of this widget
  final Widget child;

  /// Creates a new [GeofencingNotification] widget
  const GeofencingNotification({
    this.enabled = true,
    required this.triggeringDistance,
    required this.notificationTimer,
    required this.onGeofence,
    required this.onLaunchFromGeofence,
    required this.onGeofencingFeatureDisabled,
    required this.child,
    this.getGeofencingItems,
    Key? key,
  }) : super(key: key);

  @override
  State<GeofencingNotification> createState() => _GeofencingNotificationState();
}

class _GeofencingNotificationState extends State<GeofencingNotification>
    with WidgetsBindingObserver, GeofencingMixin {
  @override
  void initState() {
    if (widget.enabled) {
      WidgetsBinding.instance.addObserver(this);

      GeofencingPlugin().configure(
        onGeofence: widget.onGeofence,
        onLaunchedFromGeofence: widget.onLaunchFromGeofence,
        triggeringDistance: widget.triggeringDistance,
        notificationTimer: widget.notificationTimer,
      );

      _runInitialGeofencingCheck();
    } else {
      _disableGeofences();
    }
    super.initState();
  }

  /// Disables the geofence feature
  void _disableGeofences() async {
    final isGeofencingSettingActive = await context
            .read<StorageCubit>()
            .preferencesStorage
            .getBool(key: GeofencingPlugin().geofencingSettingKey) ??
        false;

    if (isGeofencingSettingActive) {
      final geofencingCubit = context.read<GeofencingCubit>();
      geofencingCubit.removeAllGeofences();

      context.read<StorageCubit>().preferencesStorage.setBool(
            key: GeofencingPlugin().geofencingSettingKey,
            value: false,
          );
    }
  }

  /// Checks if the geofencing feature is active.
  ///
  /// If it's active and the app is missing the needed permissions for it
  /// to work, if not, it disables the feature and removes the geofences.
  ///
  /// Otherwise if it's active it refreshes the geofences
  void _runInitialGeofencingCheck() =>
      SchedulerBinding.instance.addPostFrameCallback((_) async {
        final isGeofencingSettingActive = await context
                .read<StorageCubit>()
                .preferencesStorage
                .getBool(key: GeofencingPlugin().geofencingSettingKey) ??
            false;

        if (isGeofencingSettingActive) {
          final locationPermissions =
              await getGeofencingLocationStatusPermission(
                  context.read<DevicePermissionsCubit>());

          if (!geofencingHasOSPermissions(locationPermissions)) {
            _disableGeofences();

            widget.onGeofencingFeatureDisabled();
          } else if (widget.getGeofencingItems != null) {
            final geofencingCubit = context.read<GeofencingCubit>();

            refreshGeofences(geofencingCubit,
                getGeofencingItems: widget.getGeofencingItems!);
          }
        }
      });

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && Platform.isIOS) {
      GeofencingPlugin().handlePendingGeofenceEvent();
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
