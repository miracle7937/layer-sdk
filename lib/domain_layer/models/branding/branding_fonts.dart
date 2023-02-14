import 'package:equatable/equatable.dart';

/// Holds all the font definitions for a branding.
// TODO: CONSOLE SPECIFIC
class BrandingFonts extends Equatable {
  /// The base title XXXL style.
  final BrandingFont? baseTitleXXXL;

  /// The base title XXL style.
  final BrandingFont? baseTitleXXL;

  /// The base title XL style.
  final BrandingFont? baseTitleXL;

  /// The base title L style.
  final BrandingFont? baseTitleL;

  /// The base title M style.
  final BrandingFont? baseTitleM;

  /// The base title S style.
  final BrandingFont? baseTitleS;

  /// The base title XS style.
  final BrandingFont? baseTitleXS;

  /// The base Body XXL style.
  final BrandingFont? baseBodyXXL;

  /// The base Body XL style.
  final BrandingFont? baseBodyXL;

  /// The base Body L style.
  final BrandingFont? baseBodyL;

  /// The base Body M style.
  final BrandingFont? baseBodyM;

  /// The base Body S style.
  final BrandingFont? baseBodyS;

  /// The base Body XS style.
  final BrandingFont? baseBodyXS;

  /// The base Button M style.
  final BrandingFont? baseButtonM;

  /// The base Button S style.
  final BrandingFont? baseButtonS;

  /// Creates a new [BrandingFonts].
  const BrandingFonts({
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

  @override
  List<Object?> get props => [
        baseTitleXXXL,
        baseTitleXXL,
        baseTitleXL,
        baseTitleL,
        baseTitleM,
        baseTitleS,
        baseTitleXS,
        baseBodyXXL,
        baseBodyXL,
        baseBodyL,
        baseBodyM,
        baseBodyS,
        baseBodyXS,
        baseButtonM,
        baseButtonS,
      ];

  /// Creates a new [BrandingFonts] based on this one.
  BrandingFonts copyWith({
    BrandingFont? baseTitleXXXL,
    BrandingFont? baseTitleXXL,
    BrandingFont? baseTitleXL,
    BrandingFont? baseTitleL,
    BrandingFont? baseTitleM,
    BrandingFont? baseTitleS,
    BrandingFont? baseTitleXS,
    BrandingFont? baseBodyXXL,
    BrandingFont? baseBodyXL,
    BrandingFont? baseBodyL,
    BrandingFont? baseBodyM,
    BrandingFont? baseBodyS,
    BrandingFont? baseBodyXS,
    BrandingFont? baseButtonM,
    BrandingFont? baseButtonS,
  }) =>
      BrandingFonts(
        baseTitleXXXL: baseTitleXXXL ?? this.baseTitleXXXL,
        baseTitleXXL: baseTitleXXL ?? this.baseTitleXXL,
        baseTitleXL: baseTitleXL ?? this.baseTitleXL,
        baseTitleL: baseTitleL ?? this.baseTitleL,
        baseTitleM: baseTitleM ?? this.baseTitleM,
        baseTitleS: baseTitleS ?? this.baseTitleS,
        baseTitleXS: baseTitleXS ?? this.baseTitleXS,
        baseBodyXXL: baseBodyXXL ?? this.baseBodyXXL,
        baseBodyXL: baseBodyXL ?? this.baseBodyXL,
        baseBodyL: baseBodyL ?? this.baseBodyL,
        baseBodyM: baseBodyM ?? this.baseBodyM,
        baseBodyS: baseBodyS ?? this.baseBodyS,
        baseBodyXS: baseBodyXS ?? this.baseBodyXS,
        baseButtonM: baseButtonM ?? this.baseButtonM,
        baseButtonS: baseButtonS ?? this.baseButtonS,
      );
}

/// The theme fonts, as defined on the backend.
class BrandingFont extends Equatable {
  /// An optional font family to use. Normally null.
  final String? family;

  /// The font size.
  final double? size;

  /// The font weight.
  final int? weight;

  /// The line height as found in Figma (i.e. an absolute value).
  final double? lineHeight;

  /// The letter spacing percentage (example: `0.5%` would be `0.5`).
  final double? letterSpacingPercentage;

  /// Creates a new [BrandingFont].
  const BrandingFont({
    this.family,
    this.size,
    this.weight,
    this.lineHeight,
    this.letterSpacingPercentage,
  });

  @override
  List<Object?> get props => [
        family,
        size,
        weight,
        lineHeight,
        letterSpacingPercentage,
      ];

  /// Creates a new [BrandingFont] based on this one.
  BrandingFont copyWith({
    String? family,
    double? size,
    int? weight,
    double? lineHeight,
    double? letterSpacingPercentage,
  }) =>
      BrandingFont(
        family: family ?? this.family,
        size: size ?? this.size,
        weight: weight ?? this.weight,
        lineHeight: lineHeight ?? this.lineHeight,
        letterSpacingPercentage:
            letterSpacingPercentage ?? this.letterSpacingPercentage,
      );
}
