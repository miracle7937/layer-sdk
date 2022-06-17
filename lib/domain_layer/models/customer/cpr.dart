import 'package:equatable/equatable.dart';

/// Holds the Conflict Prevention and Resolution (CPR) data.
class CPR extends Equatable {
  /// CPR number.
  final String number;

  /// CPR expiration date.
  final DateTime? expiry;

  /// Creates a new [CPR].
  const CPR({
    this.number = '',
    this.expiry,
  });

  @override
  List<Object?> get props => [
        number,
        expiry,
      ];

  /// Returns a copy of the CPR details with select different values.
  CPR copyWith({
    String? number,
    DateTime? expiry,
  }) =>
      CPR(
        number: number ?? this.number,
        expiry: expiry ?? this.expiry,
      );
}
