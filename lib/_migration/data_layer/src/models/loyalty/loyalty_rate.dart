import 'package:equatable/equatable.dart';

/// Container for reading exchange rate for loyalty points
class LoyaltyRate extends Equatable {
  /// Rate ID
  final String id;

  /// Date of creation
  final DateTime? createdAt;

  /// Date when the record was updated
  final DateTime? updatedAt;

  /// Date when the rate start
  final DateTime? startDate;

  /// Rate amount
  final num rate;

  ///[LoyaltyRate] constructor
  const LoyaltyRate({
    required this.id,
    required this.rate,
    this.startDate,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        createdAt,
        updatedAt,
        startDate,
        rate,
      ];

  ///Clone and return a new [LoyaltyRate] object
  LoyaltyRate copyWith({
    String? id,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? startDate,
    num? rate,
  }) {
    return LoyaltyRate(
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      startDate: startDate ?? this.startDate,
      rate: rate ?? this.rate,
    );
  }
}
