import '../../helpers.dart';

/// Holds the data used for the branding of the app.
class BrandingDTO {
  /// The logo URL.
  final String? logo;

  /// The colors for the light theme.
  final BrandingColorsDTO? lightColors;

  /// The colors for the dark theme.
  final BrandingColorsDTO? darkColors;

  /// The default font family to use for this brand.
  final String? defaultFontFamily;

  /// The base title XXXL style.
  final BrandingFontDTO? baseTitleXXXL;

  /// The base title XXL style.
  final BrandingFontDTO? baseTitleXXL;

  /// The base title XL style.
  final BrandingFontDTO? baseTitleXL;

  /// The base title L style.
  final BrandingFontDTO? baseTitleL;

  /// The base title M style.
  final BrandingFontDTO? baseTitleM;

  /// The base title S style.
  final BrandingFontDTO? baseTitleS;

  /// The base title XS style.
  final BrandingFontDTO? baseTitleXS;

  /// The base Body XXL style.
  final BrandingFontDTO? baseBodyXXL;

  /// The base Body XL style.
  final BrandingFontDTO? baseBodyXL;

  /// The base Body L style.
  final BrandingFontDTO? baseBodyL;

  /// The base Body M style.
  final BrandingFontDTO? baseBodyM;

  /// The base Body S style.
  final BrandingFontDTO? baseBodyS;

  /// The base Body XS style.
  final BrandingFontDTO? baseBodyXS;

  /// The base Button M style.
  final BrandingFontDTO? baseButtonM;

  /// The base Button S style.
  final BrandingFontDTO? baseButtonS;

  /// Creates a new [BrandingDTO].
  BrandingDTO({
    this.logo,
    this.lightColors,
    this.darkColors,
    this.defaultFontFamily,
    this.baseTitleXXXL,
    this.baseTitleXXL,
    this.baseTitleXL,
    this.baseTitleL,
    this.baseTitleM,
    this.baseTitleS,
    this.baseTitleXS,
    this.baseBodyXXL,
    this.baseBodyXL,
    this.baseBodyL,
    this.baseBodyM,
    this.baseBodyS,
    this.baseBodyXS,
    this.baseButtonM,
    this.baseButtonS,
  });

  /// Creates a [BrandingDTO] from a JSON
  factory BrandingDTO.fromJson(Map<String, dynamic> json) => BrandingDTO(
        logo: json['logo'],
        lightColors: BrandingColorsDTO.fromJson(json['light'] ?? {}),
        darkColors: BrandingColorsDTO.fromJson(json['dark'] ?? {}),
        defaultFontFamily: json['defaultFontFamily'],
        baseTitleXXXL: BrandingFontDTO.fromJson(json['baseTitleXXXL'] ?? {}),
        baseTitleXXL: BrandingFontDTO.fromJson(json['baseTitleXXL'] ?? {}),
        baseTitleXL: BrandingFontDTO.fromJson(json['baseTitleXL'] ?? {}),
        baseTitleL: BrandingFontDTO.fromJson(json['baseTitleL'] ?? {}),
        baseTitleM: BrandingFontDTO.fromJson(json['baseTitleM'] ?? {}),
        baseTitleS: BrandingFontDTO.fromJson(json['baseTitleS'] ?? {}),
        baseTitleXS: BrandingFontDTO.fromJson(json['baseTitleXS'] ?? {}),
        baseBodyXXL: BrandingFontDTO.fromJson(json['baseBodyXXL'] ?? {}),
        baseBodyXL: BrandingFontDTO.fromJson(json['baseBodyXL'] ?? {}),
        baseBodyL: BrandingFontDTO.fromJson(json['baseBodyL'] ?? {}),
        baseBodyM: BrandingFontDTO.fromJson(json['baseBodyM'] ?? {}),
        baseBodyS: BrandingFontDTO.fromJson(json['baseBodyS'] ?? {}),
        baseBodyXS: BrandingFontDTO.fromJson(json['baseBodyXS'] ?? {}),
        baseButtonM: BrandingFontDTO.fromJson(json['baseButtonM'] ?? {}),
        baseButtonS: BrandingFontDTO.fromJson(json['baseButtonS'] ?? {}),
      );
}

/// The DTO for the theme colors.
class BrandingColorsDTO {
  /// Hex value for brand gradient start.
  final String? brandGradientStart;

  /// Hex value for brand gradient end.
  final String? brandGradientEnd;

  /// Hex value for brand primary color.
  final String? brandPrimary;

  /// Hex value for brand secondary color.
  final String? brandSecondary;

  /// Hex value for brand tertiary color.
  final String? brandTertiary;

  /// Hex value for base primary white.
  final String? basePrimaryWhite;

  /// Hex value for base primary color.
  final String? basePrimary;

  /// Hex value for base secondary color.
  final String? baseSecondary;

  /// Hex value for base tertiary color.
  final String? baseTertiary;

  /// Hex value for base quaternary color.
  final String? baseQuaternary;

  /// Hex value for base quinary color.
  final String? baseQuinary;

  /// Hex value for base senary color.
  final String? baseSenary;

  /// Hex value for base septenary color.
  final String? baseSeptenary;

  /// Hex value for base octonary color.
  final String? baseOctonary;

  /// Hex value for base nonary color.
  final String? baseNonary;

  /// Hex value for surface septenary 1 color.
  final String? surfaceSeptenary1;

  /// Hex value for surface septenary 2 color.
  final String? surfaceSeptenary2;

  /// Hex value for surface septenary 3 color.
  final String? surfaceSeptenary3;

  /// Hex value for surface septenary 4 color.
  final String? surfaceSeptenary4;

  /// Hex value for surface octonary 1 color.
  final String? surfaceOctonary1;

  /// Hex value for surface octonary 2 color.
  final String? surfaceOctonary2;

  /// Hex value for surface octonary 3 color.
  final String? surfaceOctonary3;

  /// Hex value for surface octonary 4 color.
  final String? surfaceOctonary4;

  /// Hex value for surface nonary 1 color.
  final String? surfaceNonary1;

  /// Hex value for surface nonary 2 color.
  final String? surfaceNonary2;

  /// Hex value for surface nonary 3 color.
  final String? surfaceNonary3;

  /// Hex value for surface nonary 4 color.
  final String? surfaceNonary4;

  /// Hex value for the dark alpha base color.
  final String? darkAlpha;

  /// Hex value for the white alpha base color.
  final String? whiteAlpha;

  /// Hex value for the dark primary success color.
  final String? successDarkPrimary;

  /// Hex value for the primary success color.
  final String? successPrimary;

  /// Hex value for the secondary success color.
  final String? successSecondary;

  /// Hex value for the tertiary success color.
  final String? successTertiary;

  /// Hex value for the quaternary success color.
  final String? successQuaternary;

  /// Hex value for the quinary success color.
  final String? successQuinary;

  /// Hex value for the dark primary error color.
  final String? errorDarkPrimary;

  /// Hex value for the primary error color.
  final String? errorPrimary;

  /// Hex value for the secondary error color.
  final String? errorSecondary;

  /// Hex value for the tertiary error color.
  final String? errorTertiary;

  /// Hex value for the quaternary error color.
  final String? errorQuaternary;

  /// Hex value for the quinary error color.
  final String? errorQuinary;

  /// Hex value for the dark primary warning color.
  final String? warningDarkPrimary;

  /// Hex value for the primary warning color.
  final String? warningPrimary;

  /// Hex value for the secondary warning color.
  final String? warningSecondary;

  /// Hex value for the tertiary warning color.
  final String? warningTertiary;

  /// Hex value for the quaternary warning color.
  final String? warningQuaternary;

  /// Hex value for the quinary warning color.
  final String? warningQuinary;

  /// Hex value for the dark primary caution color.
  final String? cautionDarkPrimary;

  /// Hex value for the primary caution color.
  final String? cautionPrimary;

  /// Hex value for the secondary caution color.
  final String? cautionSecondary;

  /// Hex value for the tertiary caution color.
  final String? cautionTertiary;

  /// Hex value for the quaternary caution color.
  final String? cautionQuaternary;

  /// Hex value for the quinary caution color.
  final String? cautionQuinary;

  /// Hex value for the dark primary info color.
  final String? infoDarkPrimary;

  /// Hex value for the primary info color.
  final String? infoPrimary;

  /// Hex value for the secondary info color.
  final String? infoSecondary;

  /// Hex value for the tertiary info color.
  final String? infoTertiary;

  /// Hex value for the quaternary info color.
  final String? infoQuaternary;

  /// Hex value for the quinary info color.
  final String? infoQuinary;

  /// Hex value for the success alpha color.
  final String? successAlpha;

  /// Hex value for the error alpha color.
  final String? errorAlpha;

  /// Hex value for the warning alpha color.
  final String? warningAlpha;

  /// Hex value for the caution alpha color.
  final String? cautionAlpha;

  /// Hex value for the info alpha color.
  final String? infoAlpha;

  /// Creates a new [BrandingColorsDTO].
  const BrandingColorsDTO({
    this.brandGradientStart,
    this.brandGradientEnd,
    this.brandPrimary,
    this.brandSecondary,
    this.brandTertiary,
    this.basePrimaryWhite,
    this.basePrimary,
    this.baseSecondary,
    this.baseTertiary,
    this.baseQuaternary,
    this.baseQuinary,
    this.baseSenary,
    this.baseSeptenary,
    this.baseOctonary,
    this.baseNonary,
    this.surfaceSeptenary1,
    this.surfaceSeptenary2,
    this.surfaceSeptenary3,
    this.surfaceSeptenary4,
    this.surfaceOctonary1,
    this.surfaceOctonary2,
    this.surfaceOctonary3,
    this.surfaceOctonary4,
    this.surfaceNonary1,
    this.surfaceNonary2,
    this.surfaceNonary3,
    this.surfaceNonary4,
    this.darkAlpha,
    this.whiteAlpha,
    this.successDarkPrimary,
    this.successPrimary,
    this.successSecondary,
    this.successTertiary,
    this.successQuaternary,
    this.successQuinary,
    this.errorDarkPrimary,
    this.errorPrimary,
    this.errorSecondary,
    this.errorTertiary,
    this.errorQuaternary,
    this.errorQuinary,
    this.warningDarkPrimary,
    this.warningPrimary,
    this.warningSecondary,
    this.warningTertiary,
    this.warningQuaternary,
    this.warningQuinary,
    this.cautionDarkPrimary,
    this.cautionPrimary,
    this.cautionSecondary,
    this.cautionTertiary,
    this.cautionQuaternary,
    this.cautionQuinary,
    this.infoDarkPrimary,
    this.infoPrimary,
    this.infoSecondary,
    this.infoTertiary,
    this.infoQuaternary,
    this.infoQuinary,
    this.successAlpha,
    this.errorAlpha,
    this.warningAlpha,
    this.cautionAlpha,
    this.infoAlpha,
  });

  /// Creates a [BrandingColorsDTO] from a JSON
  factory BrandingColorsDTO.fromJson(Map<String, dynamic> json) =>
      BrandingColorsDTO(
        brandGradientStart: json['brandGradientStart'],
        brandGradientEnd: json['brandGradientEnd'],
        brandPrimary: json['brandPrimary'],
        brandSecondary: json['brandSecondary'],
        brandTertiary: json['brandTertiary'],
        basePrimaryWhite: json['basePrimaryWhite'],
        basePrimary: json['basePrimary'],
        baseSecondary: json['baseSecondary'],
        baseTertiary: json['baseTertiary'],
        baseQuaternary: json['baseQuaternary'],
        baseQuinary: json['baseQuinary'],
        baseSenary: json['baseSenary'],
        baseSeptenary: json['baseSeptenary'],
        baseOctonary: json['baseOctonary'],
        baseNonary: json['baseNonary'],
        surfaceSeptenary1: json['surfaceSeptenary1'],
        surfaceSeptenary2: json['surfaceSeptenary2'],
        surfaceSeptenary3: json['surfaceSeptenary3'],
        surfaceSeptenary4: json['surfaceSeptenary4'],
        surfaceOctonary1: json['surfaceOctonary1'],
        surfaceOctonary2: json['surfaceOctonary2'],
        surfaceOctonary3: json['surfaceOctonary3'],
        surfaceOctonary4: json['surfaceOctonary4'],
        surfaceNonary1: json['surfaceNonary1'],
        surfaceNonary2: json['surfaceNonary2'],
        surfaceNonary3: json['surfaceNonary3'],
        surfaceNonary4: json['surfaceNonary4'],
        darkAlpha: json['darkAlpha'],
        whiteAlpha: json['whiteAlpha'],
        successDarkPrimary: json['successDarkPrimary'],
        successPrimary: json['successPrimary'],
        successSecondary: json['successSecondary'],
        successTertiary: json['successTertiary'],
        successQuaternary: json['successQuaternary'],
        successQuinary: json['successQuinary'],
        errorDarkPrimary: json['errorDarkPrimary'],
        errorPrimary: json['errorPrimary'],
        errorSecondary: json['errorSecondary'],
        errorTertiary: json['errorTertiary'],
        errorQuaternary: json['errorQuaternary'],
        errorQuinary: json['errorQuinary'],
        warningDarkPrimary: json['warningDarkPrimary'],
        warningPrimary: json['warningPrimary'],
        warningSecondary: json['warningSecondary'],
        warningTertiary: json['warningTertiary'],
        warningQuaternary: json['warningQuaternary'],
        warningQuinary: json['warningQuinary'],
        cautionDarkPrimary: json['cautionDarkPrimary'],
        cautionPrimary: json['cautionPrimary'],
        cautionSecondary: json['cautionSecondary'],
        cautionTertiary: json['cautionTertiary'],
        cautionQuaternary: json['cautionQuaternary'],
        cautionQuinary: json['cautionQuinary'],
        infoDarkPrimary: json['infoDarkPrimary'],
        infoPrimary: json['infoPrimary'],
        infoSecondary: json['infoSecondary'],
        infoTertiary: json['infoTertiary'],
        infoQuaternary: json['infoQuaternary'],
        infoQuinary: json['infoQuinary'],
        successAlpha: json['successAlpha'],
        errorAlpha: json['errorAlpha'],
        warningAlpha: json['warningAlpha'],
        cautionAlpha: json['cautionAlpha'],
        infoAlpha: json['infoAlpha'],
      );
}

/// The DTO for the theme fonts.
class BrandingFontDTO {
  /// An optional font family to use. Normally null.
  final String? family;

  /// The font size.
  final double? size;

  /// The font weight.
  final int? weight;

  /// The line height as found in Figma (i.e. an absolute value).
  final double? lineHeight;

  /// The letter spacing percentage as found in Figma.
  final double? letterSpacingPercentage;

  /// Creates a new [BrandingFontDTO].
  BrandingFontDTO({
    this.family,
    this.size,
    this.weight,
    this.lineHeight,
    this.letterSpacingPercentage,
  });

  /// Creates a [BrandingFontDTO] from a JSON
  factory BrandingFontDTO.fromJson(Map<String, dynamic> json) =>
      BrandingFontDTO(
        family: json['family'],
        size: JsonParser.parseDouble(json['size']),
        weight: JsonParser.parseInt(json['weight']),
        lineHeight: JsonParser.parseDouble(json['lineHeight']),
        letterSpacingPercentage:
            JsonParser.parseDouble(json['letterSpacingPercentage']),
      );
}
