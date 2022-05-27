import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// All the design styles that can be used.
///
/// Designs can be found on:
/// https://www.figma.com/file/EMahPg2ppvoHuP4c5IYjY1/Layer-UI-Kit?node-id=628%3A14
enum DesignStyle {
  /// Landing + page
  landing,

  /// Common page
  common,

  /// Page + small side panel
  smallPanel,

  /// Page + regular side panel
  regularPanel,

  /// Page + big side panel
  bigPanel,
}

/// All the available design sizes.
enum DesignSize {
  /// Extra small
  extraSmall,

  /// Small
  small,

  /// Medium
  medium,

  /// Large
  large,

  /// Extra large
  extraLarge,
}

/// The default design sizes as found on the Figma file.
/// https://www.figma.com/file/EMahPg2ppvoHuP4c5IYjY1/Layer-UI-Kit?node-id=628%3A14
const defaultDesignSizes = {
  DesignStyle.landing: [
    DesignAwareData(
      size: DesignSize.extraSmall,
      widthLimit: 600.0,
      columnCount: 8,
      gutter: 8.0,
      margin: 16.0,
    ),
    DesignAwareData(
      size: DesignSize.small,
      widthLimit: 905.0,
      columnCount: 8,
      gutter: 24.0,
      margin: 56.0,
    ),
    DesignAwareData(
      size: DesignSize.medium,
      widthLimit: 1240.0,
      columnCount: 12,
      gutter: 24.0,
      margin: 72.0,
    ),
    DesignAwareData(
      size: DesignSize.large,
      widthLimit: 1440.0,
      columnCount: 12,
      gutter: 24.0,
      margin: 120.0,
    ),
    DesignAwareData(
      size: DesignSize.extraLarge,
      widthLimit: double.infinity,
      columnCount: 12,
      gutter: 24.0,
      margin: 200.0,
    ),
  ],
  DesignStyle.common: [
    DesignAwareData(
      size: DesignSize.extraSmall,
      widthLimit: 600.0,
      columnCount: 8,
      gutter: 8.0,
      margin: 16.0,
    ),
    DesignAwareData(
      size: DesignSize.small,
      widthLimit: 905.0,
      columnCount: 12,
      gutter: 16.0,
      margin: 32.0,
    ),
    DesignAwareData(
      size: DesignSize.medium,
      widthLimit: 1240.0,
      columnCount: 12,
      gutter: 16.0,
      margin: 32.0,
    ),
    DesignAwareData(
      size: DesignSize.large,
      widthLimit: 1440.0,
      columnCount: 12,
      gutter: 16.0,
      margin: 32.0,
    ),
    DesignAwareData(
      size: DesignSize.extraLarge,
      widthLimit: double.infinity,
      columnCount: 12,
      gutter: 16.0,
      margin: 124.0,
    ),
  ],
  DesignStyle.smallPanel: [
    DesignAwareData(
      size: DesignSize.extraSmall,
      widthLimit: 600.0,
      columnCount: 8,
      gutter: 8.0,
      margin: 16.0,
    ),
    DesignAwareData(
      size: DesignSize.medium,
      widthLimit: 1240.0,
      columnCount: 12,
      gutter: 16.0,
      margin: 24.0,
      panelWidth: 72.0,
    ),
    DesignAwareData(
      size: DesignSize.large,
      widthLimit: 1440.0,
      columnCount: 12,
      gutter: 16.0,
      margin: 24.0,
      panelWidth: 72.0,
    ),
    DesignAwareData(
      size: DesignSize.extraLarge,
      widthLimit: double.infinity,
      columnCount: 12,
      gutter: 16.0,
      margin: 32.0,
      panelWidth: 72.0,
    ),
  ],
  DesignStyle.regularPanel: [
    DesignAwareData(
      size: DesignSize.extraSmall,
      widthLimit: 600.0,
      columnCount: 8,
      gutter: 8.0,
      margin: 16.0,
    ),
    DesignAwareData(
      size: DesignSize.medium,
      widthLimit: 1240.0,
      columnCount: 12,
      gutter: 16.0,
      margin: 24.0,
      panelWidth: 240.0,
    ),
    DesignAwareData(
      size: DesignSize.large,
      widthLimit: 1440.0,
      columnCount: 12,
      gutter: 16.0,
      margin: 24.0,
      panelWidth: 240.0,
    ),
    DesignAwareData(
      size: DesignSize.extraLarge,
      widthLimit: double.infinity,
      columnCount: 12,
      gutter: 16.0,
      margin: 32.0,
      panelWidth: 240.0,
    ),
  ],
  DesignStyle.bigPanel: [
    DesignAwareData(
      size: DesignSize.medium,
      widthLimit: 1240.0,
      columnCount: 8,
      gutter: 16.0,
      margin: 24.0,
      panelWidth: 380.0,
    ),
    DesignAwareData(
      size: DesignSize.large,
      widthLimit: 1440.0,
      columnCount: 12,
      gutter: 16.0,
      margin: 24.0,
      panelWidth: 380.0,
    ),
    DesignAwareData(
      size: DesignSize.extraLarge,
      widthLimit: double.infinity,
      columnCount: 12,
      gutter: 16.0,
      margin: 32.0,
      panelWidth: 380.0,
    ),
  ],
};

/// Holds the design information.
class DesignAwareData extends Equatable {
  /// The size name of design.
  final DesignSize size;

  /// The width value from which this size is no longer suitable.
  final double widthLimit;

  /// The number of columns that fit on this design.
  final int columnCount;

  /// The width of the gutter, which is the horizontal space between columns.
  final double gutter;

  /// The width of the screen margins.
  final double margin;

  /// The current screen width. Defaults to `0.0`.
  final double screenWidth;

  /// The side panel width.
  ///
  /// Defaults to `0.0`, which means no side panel should be shown.
  final double panelWidth;

  /// Creates a new [DesignAwareData].
  const DesignAwareData({
    required this.size,
    required this.widthLimit,
    required this.columnCount,
    required this.gutter,
    required this.margin,
    this.screenWidth = 0.0,
    this.panelWidth = 0.0,
  });

  /// Helper method to select a text style based on the design size.
  ///
  /// The default text style is always used. If a style is specified for a
  /// specific design size on [stylesBySize], then the two styles are merged.
  /// This is done so that the declaration of the styles is easier, as usually
  /// you only want to one or two properties, like font size or the font weight.
  TextStyle textStyle(
    TextStyle defaultStyle, {
    required Map<DesignSize, TextStyle> stylesBySize,
  }) =>
      defaultStyle.merge(stylesBySize[size]);

  /// Calculates the size of a single column based on the screen width.
  double get columnWidth => (screenWidth <= 0 || columnCount <= 0)
      ? 0.0
      : ((screenWidth - (2.0 * margin) - ((columnCount - 1) * gutter)) /
              columnCount)
          .floorToDouble();

  @override
  List<Object> get props => [
        size,
        widthLimit,
        columnCount,
        gutter,
        margin,
        screenWidth,
        panelWidth,
      ];

  /// Creates a copy of this data with selected changes.
  DesignAwareData copyWith({
    DesignSize? size,
    double? widthLimit,
    int? columnCount,
    double? gutter,
    double? margin,
    double? screenWidth,
    double? panelWidth,
  }) =>
      DesignAwareData(
        size: size ?? this.size,
        widthLimit: widthLimit ?? this.widthLimit,
        columnCount: columnCount ?? this.columnCount,
        gutter: gutter ?? this.gutter,
        margin: margin ?? this.margin,
        screenWidth: screenWidth ?? this.screenWidth,
        panelWidth: panelWidth ?? this.panelWidth,
      );

  @override
  String toString() => 'DesignAwareData{'
      '${'size: $size '}'
      '${'widthLimit: $widthLimit '}'
      '${'columnCount: $columnCount '}'
      '${'gutter: $gutter '}'
      '${'margin: $margin '}'
      '${'screenWidth: $screenWidth '}'
      '${'calculated column width: $columnWidth '}'
      '${panelWidth > 0.0 ? 'panelWidth: $panelWidth ' : ''}'
      '}';
}
