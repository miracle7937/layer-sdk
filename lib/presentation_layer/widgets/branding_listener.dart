import 'package:design_kit_layer/design_kit_layer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubits.dart';
import '../extensions.dart';

/// A widget that listens for branding changes and passes it down the tree
/// using a [LayerDesign].
///
/// If you need to load the settings from storage, consider using
/// [BrandingLoader] instead.
class BrandingListener extends StatelessWidget {
  /// The required child for this widget.
  final Widget child;

  /// The brightness value used to determine whether to use the dark or light
  /// set of branding colors.
  final Brightness brightness;

  /// The default colors and fonts to be used when they are missing in the
  /// branding.
  final LayerDesign defaultDesign;

  /// Creates a [BrandingListener] widget with the given child.
  const BrandingListener({
    Key? key,
    required this.child,
    required this.brightness,
    required this.defaultDesign,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final state = context.watch<BrandingCubit>().state;

    return DesignSystem(
      layerDesign: state.branding.toLayerDesign(
        darkTheme: brightness == Brightness.dark,
        defaultDesign: defaultDesign,
      ),
      child: child,
    );
  }
}
