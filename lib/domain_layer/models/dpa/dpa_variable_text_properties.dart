import 'package:equatable/equatable.dart';

/// The available text styles for a dpa variable.
enum DPAVariableTextStyle {
  /// Title XXXL
  titleXXXL,

  /// Title XXL
  titleXXL,

  /// Title XL
  titleXL,

  /// Title L
  titleL,

  /// Title M
  titleM,

  /// Title S
  titleS,

  /// Title XS
  titleXS,

  /// Body XXL
  bodyXXL,

  /// Body XL
  bodyXL,

  /// Body L
  bodyL,

  /// Body M
  bodyM,

  /// Body S
  bodyS,

  /// Body XS
  bodyXS,

  /// Button M
  buttonM,

  /// Button S
  buttonS,
}

/// Model that represents the text properties for a variable.
class DPAVariableTextProperties extends Equatable {
  /// The string hex color.
  final String? color;

  /// The text style.
  final DPAVariableTextStyle? textStyle;

  /// Creates a new [DPAVariableTextProperties].
  const DPAVariableTextProperties({
    this.color,
    this.textStyle,
  });

  @override
  List<Object?> get props => [
        color,
        textStyle,
      ];
}
