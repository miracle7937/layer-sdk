/// The account type DTO represents an account type
/// as configured by the bank on the console
class AccountTypeDTO {
  /// unique account type identifier
  String? id;

  /// The type of the account type. see [AccountTypeDTOType]
  AccountTypeDTOType? type;

  /// The category of the account type. see [AccountCategory]
  AccountCategory? category;

  /// pointer to local short account name
  String? name;

  /// pointer to local account description or long name
  String? description;

  /// the account family this type belongs too
  String? family;

  /// URL to card bitmap image 96x96
  String? imageUrl;

  /// can perform bill payment or do p2p transfers
  bool canPay = true;

  /// can transfer within own accounts
  bool canTransferOwn = true;

  /// can transfer to other accounts in same bank
  bool canTransferBank = true;

  /// can transfer to other banks in same country
  bool canTransferDomestic = true;

  /// can transfer to international banks
  bool canTransferInternational = true;

  /// can perform bulk transfers
  bool canTransferBulk = true;

  /// can cardless withdrawal request
  bool canTransferCardless = true;

  /// can receive transfers from anywhere
  bool canReceiveTransfer = true;

  /// card can be linked to this account
  bool canRequestCard = true;

  /// customer can request checkbooks on this account
  bool canRequestChkbk = true;

  /// account is overdraft capable
  bool canOverdraft = true;

  /// can perform a remittance payment(bank,cash,or wallet)
  bool canTransferRemittance = true;

  /// customer can request banker check
  bool canRequestBankerCheck = true;

  /// customer can request offline statement
  bool canRequestStatement = true;

  /// customer can request certificate account
  bool canRequestCertificateOfAccount = true;

  /// customer can request certificate deposit
  bool canRequestCertificateOfDeposit = true;

  /// customer can p2p (wallet)
  bool canP2P = true;

  /// account type is displayed on client
  bool visible = true;

  /// customer can stop issued check
  bool canStopIssuedCheck = true;

  /// customer has iban
  bool hasIban = false;

  /// customer can confirm issued check
  bool canConfirmIssuedCheck = true;

  /// Creates a new [AccountTypeDTO]
  AccountTypeDTO({
    this.id,
    this.type,
    this.category,
    this.imageUrl,
    this.description,
    this.name,
    this.family,
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
    this.canP2P = true,
    this.visible = true,
    this.canStopIssuedCheck = true,
    this.hasIban = false,
    this.canConfirmIssuedCheck = true,
  });

  /// Creates a [AccountTypeDTO] from a JSON
  factory AccountTypeDTO.fromJson(Map<String, dynamic> json) {
    return AccountTypeDTO(
      id: json['account_type_id'],
      name: json['name'],
      family: json['family'],
      type: AccountTypeDTOType.values[json['type']],
      category: AccountCategory.values[json['category']],
      description: json['description'],
      canTransferOwn: json['can_trf_internal'] ?? true,
      canTransferBank: json['can_trf_bank'] ?? true,
      canTransferDomestic: json['can_trf_domestic'] ?? true,
      canTransferInternational: json['can_trf_intl'] ?? true,
      canTransferBulk: json['can_trf_bulk'] ?? true,
      canTransferCardless: json['can_trf_cardless'] ?? true,
      canReceiveTransfer: json['can_receive_trf'] ?? true,
      canOverdraft: json['can_overdraft'] ?? true,
      canPay: json['can_pay'] ?? true,
      canRequestChkbk: json['can_request_chkbk'] ?? true,
      canTransferRemittance: json['can_trf_remittance'] ?? true,
      visible: json['visible'] ?? true,
      imageUrl: json['image_url'],
      canRequestCard: json['can_request_card'] ?? true,
      canP2P: json['can_p2p'] ?? true,
      canRequestBankerCheck: json['can_request_banker_check'] ?? true,
      canRequestStatement: json['can_request_stmt'] ?? true,
      canRequestCertificateOfAccount: json['can_request_cert_account'] ?? true,
      canRequestCertificateOfDeposit: json['can_request_cert_deposit'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    var json = <String, dynamic>{
      'account_type_id': id,
      'type': type?.index,
      'category': category?.index,
      'name': name,
      'description': description,
      'can_pay': canPay,
      'can_trf_internal': canTransferOwn,
      'can_trf_bank': canTransferBank,
      'can_trf_domestic': canTransferDomestic,
      'can_trf_intl': canTransferInternational,
      'can_trf_bulk': canTransferBulk,
      'can_receive_trf': canReceiveTransfer,
      'can_trf_cardless': canTransferCardless,
      'can_overdraft': canOverdraft,
      'can_trf_remittance': canTransferRemittance,
      'can_request_card': canRequestCard,
      'can_request_chkbk': canRequestChkbk,
      'can_p2p': canP2P,
      'visible': visible,
      'can_request_banker_check': canRequestBankerCheck,
      'can_request_stmt': canRequestStatement,
      'can_request_cert_account': canRequestCertificateOfAccount,
      'can_request_cert_deposit': canRequestCertificateOfDeposit,
      "can_stop_issued_check": canStopIssuedCheck,
      "can_confirm_issued_check": canConfirmIssuedCheck,
      "has_iban": hasIban,
    };
    return json;
  }
}

/// Account category
enum AccountCategory {
  /// Asset account
  asset,

  /// Liability account
  liability,

  /// Virtual account
  virtual,
}

/// The account type type
enum AccountTypeDTOType {
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
