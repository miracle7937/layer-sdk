import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

import 'design_data.dart';

/// A widget that provides design information for the current device.
class DesignAware extends InheritedWidget {
  static final _log = Logger('DesignAware');

  /// The size definitions to use, by design style.
  ///
  /// If not supplied, defaults to the Figma defaults, found on
  /// [defaultDesignSizes].
  ///
  /// Note that they should be presented from smallest to biggest, inside each
  /// style, or else the code will not select the size correctly.
  final Map<DesignStyle, List<DesignAwareData>> availableSizes;

  /// Creates a new design aware widget.
  ///
  /// It's easy to customize the default design sizes, as for example changing
  /// the sizes for the `landing` size:
  /// ```
  /// DesignAware(
  ///   availableSizes: defaultDesignSizes.map(
  ///         (key, value) => key == DesignStyle.landing
  ///         ? const MapEntry(
  ///       DesignStyle.landing,
  ///       [
  ///         DesignAwareData(
  ///           size: DesignSize.extraSmall,
  ///           widthLimit: 300.0,
  ///           columnCount: 4,
  ///           gutter: 8.0,
  ///           margin: 16.0,
  ///         ),
  ///         DesignAwareData(
  ///           size: DesignSize.small,
  ///           widthLimit: 500.0,
  ///           columnCount: 8,
  ///           gutter: 8.0,
  ///           margin: 16.0,
  ///         ),
  ///       ],
  ///     )
  ///         : MapEntry(key, value),
  ///   ),
  ///   child: Container(),
  /// );
  /// ```
  const DesignAware({
    Key? key,
    required Widget child,
    this.availableSizes = defaultDesignSizes,
  }) : super(key: key, child: child);

  /// Returns the design data for the current screen size, based on the style.
  ///
  /// [style] defaults to [DesignStyle.common].
  static DesignAwareData of(
    BuildContext context, {
    DesignStyle style = DesignStyle.common,
  }) {
    final widget = context.dependOnInheritedWidgetOfExactType<DesignAware>();

    assert(widget != null, 'No DesignAware found in context.');

    return widget!._data(context, style: style);
  }

  DesignAwareData _data(
    BuildContext context, {
    DesignStyle style = DesignStyle.common,
  }) {
    assert(availableSizes[style] != null, 'Style $style not available.');

    final width = MediaQuery.of(context).size.width;

    final styleSizes = availableSizes[style]!;

    final styleSize = styleSizes
        .firstWhere(
          (e) => width < e.widthLimit,
          orElse: () => styleSizes.last,
        )
        .copyWith(screenWidth: width);

    _log.info('Design Style Size: $styleSize');

    return styleSize;
  }

  @override
  bool updateShouldNotify(covariant DesignAware oldWidget) =>
      availableSizes != oldWidget.availableSizes;
}
