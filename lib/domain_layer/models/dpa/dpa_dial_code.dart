import 'package:equatable/equatable.dart';

/// Holds the dial code information of a [DPAVariableDTO]
class DPADialCode extends Equatable {
  /// The dial code
  final String dialCode;

  /// The country name
  final String countryName;

  /// The country code
  final String countryCode;

  /// Creates a new [DPADialCode] instance.
  const DPADialCode({
    this.dialCode = '',
    this.countryName = '',
    this.countryCode = '',
  });

  @override
  List<Object> get props => [
        dialCode,
        countryName,
        countryCode,
      ];

  /// Creates a new [DPADialCode] with the provided params.
  DPADialCode copyWith({
    String? dialCode,
    String? countryName,
    String? countryCode,
    String? icon,
  }) {
    return DPADialCode(
      dialCode: dialCode ?? this.dialCode,
      countryName: countryName ?? this.countryName,
      countryCode: countryCode ?? this.countryCode,
    );
  }
}
