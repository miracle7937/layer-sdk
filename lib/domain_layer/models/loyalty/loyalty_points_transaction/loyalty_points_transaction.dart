import 'package:equatable/equatable.dart';

/// Loyalty points transaction type
enum LoyaltyPointsTransactionType {
  /// Earned points
  earn,

  /// Exchanged points
  burn,

  /// Transfered points
  transfer,

  /// Expired points
  expire,

  /// Adjusted points
  adjust,

  /// No type set
  none,
}

/// Contains data for [LoyaltyPointsTransaction]
class LoyaltyPointsTransaction extends Equatable {
  /// Transaction ID
  final String id;

  /// When the transaction was created
  final DateTime? created;

  /// When the transaction was updated
  final DateTime? updated;

  /// Transaction type
  final LoyaltyPointsTransactionType transactionType;

  /// ID of the Loyalty
  final int loyaltyId;

  /// Transfer description
  final String description;

  /// When it was posted
  final DateTime? posted;

  /// When it expire
  final DateTime? expiry;

  /// Transfer amount
  final int amount;

  /// Available balance
  final int balance;

  /// Transaction balance
  final int transactionBalance;

  /// Amount that was redeemed
  final int redemptionAmount;

  /// Account number in which the transfer were redeemed
  final String accountRedeemed;

  /// Exchange rate for this transaction
  final double rate;

  /// Creates a new [LoyaltyPointsTransaction] object
  const LoyaltyPointsTransaction({
    required this.id,
    required this.transactionType,
    required this.loyaltyId,
    required this.description,
    required this.amount,
    required this.balance,
    required this.transactionBalance,
    required this.redemptionAmount,
    required this.accountRedeemed,
    required this.rate,
    this.created,
    this.updated,
    this.posted,
    this.expiry,
  });

  /// Clone this model, but as a different object
  LoyaltyPointsTransaction copyWith({
    String? id,
    DateTime? created,
    DateTime? updated,
    LoyaltyPointsTransactionType? transactionType,
    int? loyaltyId,
    String? description,
    DateTime? posted,
    DateTime? expiry,
    int? amount,
    int? balance,
    int? transactionBalance,
    int? redemptionAmount,
    String? accountRedeemed,
    double? rate,
  }) =>
      LoyaltyPointsTransaction(
        id: id ?? this.id,
        created: created ?? this.created,
        updated: updated ?? this.updated,
        transactionType: transactionType ?? this.transactionType,
        loyaltyId: loyaltyId ?? this.loyaltyId,
        description: description ?? this.description,
        posted: posted ?? this.posted,
        expiry: expiry ?? this.expiry,
        amount: amount ?? this.amount,
        balance: balance ?? this.balance,
        transactionBalance: transactionBalance ?? this.transactionBalance,
        redemptionAmount: redemptionAmount ?? this.redemptionAmount,
        accountRedeemed: accountRedeemed ?? this.accountRedeemed,
        rate: rate ?? this.rate,
      );

  @override
  List<Object?> get props => [
        id,
        created,
        updated,
        transactionType,
        loyaltyId,
        description,
        posted,
        expiry,
        amount,
        balance,
        transactionBalance,
        redemptionAmount,
        accountRedeemed,
        rate,
      ];
}
