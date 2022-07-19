import 'package:design_kit_layer/design_kit_layer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain_layer/models.dart';
import '../../cubits.dart';
import 'branding_listener.dart';

/// A widget that loads the theme settings to set the branding, and wraps on
/// a [BrandingListener] to provide a [LayerDesign] to the tree.
class BrandingLoader extends StatelessWidget {
  /// The required child for this widget.
  final Widget child;

  /// The default colors and fonts to be used when they are missing in the
  /// branding.
  final LayerDesign defaultDesign;

  /// Creates a [BrandingLoader] widget with the given child.
  const BrandingLoader({
    Key? key,
    required this.child,
    required this.defaultDesign,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final brightnessSetting =
        context.select<StorageCubit, SettingThemeBrightness>(
      (cubit) => cubit.state.applicationSettings.brightness,
    );

    final systemBrightness = MediaQuery.platformBrightnessOf(context);

    return BrandingListener(
      child: child,
      brightness: brightnessSetting == SettingThemeBrightness.auto
          ? systemBrightness
          : brightnessSetting == SettingThemeBrightness.dark
              ? Brightness.dark
              : Brightness.light,
      defaultDesign: defaultDesign,
    );
  }
}
