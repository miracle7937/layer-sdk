import 'package:equatable/equatable.dart';

import '../../models.dart';

/// The current status of the [Account]
enum AccountStatus {
  /// Account is active
  active,

  /// Account is closed
  closed,

  /// Account is dormant
  dormant,

  /// Account is deleted
  deleted,
}

/// Account data used by the application
class Account extends Equatable {
  /// Unique account identifier, SHA-1 of CIF
  final String? id;

  /// The currency used by this account
  final String? currency;

  /// Available balance in the account
  final num? availableBalance;

  /// The current balance of the account
  final num? currentBalance;

  /// Whether the `availableBalance` and `currentBalance` should be shown
  final bool balanceVisible;

  /// The account number of this account
  final String? accountNumber;

  /// The formatted account number
  final String? formattedAccountNumber;

  /// The account number provided in the extra data.
  ///
  /// In cases of some integrations it should be displayed instead of the
  /// [accountNumber].
  final String? extraAccountNumber;

  /// Generic bank defined reference for account
  final String? reference;

  /// The current status of the account
  final AccountStatus? status;

  /// Holds all the information about the account type
  final AccountInfo? accountInfo;

  /// The ID of the branch of this account
  final String? branchId;

  /// The branch ID of this account in the extra
  final String? extraBranchId;

  /// This account's preferences
  final AccountPreferences preferences;

  /// can perform bill payment or do p2p transfers
  final bool canPay;

  /// can transfer within own accounts
  final bool canTransferOwn;

  /// can transfer to other accounts in same bank
  final bool canTransferBank;

  /// can transfer to other banks in same country
  final bool canTransferDomestic;

  /// can transfer to international banks
  final bool canTransferInternational;

  /// can perform bulk transfers
  final bool canTransferBulk;

  /// can cardless withdrawal request
  final bool canTransferCardless;

  /// can receive transfers from anywhere
  final bool canReceiveTransfer;

  /// card can be linked to this account
  final bool canRequestCard;

  /// customer can request checkbooks on this account
  final bool canRequestChkbk;

  /// account is overdraft capable
  final bool canOverdraft;

  /// can perform a remittance payment(bank,cash,or wallet)
  final bool canTransferRemittance;

  /// customer can request banker check
  final bool canRequestBankerCheck;

  /// customer can request offline statement
  final bool canRequestStatement;

  /// customer can request certificate account
  final bool canRequestCertificateOfAccount;

  /// customer can request certificate deposit
  final bool canRequestCertificateOfDeposit;

  /// customer can stop issued check
  bool canStopIssuedCheck = true;

  /// customer can confirm issued check
  bool canConfirmIssuedCheck = true;

  /// Creates a new immutable [Account]
  Account({
    this.id,
    this.currency,
    this.availableBalance,
    this.currentBalance,
    this.balanceVisible = true,
    this.accountNumber,
    this.formattedAccountNumber,
    this.extraAccountNumber,
    this.reference,
    this.status,
    this.accountInfo,
    this.branchId,
    this.extraBranchId,
    this.preferences = const AccountPreferences(),
    this.canPay = true,
    this.canTransferOwn = true,
    this.canTransferBank = true,
    this.canTransferDomestic = true,
    this.canTransferInternational = true,
    this.canTransferBulk = true,
    this.canTransferCardless = true,
    this.canReceiveTransfer = true,
    this.canRequestCard = true,
    this.canRequestChkbk = true,
    this.canOverdraft = true,
    this.canTransferRemittance = true,
    this.canRequestBankerCheck = true,
    this.canRequestStatement = true,
    this.canRequestCertificateOfAccount = true,
    this.canRequestCertificateOfDeposit = true,
    this.canStopIssuedCheck = true,
    this.canConfirmIssuedCheck = true,
  });

  @override
  List<Object?> get props => [
        id,
        currency,
        availableBalance,
        currentBalance,
        balanceVisible,
        accountNumber,
        formattedAccountNumber,
        extraAccountNumber,
        reference,
        status,
        accountInfo,
        branchId,
        extraBranchId,
        preferences,
        canPay,
        canTransferOwn,
        canTransferBank,
        canTransferDomestic,
        canTransferInternational,
        canTransferBulk,
        canTransferCardless,
        canReceiveTransfer,
        canRequestCard,
        canRequestChkbk,
        canOverdraft,
        canTransferRemittance,
        canRequestBankerCheck,
        canRequestStatement,
        canRequestCertificateOfAccount,
        canRequestCertificateOfDeposit,
      ];
}
