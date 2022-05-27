import 'package:equatable/equatable.dart';

/// Holds the Iqama data.
class Iqama extends Equatable {
  /// Iqama number.
  final String number;

  /// Iqama expiration date.
  final DateTime? expiry;

  /// Creates a new [Iqama].
  const Iqama({
    this.number = '',
    this.expiry,
  });

  @override
  List<Object?> get props => [
        number,
        expiry,
      ];

  /// Returns a copy of the Iqama details with select different values.
  Iqama copyWith({
    String? number,
    DateTime? expiry,
  }) =>
      Iqama(
        number: number ?? this.number,
        expiry: expiry ?? this.expiry,
      );
}
