import 'package:equatable/equatable.dart';

/// Loyalty Status
enum LoyaltyStatus {
  /// Status active
  active,

  /// Loyalty deleted
  deleted,
}

/// Data class for loyalty points
class Loyalty extends Equatable {
  /// Loyalty ID
  final int id;

  /// When it was created
  final DateTime? created;

  /// Last time it was updated
  final DateTime? updated;

  /// Loyalty Status
  final LoyaltyStatus status;

  /// Available balance points
  final int balance;

  /// Available earned points
  final int earned;

  /// The amount of points that a user has spent
  final int burned;

  /// Available transferred loyalty points
  final int transferred;

  /// Adjusted loyalty points
  final int adjusted;

  /// Date of last transaction made
  final DateTime? lastTransactionDate;

  /// Exchange rate
  final double rate;

  /// Points that will expire in a certain date
  final int dueExpiryPoints;

  /// Create a [Loyalty] object
  const Loyalty({
    required this.id,
    this.status = LoyaltyStatus.active,
    this.balance = 0,
    this.earned = 0,
    this.burned = 0,
    this.transferred = 0,
    this.adjusted = 0,
    this.rate = 1,
    this.dueExpiryPoints = 0,
    this.created,
    this.updated,
    this.lastTransactionDate,
  });

  @override
  List<Object?> get props {
    return [
      id,
      created,
      updated,
      status,
      balance,
      earned,
      burned,
      transferred,
      adjusted,
      lastTransactionDate,
      rate,
      dueExpiryPoints,
    ];
  }

  /// Clone this model, but as a different object
  Loyalty copyWith({
    int? id,
    DateTime? created,
    DateTime? updated,
    LoyaltyStatus? status,
    int? balance,
    int? earned,
    int? burned,
    int? transferred,
    int? adjusted,
    DateTime? lastTransactionDate,
    double? rate,
    int? dueExpiryPoints,
  }) {
    return Loyalty(
      id: id ?? this.id,
      created: created ?? this.created,
      updated: updated ?? this.updated,
      status: status ?? this.status,
      balance: balance ?? this.balance,
      earned: earned ?? this.earned,
      burned: burned ?? this.burned,
      transferred: transferred ?? this.transferred,
      adjusted: adjusted ?? this.adjusted,
      lastTransactionDate: lastTransactionDate ?? this.lastTransactionDate,
      rate: rate ?? this.rate,
      dueExpiryPoints: dueExpiryPoints ?? this.dueExpiryPoints,
    );
  }
}
