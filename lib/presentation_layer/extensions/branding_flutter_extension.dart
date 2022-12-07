import 'package:design_kit_layer/design_kit_layer.dart';
import 'package:flutter/material.dart';

import '../../domain_layer/models.dart';
import '../../presentation_layer/extensions.dart';

/// Flutter Extension for [Branding]
extension BrandingFlutterExtension on Branding {
  /// Creates a [LayerDesign] from this [Branding].
  LayerDesign toLayerDesign({
    bool darkTheme = false,
    required LayerDesign defaultDesign,
  }) {
    final colors = darkTheme ? darkColors : lightColors;

    return LayerDesign(
      brightness: darkTheme ? Brightness.dark : Brightness.light,
      fontFamily: defaultFontFamily ?? defaultDesign.fontFamily,
      brandGradient: (colors?.brandGradientStart == null ||
              colors?.brandGradientEnd == null)
          ? defaultDesign.brandGradient
          : LinearGradient(
              colors: [
                colors!.brandGradientStart!.toColor(),
                colors.brandGradientEnd!.toColor(),
              ],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
      brandPrimary:
          colors?.brandPrimary?.toColor() ?? defaultDesign.brandPrimary,
      brandSecondary:
          colors?.brandSecondary?.toColor() ?? defaultDesign.brandSecondary,
      brandTertiary:
          colors?.brandTertiary?.toColor() ?? defaultDesign.brandTertiary,
      basePrimary: colors?.basePrimary?.toColor() ?? defaultDesign.basePrimary,
      basePrimaryWhite:
          colors?.basePrimaryWhite?.toColor() ?? defaultDesign.basePrimaryWhite,
      basePrimaryBlack:
          colors?.basePrimaryBlack?.toColor() ?? defaultDesign.basePrimaryBlack,
      basePrimaryTertiary: colors?.basePrimaryTertiary?.toColor() ??
          defaultDesign.basePrimaryTertiary,
      basePrimaryQuinary: colors?.basePrimaryQuinary?.toColor() ??
          defaultDesign.basePrimaryQuinary,
      basePrimarySenary: colors?.basePrimarySenary?.toColor() ??
          defaultDesign.basePrimarySenary,
      baseSecondary:
          colors?.baseSecondary?.toColor() ?? defaultDesign.baseSecondary,
      baseTertiary:
          colors?.baseTertiary?.toColor() ?? defaultDesign.baseTertiary,
      baseQuaternary:
          colors?.baseQuaternary?.toColor() ?? defaultDesign.baseQuaternary,
      baseQuinary: colors?.baseQuinary?.toColor() ?? defaultDesign.baseQuinary,
      baseSenary: colors?.baseSenary?.toColor() ?? defaultDesign.baseSenary,
      baseSeptenary:
          colors?.baseSeptenary?.toColor() ?? defaultDesign.baseSeptenary,
      baseOctonary:
          colors?.baseOctonary?.toColor() ?? defaultDesign.baseOctonary,
      baseNonary: colors?.baseNonary?.toColor() ?? defaultDesign.baseNonary,
      surfaceSeptenary1: colors?.surfaceSeptenary1?.toColor() ??
          defaultDesign.surfaceSeptenary1,
      surfaceSeptenary2: colors?.surfaceSeptenary2?.toColor() ??
          defaultDesign.surfaceSeptenary2,
      surfaceSeptenary3: colors?.surfaceSeptenary3?.toColor() ??
          defaultDesign.surfaceSeptenary3,
      surfaceSeptenary4: colors?.surfaceSeptenary4?.toColor() ??
          defaultDesign.surfaceSeptenary4,
      surfaceOctonary1:
          colors?.surfaceOctonary1?.toColor() ?? defaultDesign.surfaceOctonary1,
      surfaceOctonary2:
          colors?.surfaceOctonary2?.toColor() ?? defaultDesign.surfaceOctonary2,
      surfaceOctonary3:
          colors?.surfaceOctonary3?.toColor() ?? defaultDesign.surfaceOctonary3,
      surfaceOctonary4:
          colors?.surfaceOctonary4?.toColor() ?? defaultDesign.surfaceOctonary4,
      surfaceNonary1:
          colors?.surfaceNonary1?.toColor() ?? defaultDesign.surfaceNonary1,
      surfaceNonary2:
          colors?.surfaceNonary2?.toColor() ?? defaultDesign.surfaceNonary2,
      surfaceNonary3:
          colors?.surfaceNonary3?.toColor() ?? defaultDesign.surfaceNonary3,
      surfaceNonary4:
          colors?.surfaceNonary4?.toColor() ?? defaultDesign.surfaceNonary4,
      successAlpha:
          colors?.successAlpha?.toColor() ?? defaultDesign.successAlpha,
      successPrimary:
          colors?.successPrimary?.toColor() ?? defaultDesign.successPrimary,
      successDarkPrimary: colors?.successDarkPrimary?.toColor() ??
          defaultDesign.successDarkPrimary,
      successSecondary:
          colors?.successSecondary?.toColor() ?? defaultDesign.successSecondary,
      successTertiary:
          colors?.successTertiary?.toColor() ?? defaultDesign.successTertiary,
      successQuaternary: colors?.successQuaternary?.toColor() ??
          defaultDesign.successQuaternary,
      successQuinary:
          colors?.successQuinary?.toColor() ?? defaultDesign.successQuinary,
      errorAlpha: colors?.errorAlpha?.toColor() ?? defaultDesign.errorAlpha,
      errorPrimary:
          colors?.errorPrimary?.toColor() ?? defaultDesign.errorPrimary,
      errorDarkPrimary:
          colors?.errorDarkPrimary?.toColor() ?? defaultDesign.errorDarkPrimary,
      errorSecondary:
          colors?.errorSecondary?.toColor() ?? defaultDesign.errorSecondary,
      errorTertiary:
          colors?.errorTertiary?.toColor() ?? defaultDesign.errorTertiary,
      errorQuaternary:
          colors?.errorQuaternary?.toColor() ?? defaultDesign.errorQuaternary,
      errorQuinary:
          colors?.errorQuinary?.toColor() ?? defaultDesign.errorQuinary,
      warningAlpha:
          colors?.warningAlpha?.toColor() ?? defaultDesign.warningAlpha,
      warningPrimary:
          colors?.warningPrimary?.toColor() ?? defaultDesign.warningPrimary,
      warningDarkPrimary: colors?.warningDarkPrimary?.toColor() ??
          defaultDesign.warningDarkPrimary,
      warningSecondary:
          colors?.warningSecondary?.toColor() ?? defaultDesign.warningSecondary,
      warningTertiary:
          colors?.warningTertiary?.toColor() ?? defaultDesign.warningTertiary,
      warningQuaternary: colors?.warningQuaternary?.toColor() ??
          defaultDesign.warningQuaternary,
      warningQuinary:
          colors?.warningQuinary?.toColor() ?? defaultDesign.warningQuinary,
      cautionAlpha:
          colors?.cautionAlpha?.toColor() ?? defaultDesign.cautionAlpha,
      cautionPrimary:
          colors?.cautionPrimary?.toColor() ?? defaultDesign.cautionPrimary,
      cautionDarkPrimary: colors?.cautionDarkPrimary?.toColor() ??
          defaultDesign.cautionDarkPrimary,
      cautionSecondary:
          colors?.cautionSecondary?.toColor() ?? defaultDesign.cautionSecondary,
      cautionTertiary:
          colors?.cautionTertiary?.toColor() ?? defaultDesign.cautionTertiary,
      cautionQuaternary: colors?.cautionQuaternary?.toColor() ??
          defaultDesign.cautionQuaternary,
      cautionQuinary:
          colors?.cautionQuinary?.toColor() ?? defaultDesign.cautionQuinary,
      infoAlpha: colors?.infoAlpha?.toColor() ?? defaultDesign.infoAlpha,
      infoPrimary: colors?.infoPrimary?.toColor() ?? defaultDesign.infoPrimary,
      infoDarkPrimary:
          colors?.infoDarkPrimary?.toColor() ?? defaultDesign.infoDarkPrimary,
      infoSecondary:
          colors?.infoSecondary?.toColor() ?? defaultDesign.infoSecondary,
      infoTertiary:
          colors?.infoTertiary?.toColor() ?? defaultDesign.infoTertiary,
      infoQuaternary:
          colors?.infoQuaternary?.toColor() ?? defaultDesign.infoQuaternary,
      infoQuinary: colors?.infoQuinary?.toColor() ?? defaultDesign.infoQuinary,
      baseTitleXXXL:
          fonts.baseTitleXXXL?.toTextStyle() ?? defaultDesign.titleXXXL(),
      baseTitleXXL:
          fonts.baseTitleXXL?.toTextStyle() ?? defaultDesign.titleXXL(),
      baseTitleXL: fonts.baseTitleXL?.toTextStyle() ?? defaultDesign.titleXL(),
      baseTitleL: fonts.baseTitleL?.toTextStyle() ?? defaultDesign.titleL(),
      baseTitleM: fonts.baseTitleM?.toTextStyle() ?? defaultDesign.titleM(),
      baseTitleS: fonts.baseTitleS?.toTextStyle() ?? defaultDesign.titleS(),
      baseTitleXS: fonts.baseTitleXS?.toTextStyle() ?? defaultDesign.titleXS(),
      baseBodyXXL: fonts.baseBodyXXL?.toTextStyle() ?? defaultDesign.bodyXXL(),
      baseBodyXL: fonts.baseBodyXL?.toTextStyle() ?? defaultDesign.bodyXL(),
      baseBodyL: fonts.baseBodyL?.toTextStyle() ?? defaultDesign.bodyL(),
      baseBodyM: fonts.baseBodyM?.toTextStyle() ?? defaultDesign.bodyM(),
      baseBodyS: fonts.baseBodyS?.toTextStyle() ?? defaultDesign.bodyS(),
      baseBodyXS: fonts.baseBodyXS?.toTextStyle() ?? defaultDesign.bodyXS(),
      baseButtonM: fonts.baseButtonM?.toTextStyle() ?? defaultDesign.buttonM(),
      baseButtonS: fonts.baseButtonS?.toTextStyle() ?? defaultDesign.buttonS(),
    );
  }
}

/// Flutter Extension for [BrandingFont]
extension BrandingFontFlutterExtension on BrandingFont {
  /// Creates a [TextStyle] from this [BrandingFont].
  TextStyle toTextStyle() => TextStyle(
        fontFamily: family,
        fontSize: size,
        fontWeight: weight?.toFontWeight(),
        height: lineHeight == null || size == null ? null : lineHeight! / size!,
        // TODO: review the letter spacing calculation
        letterSpacing: (letterSpacingPercentage ?? 100.0) / 100.0,
      );
}
