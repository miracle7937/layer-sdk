import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geofencing/geofencing.dart';

import 'package:permission_handler/permission_handler.dart';

import '../../../../business_layer/business_layer.dart';

import '../../mixins.dart';
import '../../resources.dart';

/// Widget for managing the geofencing monitoring setting
class GeofencingSettingTile extends StatefulWidget {
  /// The height for the tile
  final double? height;

  /// The icon for the setting tile
  final Widget? icon;

  /// The [Color] for the setting switch
  final Color? switchColor;

  /// The title for the [GeofencingSettingTile]
  final String settingTitle;

  /// The [TextStyle] for the title
  final TextStyle? titleStyle;

  /// The description for the [GeofencingSettingTile]
  final String? settingDescription;

  /// The [TextStyle] for the description
  final TextStyle? descriptionStyle;

  /// A future [List] of [GeofencingItem] for when the state of the setting
  /// changes to true
  final Future<List<GeofencingItem>?> Function() getItems;

  /// A [ValueSetter] for notifying the app that the permission request has
  /// failed
  final ValueSetter<Map<Permission, PermissionStatus>> onPermissionError;

  /// Creates a new [GeofencingSettingTile] widget
  GeofencingSettingTile({
    this.height = 85.0,
    this.icon,
    this.switchColor,
    required this.settingTitle,
    this.titleStyle,
    this.settingDescription,
    this.descriptionStyle,
    required this.getItems,
    required this.onPermissionError,
    Key? key,
  }) : super(key: key);

  @override
  _GeofencingSettingTileState createState() => _GeofencingSettingTileState();
}

class _GeofencingSettingTileState extends State<GeofencingSettingTile>
    with GeofencingMixin {
  bool _initialized = false;
  bool _active = false;
  bool _loading = false;

  @override
  // ignore: type_annotate_public_apis
  didChangeDependencies() {
    if (!_initialized) {
      _initialized = true;
      context
          .read<StorageCubit>()
          .preferencesStorage
          .getBool(key: GeofencingPlugin().geofencingSettingKey)
          .then((value) => setState(() => _active = value ?? false));
    }
    super.didChangeDependencies();
  }

  /// Changes the geofencing feature status
  void _changeGeofencingStatus(
    bool status,
  ) async {
    if (_loading) {
      return;
    }

    _loading = true;

    final result = await changeGeofencingStatus(
      context,
      enabled: status,
      getGeofencingItems: widget.getItems,
      onPermissionError: widget.onPermissionError,
    );

    if (result) {
      setState(() => _active = status);
    }

    _loading = false;
  }

  @override
  Widget build(BuildContext context) {
    final theme = AppTheme.of(context).toThemeData();

    return Container(
      height: widget.height,
      child: Center(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (widget.icon != null) ...{
              widget.icon!,
              SizedBox(width: 16.0),
            },
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    widget.settingTitle,
                    style: widget.titleStyle,
                  ),
                  if (widget.settingDescription != null) ...[
                    SizedBox(height: 4.0),
                    Text(
                      widget.settingDescription!,
                      style: widget.descriptionStyle,
                    ),
                  ],
                ],
              ),
            ),
            CupertinoSwitch(
              activeColor: widget.switchColor ?? theme.primaryColor,
              value: _active,
              onChanged: _changeGeofencingStatus,
            ),
          ],
        ),
      ),
    );
  }
}
