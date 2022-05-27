import 'dart:ui' as ui show TextHeightBehavior;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:layer_sdk/business_layer/business_layer.dart';

// TODO: add CurrencyText tests.
/// Text widget that formats and displays the currency amount given.
///
/// Depends on the [CurrencyCubit] being available on the tree.
///
/// Example:
///
/// ```dart
///   return CurrencyText(
///     3000.0,
///     currencyCode: 'USD',
///     overflow: TextOverflow.ellipsis,
///     textAlign: TextAlign.right,
///   );
/// ```
class CurrencyText extends StatelessWidget {
  /// The amount to display.
  final double? amount;

  /// If it should display the currency symbol.
  ///
  /// Defaults to `true`.
  final bool withSymbol;

  /// The optional case-insensitive currency code to use. If provided and the
  /// currency is not available on the currency cubit, paints the empty string.
  final String? currencyCode;

  /// Optional number of decimal positions to use. If not provided, uses the
  /// default from the provided [currencyCode], and if even this is not
  /// available, uses the default from the current locale.
  final int? decimals;

  /// The [customPattern] parameter can be used to specify a particular
  /// format. This is useful if you have your own locale data which includes
  /// unsupported formats (e.g. accounting format for currencies.)
  ///
  /// For more information, please look at:
  /// https://api.flutter.dev/flutter/intl/NumberFormat-class.html
  ///
  /// For instance, you could use '\u00a4 #,###.#;\u00a4 -#,###.#' to have
  /// two formats: the first for positive values, and the second for negative
  /// ones. The positive would present like `USD 1,23,45.00`.
  final String? customPattern;

  /// The text to display if the amount is null.
  ///
  /// Defaults to an empty string.
  final String textIfNull;

  /// If non-null, the style to use for this text.
  ///
  /// If the style's "inherit" property is true, the style will be merged with
  /// the closest enclosing [DefaultTextStyle]. Otherwise, the style will
  /// replace the closest enclosing [DefaultTextStyle].
  final TextStyle? style;

  /// {@macro flutter.painting.textPainter.strutStyle}
  final StrutStyle? strutStyle;

  /// How the text should be aligned horizontally.
  final TextAlign? textAlign;

  /// The directionality of the text.
  ///
  /// This decides how [textAlign] values like [TextAlign.start] and
  /// [TextAlign.end] are interpreted.
  ///
  /// This is also used to disambiguate how to render bidirectional text. For
  /// example, if the [data] is an English phrase followed by a Hebrew phrase,
  /// in a [TextDirection.ltr] context the English phrase will be on the left
  /// and the Hebrew phrase to its right, while in a [TextDirection.rtl]
  /// context, the English phrase will be on the right and the Hebrew phrase on
  /// its left.
  ///
  /// Defaults to the ambient [Directionality], if any.
  final TextDirection? textDirection;

  /// Used to select a font when the same Unicode character can
  /// be rendered differently, depending on the locale.
  ///
  /// It's rarely necessary to set this property. By default its value
  /// is inherited from the enclosing app with
  /// `Localizations.localeOf(context)`.
  ///
  /// See [RenderParagraph.locale] for more information.
  final Locale? locale;

  /// Whether the text should break at soft line breaks.
  ///
  /// If false, the glyphs in the text will be positioned as if there was
  /// unlimited horizontal space.
  final bool? softWrap;

  /// How visual overflow should be handled.
  ///
  /// Defaults to retrieving the value from the nearest [DefaultTextStyle]
  /// ancestor.
  final TextOverflow? overflow;

  /// The number of font pixels for each logical pixel.
  ///
  /// For example, if the text scale factor is 1.5, text will be 50% larger than
  /// the specified font size.
  ///
  /// The value given to the constructor as textScaleFactor. If null, will
  /// use the [MediaQueryData.textScaleFactor] obtained from the ambient
  /// [MediaQuery], or 1.0 if there is no [MediaQuery] in scope.
  final double? textScaleFactor;

  /// An optional maximum number of lines for the text to span, wrapping if
  /// necessary.
  /// If the text exceeds the given number of lines, it will be truncated
  /// according to [overflow].
  ///
  /// If this is 1, text will not wrap. Otherwise, text will be wrapped at the
  /// edge of the box.
  final int? maxLines;

  /// An alternative semantics label for this text.
  ///
  /// If present, the semantics of this widget will contain this value instead
  /// of the actual text. This will overwrite any of the semantics labels
  /// applied directly to the [TextSpan]s.
  ///
  /// This is useful for replacing abbreviations or shorthands with the full
  /// text value:
  ///
  /// ```dart
  /// Text(r'$$', semanticsLabel: 'Double dollars')
  /// ```
  final String? semanticsLabel;

  /// {@macro flutter.painting.textPainter.textWidthBasis}
  final TextWidthBasis? textWidthBasis;

  /// {@macro flutter.dart:ui.textHeightBehavior}
  final ui.TextHeightBehavior? textHeightBehavior;

  /// Creates a new [CurrencyText].
  const CurrencyText(
    this.amount, {
    Key? key,
    this.withSymbol = true,
    this.currencyCode,
    this.decimals,
    this.customPattern,
    this.textIfNull = '',
    this.style,
    this.strutStyle,
    this.textAlign,
    this.textDirection,
    this.locale,
    this.softWrap,
    this.overflow,
    this.textScaleFactor,
    this.maxLines,
    this.semanticsLabel,
    this.textWidthBasis,
    this.textHeightBehavior,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currencyCubit = context.watch<CurrencyCubit>();

    return Text(
      currencyCubit.formatCurrency(
            value: amount,
            withSymbol: withSymbol,
            currencyCode: currencyCode,
            decimals: decimals,
            locale: locale?.toString(),
            customPattern: customPattern,
          ) ??
          textIfNull,
      style: style,
      strutStyle: strutStyle,
      textAlign: textAlign,
      textDirection: textDirection,
      locale: locale,
      softWrap: softWrap,
      overflow: overflow,
      textScaleFactor: textScaleFactor,
      maxLines: maxLines,
      semanticsLabel: semanticsLabel,
      textWidthBasis: textWidthBasis,
      textHeightBehavior: textHeightBehavior,
    );
  }
}
