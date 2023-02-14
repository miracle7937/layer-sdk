import '../../../domain_layer/models.dart';
import '../../dtos.dart';
import '../../extensions.dart';

/// Extension that provides mappings for [BrandingDTO]
// TODO: CONSOLE SPECIFIC
extension BrandingDTOMapping on BrandingDTO {
  /// Maps into a [Branding]
  Branding toBranding({
    Branding? defaultBranding,
  }) =>
      Branding(
        logoURL: logo ?? defaultBranding?.logo,
        lightColors: lightColors?.toBrandingColors(
          defaultBrandingColors: defaultBranding?.lightColors,
        ),
        darkColors: darkColors?.toBrandingColors(
          defaultBrandingColors: defaultBranding?.darkColors,
        ),
        defaultFontFamily:
            defaultFontFamily ?? defaultBranding?.defaultFontFamily,
        fonts: BrandingFonts(
          baseTitleXXXL: _fontFrom(
            baseTitleXXXL,
            defaultBranding?.fonts.baseTitleXXXL,
          ),
          baseTitleXXL: _fontFrom(
            baseTitleXXL,
            defaultBranding?.fonts.baseTitleXXL,
          ),
          baseTitleXL: _fontFrom(
            baseTitleXL,
            defaultBranding?.fonts.baseTitleXL,
          ),
          baseTitleL: _fontFrom(
            baseTitleL,
            defaultBranding?.fonts.baseTitleL,
          ),
          baseTitleM: _fontFrom(
            baseTitleM,
            defaultBranding?.fonts.baseTitleM,
          ),
          baseTitleS: _fontFrom(
            baseTitleS,
            defaultBranding?.fonts.baseTitleS,
          ),
          baseTitleXS: _fontFrom(
            baseTitleXS,
            defaultBranding?.fonts.baseTitleXS,
          ),
          baseBodyXXL: _fontFrom(
            baseBodyXXL,
            defaultBranding?.fonts.baseBodyXXL,
          ),
          baseBodyXL: _fontFrom(
            baseBodyXL,
            defaultBranding?.fonts.baseBodyXL,
          ),
          baseBodyL: _fontFrom(
            baseBodyL,
            defaultBranding?.fonts.baseBodyL,
          ),
          baseBodyM: _fontFrom(
            baseBodyM,
            defaultBranding?.fonts.baseBodyM,
          ),
          baseBodyS: _fontFrom(
            baseBodyS,
            defaultBranding?.fonts.baseBodyS,
          ),
          baseBodyXS: _fontFrom(
            baseBodyXS,
            defaultBranding?.fonts.baseBodyXS,
          ),
          baseButtonM: _fontFrom(
            baseButtonM,
            defaultBranding?.fonts.baseButtonM,
          ),
          baseButtonS: _fontFrom(
            baseButtonS,
            defaultBranding?.fonts.baseButtonS,
          ),
        ),
      );

  BrandingFont _fontFrom(BrandingFontDTO? dto, BrandingFont? defaultFont) =>
      BrandingFont(
        family: dto?.family ?? defaultFont?.family,
        size: dto?.size ?? defaultFont?.size,
        weight: dto?.weight ?? defaultFont?.weight,
        lineHeight: dto?.lineHeight ?? defaultFont?.lineHeight,
        letterSpacingPercentage: dto?.letterSpacingPercentage ??
            defaultFont?.letterSpacingPercentage,
      );
}

/// Extension that provides mappings for [BrandingColorsDTO]
extension BrandingColorsDTOMapping on BrandingColorsDTO {
  /// Maps into a [BrandingColors]
  BrandingColors toBrandingColors({
    BrandingColors? defaultBrandingColors,
  }) =>
      BrandingColors(
        // Do not set the gradient automatically, as if the brand has no
        // gradient it should be empty.
        brandGradientStart: brandGradientStart?.parseHexValueToInt(),
        brandGradientEnd: brandGradientEnd?.parseHexValueToInt(),

        brandPrimary: brandPrimary?.parseHexValueToInt() ??
            defaultBrandingColors?.brandPrimary,
        brandSecondary: brandSecondary?.parseHexValueToInt() ??
            defaultBrandingColors?.brandSecondary,
        brandTertiary: brandTertiary?.parseHexValueToInt() ??
            defaultBrandingColors?.brandTertiary,
        basePrimary: basePrimary?.parseHexValueToInt() ??
            defaultBrandingColors?.basePrimary,
        basePrimaryWhite: basePrimaryWhite?.parseHexValueToInt() ??
            defaultBrandingColors?.basePrimaryWhite,
        basePrimaryBlack: basePrimaryBlack?.parseHexValueToInt() ??
            defaultBrandingColors?.basePrimaryBlack,
        basePrimaryTertiary: basePrimaryTertiary?.parseHexValueToInt() ??
            defaultBrandingColors?.basePrimaryTertiary,
        basePrimaryQuinary: basePrimaryQuinary?.parseHexValueToInt() ??
            defaultBrandingColors?.basePrimaryQuinary,
        basePrimarySenary: basePrimarySenary?.parseHexValueToInt() ??
            defaultBrandingColors?.basePrimarySenary,
        baseSecondary: baseSecondary?.parseHexValueToInt() ??
            defaultBrandingColors?.baseSecondary,
        baseTertiary: baseTertiary?.parseHexValueToInt() ??
            defaultBrandingColors?.baseTertiary,
        baseQuaternary: baseQuaternary?.parseHexValueToInt() ??
            defaultBrandingColors?.baseQuaternary,
        baseQuinary: baseQuinary?.parseHexValueToInt() ??
            defaultBrandingColors?.baseQuinary,
        baseSenary: baseSenary?.parseHexValueToInt() ??
            defaultBrandingColors?.baseSenary,
        baseSeptenary: baseSeptenary?.parseHexValueToInt() ??
            defaultBrandingColors?.baseSeptenary,
        baseOctonary: baseOctonary?.parseHexValueToInt() ??
            defaultBrandingColors?.baseOctonary,
        baseNonary: baseNonary?.parseHexValueToInt() ??
            defaultBrandingColors?.baseNonary,
        surfaceSeptenary1: surfaceSeptenary1?.parseHexValueToInt() ??
            defaultBrandingColors?.surfaceSeptenary1,
        surfaceSeptenary2: surfaceSeptenary2?.parseHexValueToInt() ??
            defaultBrandingColors?.surfaceSeptenary2,
        surfaceSeptenary3: surfaceSeptenary3?.parseHexValueToInt() ??
            defaultBrandingColors?.surfaceSeptenary3,
        surfaceSeptenary4: surfaceSeptenary4?.parseHexValueToInt() ??
            defaultBrandingColors?.surfaceSeptenary4,
        surfaceOctonary1: surfaceOctonary1?.parseHexValueToInt() ??
            defaultBrandingColors?.surfaceOctonary1,
        surfaceOctonary2: surfaceOctonary2?.parseHexValueToInt() ??
            defaultBrandingColors?.surfaceOctonary2,
        surfaceOctonary3: surfaceOctonary3?.parseHexValueToInt() ??
            defaultBrandingColors?.surfaceOctonary3,
        surfaceOctonary4: surfaceOctonary4?.parseHexValueToInt() ??
            defaultBrandingColors?.surfaceOctonary4,
        surfaceNonary1: surfaceNonary1?.parseHexValueToInt() ??
            defaultBrandingColors?.surfaceNonary1,
        surfaceNonary2: surfaceNonary2?.parseHexValueToInt() ??
            defaultBrandingColors?.surfaceNonary2,
        surfaceNonary3: surfaceNonary3?.parseHexValueToInt() ??
            defaultBrandingColors?.surfaceNonary3,
        surfaceNonary4: surfaceNonary4?.parseHexValueToInt() ??
            defaultBrandingColors?.surfaceNonary4,
        successAlpha: successAlpha?.parseHexValueToInt() ??
            defaultBrandingColors?.successAlpha,
        successPrimary: successPrimary?.parseHexValueToInt() ??
            defaultBrandingColors?.successPrimary,
        successDarkPrimary: successDarkPrimary?.parseHexValueToInt() ??
            defaultBrandingColors?.successDarkPrimary,
        successSecondary: successSecondary?.parseHexValueToInt() ??
            defaultBrandingColors?.successSecondary,
        successTertiary: successTertiary?.parseHexValueToInt() ??
            defaultBrandingColors?.successTertiary,
        successQuaternary: successQuaternary?.parseHexValueToInt() ??
            defaultBrandingColors?.successQuaternary,
        successQuinary: successQuinary?.parseHexValueToInt() ??
            defaultBrandingColors?.successQuinary,
        errorAlpha: errorAlpha?.parseHexValueToInt() ??
            defaultBrandingColors?.errorAlpha,
        errorPrimary: errorPrimary?.parseHexValueToInt() ??
            defaultBrandingColors?.errorPrimary,
        errorDarkPrimary: errorDarkPrimary?.parseHexValueToInt() ??
            defaultBrandingColors?.errorDarkPrimary,
        errorSecondary: errorSecondary?.parseHexValueToInt() ??
            defaultBrandingColors?.errorSecondary,
        errorTertiary: errorTertiary?.parseHexValueToInt() ??
            defaultBrandingColors?.errorTertiary,
        errorQuaternary: errorQuaternary?.parseHexValueToInt() ??
            defaultBrandingColors?.errorQuaternary,
        errorQuinary: errorQuinary?.parseHexValueToInt() ??
            defaultBrandingColors?.errorQuinary,
        warningAlpha: warningAlpha?.parseHexValueToInt() ??
            defaultBrandingColors?.warningAlpha,
        warningPrimary: warningPrimary?.parseHexValueToInt() ??
            defaultBrandingColors?.warningPrimary,
        warningDarkPrimary: warningDarkPrimary?.parseHexValueToInt() ??
            defaultBrandingColors?.warningDarkPrimary,
        warningSecondary: warningSecondary?.parseHexValueToInt() ??
            defaultBrandingColors?.warningSecondary,
        warningTertiary: warningTertiary?.parseHexValueToInt() ??
            defaultBrandingColors?.warningTertiary,
        warningQuaternary: warningQuaternary?.parseHexValueToInt() ??
            defaultBrandingColors?.warningQuaternary,
        warningQuinary: warningQuinary?.parseHexValueToInt() ??
            defaultBrandingColors?.warningQuinary,
        cautionAlpha: cautionAlpha?.parseHexValueToInt() ??
            defaultBrandingColors?.cautionAlpha,
        cautionPrimary: cautionPrimary?.parseHexValueToInt() ??
            defaultBrandingColors?.cautionPrimary,
        cautionDarkPrimary: cautionDarkPrimary?.parseHexValueToInt() ??
            defaultBrandingColors?.cautionDarkPrimary,
        cautionSecondary: cautionSecondary?.parseHexValueToInt() ??
            defaultBrandingColors?.cautionSecondary,
        cautionTertiary: cautionTertiary?.parseHexValueToInt() ??
            defaultBrandingColors?.cautionTertiary,
        cautionQuaternary: cautionQuaternary?.parseHexValueToInt() ??
            defaultBrandingColors?.cautionQuaternary,
        cautionQuinary: cautionQuinary?.parseHexValueToInt() ??
            defaultBrandingColors?.cautionQuinary,
        infoAlpha:
            infoAlpha?.parseHexValueToInt() ?? defaultBrandingColors?.infoAlpha,
        infoPrimary: infoPrimary?.parseHexValueToInt() ??
            defaultBrandingColors?.infoPrimary,
        infoDarkPrimary: infoDarkPrimary?.parseHexValueToInt() ??
            defaultBrandingColors?.infoDarkPrimary,
        infoSecondary: infoSecondary?.parseHexValueToInt() ??
            defaultBrandingColors?.infoSecondary,
        infoTertiary: infoTertiary?.parseHexValueToInt() ??
            defaultBrandingColors?.infoTertiary,
        infoQuaternary: infoQuaternary?.parseHexValueToInt() ??
            defaultBrandingColors?.infoQuaternary,
        infoQuinary: infoQuinary?.parseHexValueToInt() ??
            defaultBrandingColors?.infoQuinary,
      );
}
