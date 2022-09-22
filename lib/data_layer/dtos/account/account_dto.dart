import 'package:collection/collection.dart';

import '../../dtos.dart';
import '../../extensions.dart';
import '../../helpers.dart';

/// The account DTO represents a customers account
/// as provided by the infobanking service
class AccountDTO {
  /// Unique account identifier, SHA-1 of CIF
  String? accountId;

  /// The customer id associated with this account.
  String? customerId;

  /// Date when account entry was created
  DateTime? created;

  /// Date when account was last updated
  DateTime? updated;

  /// Account type [AccountTypeDTO]
  AccountTypeDTO? type;

  /// 3-letter ISO currency code
  String? currency;

  /// The Joint type of the account
  JointTypeDTO? jointType;

  /// Generic bank defined reference for account
  String? reference;

  /// Available balance in account
  double? availableBalance;

  /// current balance in account
  double? currentBalance;

  /// If the [availableBalance] and [currentBalance] should be shown
  bool balanceVisible;

  /// status of account
  AccountDTOStatus? status;

  /// date account was opened in the branch
  DateTime? opened;

  /// date when account was synced with core banking system
  DateTime? synced;

  /// can perform bill payment or do p2p transfers
  bool canPay;

  /// can transfer within own accounts
  bool canTransferOwn;

  /// can transfer to other accounts in same bank
  bool canTransferBank;

  /// can transfer to other banks in same country
  bool canTransferDomestic;

  /// can transfer to international banks
  bool canTransferInternational;

  /// can perform bulk transfers
  bool canTransferBulk;

  /// can cardless withdrawal request
  bool canTransferCardless;

  /// can receive transfers from anywhere
  bool canReceiveTransfer;

  /// card can be linked to this account
  bool canRequestCard;

  /// customer can request checkbooks on this account
  bool canRequestChkbk;

  /// account is overdraft capable
  bool canOverdraft;

  /// can perform a remittance payment(bank,cash,or wallet)
  bool canTransferRemittance;

  /// customer can request banker check
  bool canRequestBankerCheck;

  /// customer can request offline statement
  bool canRequestStatement;

  /// customer can request certificate account
  bool canRequestCertificateOfAccount;

  /// customer can request certificate deposit
  bool canRequestCertificateOfDeposit;

  /// customer can stop issued check
  bool canStopIssuedCheck;

  /// customer can confirm issued check
  bool canConfirmIssuedCheck;

  /// generic account number
  String? accountNumber;

  /// The account number provided in the `extra`
  String? extraAccountNumber;

  /// account number formatted
  String? displayAccountNumber;

  /// The branch ID of this account
  String? branchId;

  /// The branch ID of this account in the extra
  String? extraBranchId;

  /// The preferences for this account.
  AccountPreferencesDTO? preferences;

  /// The iban of this account;
  final String? iban;

  /// Creates a new [AccountDTO]
  AccountDTO({
    this.accountId,
    this.customerId,
    this.created,
    this.updated,
    this.type,
    this.currency,
    this.jointType,
    this.reference,
    this.availableBalance,
    this.currentBalance,
    this.balanceVisible = true,
    this.status,
    this.opened,
    this.synced,
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
    this.canRequestStatement = true,
    this.canRequestBankerCheck = true,
    this.canRequestCertificateOfAccount = true,
    this.canRequestCertificateOfDeposit = true,
    this.canStopIssuedCheck = true,
    this.canConfirmIssuedCheck = true,
    this.accountNumber,
    this.extraAccountNumber,
    this.displayAccountNumber,
    this.branchId,
    this.extraBranchId,
    this.preferences,
    this.iban,
  });

  /// Creates a [AccountDTO] from a JSON
  factory AccountDTO.fromJson(Map<String, dynamic> json) {
    return AccountDTO(
      accountId: json['account_id'],
      customerId: json['customer_id'],
      created: JsonParser.parseDate(json['ts_created']),
      updated: JsonParser.parseDate(json['ts_updated']),
      type: json['account_type'] != null
          ? AccountTypeDTO.fromJson(json['account_type'])
          : null,
      currency: json['currency'],
      jointType: JointTypeDTO.fromRaw(json['joint_type']),
      reference: json['reference'],
      availableBalance: json['balance_available'] is num
          ? JsonParser.parseDouble(json['balance_available'])
          : 0.0,
      currentBalance: json['balance_current'] is num
          ? JsonParser.parseDouble(json['balance_current'])
          : 0.0,
      balanceVisible: !(json['balance_available'] is String &&
              json['balance_available'].toLowerCase().contains('x')) &&
          !(json['balance_current'] is String &&
              json['balance_current'].toLowerCase().contains('x')),
      status: AccountDTOStatus.fromRaw(json['status']),
      opened: JsonParser.parseDate(json['ts_opened']),
      synced: JsonParser.parseDate(json['ts_synced']),
      canPay: json['can_pay'] ?? true,
      canTransferOwn: json['can_trf_internal'] ?? true,
      canTransferBank: json['can_trf_bank'] ?? true,
      canTransferDomestic: json['can_trf_domestic'] ?? true,
      canTransferInternational: json['can_trf_intl'] ?? true,
      canTransferBulk: json['can_trf_bulk'] ?? true,
      canTransferCardless: json['can_trf_cardless'] ?? true,
      canReceiveTransfer: json['can_receive_trf'] ?? true,
      canRequestChkbk: json['can_request_chkbk'] ?? true,
      canTransferRemittance: json['can_trf_remittance'] ?? true,
      canOverdraft: json['can_overdraft'] ?? true,
      canRequestCard: json['can_request_card'] ?? true,
      canRequestBankerCheck: json['can_request_banker_check'] ?? true,
      canRequestStatement: json['can_request_stmt'] ?? true,
      canRequestCertificateOfAccount: json['can_request_cert_account'] ?? true,
      canRequestCertificateOfDeposit: json['can_request_cert_deposit'] ?? true,
      canStopIssuedCheck: json["can_stop_issued_check"] ?? true,
      canConfirmIssuedCheck: json["can_confirm_issued_check"] ?? true,
      accountNumber: json['account_no'],
      displayAccountNumber: json['account_no_displayed'],
      extraAccountNumber:
          json['extra'] != null ? json['extra']['account_number'] : null,
      branchId: json['branch_id'],
      extraBranchId: (json['branch'] as Map?)
          ?.lookup<dynamic, String>(['location_id'])?.toString(),
      preferences: AccountPreferencesDTO.fromJson(json),
      iban: json['iban'],
    );
  }

  /// To json function
  Map<String, dynamic> toJson() {
    var json = <String, dynamic>{
      'account_id': accountId,
      'account_type_id': type?.id,
      'branch_id': branchId,
      'currency': currency,
      'joint_type': jointType?.value,
      'balance_available': availableBalance,
      'balance_current': currentBalance,
      'status': status?.value,
      "can_pay": canPay,
      "can_trf_internal": canTransferOwn,
      "can_trf_bank": canTransferBank,
      "can_trf_domestic": canTransferDomestic,
      "can_trf_intl": canTransferInternational,
      "can_trf_bulk": canTransferBulk,
      "can_receive_trf": canReceiveTransfer,
      "can_trf_cardless": canTransferCardless,
      'can_overdraft': canOverdraft,
      'can_request_card': canRequestCard,
      'can_request_chkbk': canRequestChkbk,
      'can_trf_remittance': canTransferRemittance,
      'can_p2p': type?.canP2P,
      "account_no": accountNumber,
      "account_no_displayed": displayAccountNumber,
      "can_request_banker_check": canRequestBankerCheck,
      "can_request_stmt": canRequestStatement,
      "can_request_cert_account": canRequestCertificateOfAccount,
      "can_request_cert_deposit": canRequestCertificateOfDeposit,
      "can_stop_issued_check": canStopIssuedCheck,
      "can_confirm_issued_check": canConfirmIssuedCheck,
      'account_type': type?.toJson(),
      "has_iban": type?.hasIban,
      "iban": iban,
    };
    return json;
  }

  /// Creates a list of [AccountDTO] from a list
  static List<AccountDTO> fromJsonList(List<Map<String, dynamic>> json) =>
      json.map(AccountDTO.fromJson).toList(growable: false);

  /// Return account with same type as the type passed
  factory AccountDTO.withType(AccountTypeDTOType type) {
    return AccountDTO(
      type: AccountTypeDTO(
        type: type,
      ),
    );
  }
}

/// The joint type of an account
class JointTypeDTO extends EnumDTO {
  /// Joint type single
  static const single = JointTypeDTO._internal('S');

  /// AND joint type
  static const and = JointTypeDTO._internal('A');

  /// AND/OR joint type
  static const andOr = JointTypeDTO._internal('O');

  /// List of all possible joint types
  static const List<JointTypeDTO> values = [single, and, andOr];

  const JointTypeDTO._internal(String value) : super.internal(value);

  /// Convert string to [JointTypeDTO]
  static JointTypeDTO? fromRaw(String? raw) => values.firstWhereOrNull(
        (val) => val.value == raw,
      );
}

/// The status of an account
class AccountDTOStatus extends EnumDTO {
  /// active status
  static const active = AccountDTOStatus._internal('A');

  /// dormant status
  static const dormant = AccountDTOStatus._internal('O');

  /// closed status
  static const closed = AccountDTOStatus._internal('C');

  /// deleted status
  static const deleted = AccountDTOStatus._internal('D');

  /// List of all possible account status
  static const List<AccountDTOStatus> values = [
    active,
    dormant,
    closed,
    deleted
  ];

  const AccountDTOStatus._internal(String value) : super.internal(value);

  /// Convert string to [AccountDTOStatus]
  static AccountDTOStatus? fromRaw(String? raw) => values.firstWhereOrNull(
        (val) => val.value == raw,
      );
}
