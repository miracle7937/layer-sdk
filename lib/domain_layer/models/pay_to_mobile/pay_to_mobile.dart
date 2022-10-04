import 'package:equatable/equatable.dart';

import '../../models.dart';

/// Model representing a pay to mobile element.
class PayToMobile extends Equatable {
  /// Source account.
  final Account? account;

  /// Destination phone number.
  final String? toMobile;

  /// The request type.
  final PayToMobileRequestType? requestType;

  /// The amount.
  final double? amount;

  /// The currency code.
  final String? currencyCode;

  /// The pay to mobile status.
  final PayToMobileStatus? status;

  /// The withdrawal code generated by the service.
  final String? withdrawalCode;

  /// The transaction code generated by the user.
  final String? transactionCode;

  /// The second factor method used.
  final SecondFactorType? secondFactorType;

  /// Created time of the request.
  final DateTime? created;

  /// Creates a new [PayToMobile].
  PayToMobile({
    this.account,
    this.toMobile,
    this.requestType,
    this.amount,
    this.currencyCode,
    this.status,
    this.withdrawalCode,
    this.transactionCode,
    this.secondFactorType,
    this.created,
  });

  @override
  List<Object?> get props => [
        account,
        toMobile,
        requestType,
        amount,
        currencyCode,
        status,
        withdrawalCode,
        transactionCode,
        secondFactorType,
        created,
      ];
}
