import 'package:design_kit_layer/design_kit_layer.dart';
import 'package:flutter/material.dart';

import '../../../features/dpa.dart';

/// UI extensions for the [DPAVariableTextProperties].
extension DPAVariableTextPropertiesUIExtension on DPAVariableTextProperties {
  /// Converts the color hex string into a flutter color.
  Color? get flutterColor {
    if (color == null) {
      return null;
    }

    final parsedColor = int.tryParse(
      color!.replaceAll('#', '0xFF'),
    );

    if (parsedColor == null) {
      return null;
    }

    return Color(parsedColor);
  }

  /// Converts a [DPAVariableTextStyle] into a [TextStyle].
  TextStyle? toTextStyle(
    LayerDesign layerDesign,
  ) {
    switch (textStyle) {
      case DPAVariableTextStyle.titleXXXL:
        return layerDesign.titleXXXL(
          color: flutterColor,
        );

      case DPAVariableTextStyle.titleXXL:
        return layerDesign.titleXXL(
          color: flutterColor,
        );

      case DPAVariableTextStyle.titleXL:
        return layerDesign.titleXL(
          color: flutterColor,
        );

      case DPAVariableTextStyle.titleL:
        return layerDesign.titleL(
          color: flutterColor,
        );

      case DPAVariableTextStyle.titleM:
        return layerDesign.titleM(
          color: flutterColor,
        );

      case DPAVariableTextStyle.titleS:
        return layerDesign.titleS(
          color: flutterColor,
        );

      case DPAVariableTextStyle.titleXS:
        return layerDesign.titleXS(
          color: flutterColor,
        );

      case DPAVariableTextStyle.bodyXXL:
        return layerDesign.bodyXXL(
          color: flutterColor,
        );

      case DPAVariableTextStyle.bodyXL:
        return layerDesign.bodyXL(
          color: flutterColor,
        );

      case DPAVariableTextStyle.bodyL:
        return layerDesign.bodyL(
          color: flutterColor,
        );

      case DPAVariableTextStyle.bodyM:
        return layerDesign.bodyM(
          color: flutterColor,
        );

      case DPAVariableTextStyle.bodyS:
        return layerDesign.bodyS(
          color: flutterColor,
        );

      case DPAVariableTextStyle.bodyXS:
        return layerDesign.bodyXS(
          color: flutterColor,
        );

      case DPAVariableTextStyle.buttonM:
        return layerDesign.buttonM(
          color: flutterColor,
        );

      case DPAVariableTextStyle.buttonS:
        return layerDesign.buttonS(
          color: flutterColor,
        );

      default:
        return null;
    }
  }
}
