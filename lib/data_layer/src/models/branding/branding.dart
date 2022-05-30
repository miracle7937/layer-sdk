import 'package:equatable/equatable.dart';

import '../../../models.dart';

/// Holds the data used for the branding of the app.
class Branding extends Equatable {
  /// The logo URL.
  ///
  /// Can be null, in which case the default logo should be used.
  final String? logoURL;

  /// The logo svg as a `String`.
  ///
  /// Can be null, in which case the default logo should be used.
  final String? logo;

  /// The colors for the light theme.
  ///
  /// Can be null, in which case the default colors will be used.
  final BrandingColors? lightColors;

  /// The colors for the dark theme.
  ///
  /// Can be null, in which case the default colors will be used.
  final BrandingColors? darkColors;

  /// The default font family to use for this brand.
  ///
  /// Can be null.
  final String? defaultFontFamily;

  /// The fonts used by this branding.
  final BrandingFonts fonts;

  /// Creates a new [Branding].
  const Branding({
    this.logoURL,
    this.logo,
    this.lightColors,
    this.darkColors,
    this.defaultFontFamily,
    this.fonts = const BrandingFonts(),
  });

  @override
  List<Object?> get props => [
        logoURL,
        logo,
        lightColors,
        darkColors,
        defaultFontFamily,
        fonts,
      ];

  /// Creates a new [Branding] based on this one.
  Branding copyWith({
    String? logoURL,
    String? logo,
    BrandingColors? lightColors,
    BrandingColors? darkColors,
    String? defaultFontFamily,
    BrandingFonts? fonts,
  }) =>
      Branding(
        logoURL: logoURL ?? this.logoURL,
        logo: logo ?? this.logo,
        lightColors: lightColors ?? this.lightColors,
        darkColors: darkColors ?? this.darkColors,
        defaultFontFamily: defaultFontFamily ?? this.defaultFontFamily,
        fonts: fonts ?? this.fonts,
      );
}
