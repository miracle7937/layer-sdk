import 'package:equatable/equatable.dart';

/// The theme colors, as defined on the backend.
class BrandingColors extends Equatable {
  /// Hex value for brand gradient start.
  final int? brandGradientStart;

  /// Hex value for brand gradient end.
  final int? brandGradientEnd;

  /// Hex value for brand primary color.
  final int? brandPrimary;

  /// Hex value for brand secondary color.
  final int? brandSecondary;

  /// Hex value for brand tertiary color.
  final int? brandTertiary;

  /// Hex value for base primary white.
  final int? basePrimaryWhite;

  /// Hex value for base primary color.
  final int? basePrimary;

  /// Hex value for base secondary color.
  final int? baseSecondary;

  /// Hex value for base tertiary color.
  final int? baseTertiary;

  /// Hex value for base quaternary color.
  final int? baseQuaternary;

  /// Hex value for base quinary color.
  final int? baseQuinary;

  /// Hex value for base senary color.
  final int? baseSenary;

  /// Hex value for base septenary color.
  final int? baseSeptenary;

  /// Hex value for base octonary color.
  final int? baseOctonary;

  /// Hex value for base nonary color.
  final int? baseNonary;

  /// Hex value for surface septenary 1 color.
  final int? surfaceSeptenary1;

  /// Hex value for surface septenary 2 color.
  final int? surfaceSeptenary2;

  /// Hex value for surface septenary 3 color.
  final int? surfaceSeptenary3;

  /// Hex value for surface septenary 4 color.
  final int? surfaceSeptenary4;

  /// Hex value for surface octonary 1 color.
  final int? surfaceOctonary1;

  /// Hex value for surface octonary 2 color.
  final int? surfaceOctonary2;

  /// Hex value for surface octonary 3 color.
  final int? surfaceOctonary3;

  /// Hex value for surface octonary 4 color.
  final int? surfaceOctonary4;

  /// Hex value for surface nonary 1 color.
  final int? surfaceNonary1;

  /// Hex value for surface nonary 2 color.
  final int? surfaceNonary2;

  /// Hex value for surface nonary 3 color.
  final int? surfaceNonary3;

  /// Hex value for surface nonary 4 color.
  final int? surfaceNonary4;

  /// Hex value for the dark alpha base color.
  final int? darkAlpha;

  /// Hex value for the white alpha base color.
  final int? whiteAlpha;

  /// Hex value for the primary dark success color.
  final int? successDarkPrimary;

  /// Hex value for the primary success color.
  final int? successPrimary;

  /// Hex value for the secondary success color.
  final int? successSecondary;

  /// Hex value for the tertiary success color.
  final int? successTertiary;

  /// Hex value for the quaternary success color.
  final int? successQuaternary;

  /// Hex value for the quinary success color.
  final int? successQuinary;

  /// Hex value for the primary dark error color.
  final int? errorDarkPrimary;

  /// Hex value for the primary error color.
  final int? errorPrimary;

  /// Hex value for the secondary error color.
  final int? errorSecondary;

  /// Hex value for the tertiary error color.
  final int? errorTertiary;

  /// Hex value for the quaternary error color.
  final int? errorQuaternary;

  /// Hex value for the quinary error color.
  final int? errorQuinary;

  /// Hex value for the dark primary warning color.
  final int? warningDarkPrimary;

  /// Hex value for the primary warning color.
  final int? warningPrimary;

  /// Hex value for the secondary warning color.
  final int? warningSecondary;

  /// Hex value for the tertiary warning color.
  final int? warningTertiary;

  /// Hex value for the quaternary warning color.
  final int? warningQuaternary;

  /// Hex value for the quinary warning color.
  final int? warningQuinary;

  /// Hex value for the dark primary caution color.
  final int? cautionDarkPrimary;

  /// Hex value for the primary caution color.
  final int? cautionPrimary;

  /// Hex value for the secondary caution color.
  final int? cautionSecondary;

  /// Hex value for the tertiary caution color.
  final int? cautionTertiary;

  /// Hex value for the quaternary caution color.
  final int? cautionQuaternary;

  /// Hex value for the quinary caution color.
  final int? cautionQuinary;

  /// Hex value for the dark primary info color.
  final int? infoDarkPrimary;

  /// Hex value for the primary info color.
  final int? infoPrimary;

  /// Hex value for the secondary info color.
  final int? infoSecondary;

  /// Hex value for the tertiary info color.
  final int? infoTertiary;

  /// Hex value for the quaternary info color.
  final int? infoQuaternary;

  /// Hex value for the quinary info color.
  final int? infoQuinary;

  /// Hex value for the success alpha color.
  final int? successAlpha;

  /// Hex value for the error alpha color.
  final int? errorAlpha;

  /// Hex value for the warning alpha color.
  final int? warningAlpha;

  /// Hex value for the caution alpha color.
  final int? cautionAlpha;

  /// Hex value for the info alpha color.
  final int? infoAlpha;

  /// Creates a new [BrandingColors].
  const BrandingColors({
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

  @override
  List<Object?> get props => [
        brandGradientStart,
        brandGradientEnd,
        brandPrimary,
        brandSecondary,
        brandTertiary,
        basePrimaryWhite,
        basePrimary,
        baseSecondary,
        baseTertiary,
        baseQuaternary,
        baseQuinary,
        baseSenary,
        baseSeptenary,
        baseOctonary,
        baseNonary,
        surfaceSeptenary1,
        surfaceSeptenary2,
        surfaceSeptenary3,
        surfaceSeptenary4,
        surfaceOctonary1,
        surfaceOctonary2,
        surfaceOctonary3,
        surfaceOctonary4,
        surfaceNonary1,
        surfaceNonary2,
        surfaceNonary3,
        surfaceNonary4,
        darkAlpha,
        whiteAlpha,
        successDarkPrimary,
        successPrimary,
        successSecondary,
        successTertiary,
        successQuaternary,
        successQuinary,
        errorDarkPrimary,
        errorPrimary,
        errorSecondary,
        errorTertiary,
        errorQuaternary,
        errorQuinary,
        warningDarkPrimary,
        warningPrimary,
        warningSecondary,
        warningTertiary,
        warningQuaternary,
        warningQuinary,
        cautionDarkPrimary,
        cautionPrimary,
        cautionSecondary,
        cautionTertiary,
        cautionQuaternary,
        cautionQuinary,
        infoDarkPrimary,
        infoPrimary,
        infoSecondary,
        infoTertiary,
        infoQuaternary,
        infoQuinary,
        successAlpha,
        errorAlpha,
        warningAlpha,
        cautionAlpha,
        infoAlpha,
      ];

  /// Creates a new [BrandingColors] based on this one.
  BrandingColors copyWith({
    int? brandGradientStart,
    int? brandGradientEnd,
    int? brandPrimary,
    int? brandSecondary,
    int? brandTertiary,
    int? basePrimaryWhite,
    int? basePrimary,
    int? baseSecondary,
    int? baseTertiary,
    int? baseQuaternary,
    int? baseQuinary,
    int? baseSenary,
    int? baseSeptenary,
    int? baseOctonary,
    int? baseNonary,
    int? surfaceSeptenary1,
    int? surfaceSeptenary2,
    int? surfaceSeptenary3,
    int? surfaceSeptenary4,
    int? surfaceOctonary1,
    int? surfaceOctonary2,
    int? surfaceOctonary3,
    int? surfaceOctonary4,
    int? surfaceNonary1,
    int? surfaceNonary2,
    int? surfaceNonary3,
    int? surfaceNonary4,
    int? darkAlpha,
    int? whiteAlpha,
    int? successDarkPrimary,
    int? successPrimary,
    int? successSecondary,
    int? successTertiary,
    int? successQuaternary,
    int? successQuinary,
    int? errorDarkPrimary,
    int? errorPrimary,
    int? errorSecondary,
    int? errorTertiary,
    int? errorQuaternary,
    int? errorQuinary,
    int? warningDarkPrimary,
    int? warningPrimary,
    int? warningSecondary,
    int? warningTertiary,
    int? warningQuaternary,
    int? warningQuinary,
    int? cautionDarkPrimary,
    int? cautionPrimary,
    int? cautionSecondary,
    int? cautionTertiary,
    int? cautionQuaternary,
    int? cautionQuinary,
    int? infoDarkPrimary,
    int? infoPrimary,
    int? infoSecondary,
    int? infoTertiary,
    int? infoQuaternary,
    int? infoQuinary,
    int? successAlpha,
    int? errorAlpha,
    int? warningAlpha,
    int? cautionAlpha,
    int? infoAlpha,
  }) =>
      BrandingColors(
        brandGradientStart: brandGradientStart ?? this.brandGradientStart,
        brandGradientEnd: brandGradientEnd ?? this.brandGradientEnd,
        brandPrimary: brandPrimary ?? this.brandPrimary,
        brandSecondary: brandSecondary ?? this.brandSecondary,
        brandTertiary: brandTertiary ?? this.brandTertiary,
        basePrimaryWhite: basePrimaryWhite ?? this.basePrimaryWhite,
        basePrimary: basePrimary ?? this.basePrimary,
        baseSecondary: baseSecondary ?? this.baseSecondary,
        baseTertiary: baseTertiary ?? this.baseTertiary,
        baseQuaternary: baseQuaternary ?? this.baseQuaternary,
        baseQuinary: baseQuinary ?? this.baseQuinary,
        baseSenary: baseSenary ?? this.baseSenary,
        baseSeptenary: baseSeptenary ?? this.baseSeptenary,
        baseOctonary: baseOctonary ?? this.baseOctonary,
        baseNonary: baseNonary ?? this.baseNonary,
        surfaceSeptenary1: surfaceSeptenary1 ?? this.surfaceSeptenary1,
        surfaceSeptenary2: surfaceSeptenary2 ?? this.surfaceSeptenary2,
        surfaceSeptenary3: surfaceSeptenary3 ?? this.surfaceSeptenary3,
        surfaceSeptenary4: surfaceSeptenary4 ?? this.surfaceSeptenary4,
        surfaceOctonary1: surfaceOctonary1 ?? this.surfaceOctonary1,
        surfaceOctonary2: surfaceOctonary2 ?? this.surfaceOctonary2,
        surfaceOctonary3: surfaceOctonary3 ?? this.surfaceOctonary3,
        surfaceOctonary4: surfaceOctonary4 ?? this.surfaceOctonary4,
        surfaceNonary1: surfaceNonary1 ?? this.surfaceNonary1,
        surfaceNonary2: surfaceNonary2 ?? this.surfaceNonary2,
        surfaceNonary3: surfaceNonary3 ?? this.surfaceNonary3,
        surfaceNonary4: surfaceNonary4 ?? this.surfaceNonary4,
        darkAlpha: darkAlpha ?? this.darkAlpha,
        whiteAlpha: whiteAlpha ?? this.whiteAlpha,
        successDarkPrimary: successDarkPrimary ?? this.successDarkPrimary,
        successPrimary: successPrimary ?? this.successPrimary,
        successSecondary: successSecondary ?? this.successSecondary,
        successTertiary: successTertiary ?? this.successTertiary,
        successQuaternary: successQuaternary ?? this.successQuaternary,
        successQuinary: successQuinary ?? this.successQuinary,
        errorDarkPrimary: errorDarkPrimary ?? this.errorDarkPrimary,
        errorPrimary: errorPrimary ?? this.errorPrimary,
        errorSecondary: errorSecondary ?? this.errorSecondary,
        errorTertiary: errorTertiary ?? this.errorTertiary,
        errorQuaternary: errorQuaternary ?? this.errorQuaternary,
        errorQuinary: errorQuinary ?? this.errorQuinary,
        warningDarkPrimary: warningDarkPrimary ?? this.warningDarkPrimary,
        warningPrimary: warningPrimary ?? this.warningPrimary,
        warningSecondary: warningSecondary ?? this.warningSecondary,
        warningTertiary: warningTertiary ?? this.warningTertiary,
        warningQuaternary: warningQuaternary ?? this.warningQuaternary,
        warningQuinary: warningQuinary ?? this.warningQuinary,
        cautionDarkPrimary: cautionDarkPrimary ?? this.cautionDarkPrimary,
        cautionPrimary: cautionPrimary ?? this.cautionPrimary,
        cautionSecondary: cautionSecondary ?? this.cautionSecondary,
        cautionTertiary: cautionTertiary ?? this.cautionTertiary,
        cautionQuaternary: cautionQuaternary ?? this.cautionQuaternary,
        cautionQuinary: cautionQuinary ?? this.cautionQuinary,
        infoDarkPrimary: infoDarkPrimary ?? this.infoDarkPrimary,
        infoPrimary: infoPrimary ?? this.infoPrimary,
        infoSecondary: infoSecondary ?? this.infoSecondary,
        infoTertiary: infoTertiary ?? this.infoTertiary,
        infoQuaternary: infoQuaternary ?? this.infoQuaternary,
        infoQuinary: infoQuinary ?? this.infoQuinary,
        successAlpha: successAlpha ?? this.successAlpha,
        errorAlpha: errorAlpha ?? this.errorAlpha,
        warningAlpha: warningAlpha ?? this.warningAlpha,
        cautionAlpha: cautionAlpha ?? this.cautionAlpha,
        infoAlpha: infoAlpha ?? this.infoAlpha,
      );
}
