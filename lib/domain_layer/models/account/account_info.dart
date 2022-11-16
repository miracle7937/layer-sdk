import 'package:equatable/equatable.dart';

/// The account type type
enum AccountType {
  /// Currency account type
  current,

  /// Term Deposit account type
  termDeposit,

  /// Credit Card account type
  creditCard,

  /// Loan account type
  loan,

  /// Securities account type
  securities,

  /// Finance (islamic) account type
  finance,

  /// Savings account type
  savings,

  /// Trade finance account type
  tradeFinance,
}

/// Holds all the account type info
class AccountInfo extends Equatable {
  /// The type of the account
  ///
  /// See [AccountType] for more details
  final AccountType? accountType;

  /// The family of the account
  final String? family;

  /// The short account name
  final String? accountName;

  /// The account description or long name
  final String? accountDescription;

  /// Customer can transfer cardless
  ///
  /// Defaults to `true`
  final bool canTransferCardless;

  /// Customer can stop issued check
  ///
  /// Defaults to `true`
  final bool canStopIssuedCheck;

  /// Customer has iban
  ///
  /// Defaults to `false`
  final bool hasIban;

  /// Customer can confirm issued check
  ///
  /// Defaults to `true`
  final bool canConfirmIssuedCheck;

  /// Whether if the account type can pay or not.
  final bool canPay;

  /// Whether if the account type can transfer own accounts.
  final bool canTransferOwn;

  /// Whether if the account type can transfer bank.
  final bool canTransferBank;

  /// Whether if the account type can transfer domestic.
  final bool canTransferDomestic;

  /// Whether if the account type can transfer international.
  final bool canTransferInternational;

  /// Whether if the account type can receive transfers.
  final bool canReceiveTransfer;

  /// Creates a new instance of [AccountInfo]
  const AccountInfo({
    this.accountType,
    this.family,
    this.accountName,
    this.accountDescription,
    this.hasIban = false,
    this.canTransferCardless = true,
    this.canConfirmIssuedCheck = true,
    this.canStopIssuedCheck = true,
    this.canPay = true,
    this.canTransferOwn = true,
    this.canTransferBank = true,
    this.canTransferDomestic = true,
    this.canTransferInternational = true,
    this.canReceiveTransfer = true,
  });

  @override
  List<Object?> get props => [
        accountType,
        family,
        accountName,
        accountDescription,
        hasIban,
        canTransferCardless,
        canConfirmIssuedCheck,
        canStopIssuedCheck,
        canPay,
        canTransferOwn,
        canTransferBank,
        canTransferDomestic,
        canTransferInternational,
        canReceiveTransfer,
      ];
}
