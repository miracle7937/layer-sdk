class PrefAlert {
  PrefAlert({
    required this.key,
    required this.label,
    this.enabled = false,
  });

  String key;
  String label;
  bool enabled;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PrefAlert &&
          runtimeType == other.runtimeType &&
          key == other.key &&
          label == other.label &&
          enabled == other.enabled;
}

class PrefAlerts {
  PrefAlerts({
    bool transaction = false,
    bool payment = false,
    bool transfer = false,
    bool wallet = false,
    bool walletTransaction = false,
    bool recurringTransfer = false,
    bool lowBalance = false,
    bool loanReminder = false,
    bool cardReminder = false,
    bool internationalBeneficiary = false,
    bool request = false,
    bool inbox = false,
    bool safeToSpend = false,
    bool appointmentReminder = false,
    bool vault = false,
    bool topup = false,
    bool c2cTransfer = false,
    bool wpsTransfer = false,
    bool bulkRegister = false,
    bool message = false,
    bool dpa = false,
    bool claims = false,
    bool bulkTransfer = false,
    bool goal = false,
    bool scheduledTransfer = false,
    bool campaign = false,
    bool loyalty = false,
    bool cardExpiry = false,
    bool receivedSendMoney = false,
    bool termDepositReminder = false,
    bool offerForMe = false,
    bool cashbackEarned = false,
    bool cashbackExpiryReminder = false,
    bool discountOfferForMe = false,
    bool loanPaymentExpired = false,
    bool cardControl = false,
    bool idExpiryReminded = false,
  }) {
    this.transaction.enabled = transaction;
    this.payment.enabled = payment;
    this.transfer.enabled = transfer;
    this.wallet.enabled = wallet;
    this.walletTransaction.enabled = walletTransaction;
    this.recurringTransfer.enabled = recurringTransfer;
    this.lowBalance.enabled = lowBalance;
    this.loanReminder.enabled = loanReminder;
    this.cardReminder.enabled = cardReminder;
    this.internationalBeneficiary.enabled = internationalBeneficiary;
    this.request.enabled = request;
    this.inbox.enabled = inbox;
    this.safeToSpend.enabled = safeToSpend;
    this.appointmentReminder.enabled = appointmentReminder;
    this.vault.enabled = vault;
    this.topup.enabled = topup;
    this.c2cTransfer.enabled = c2cTransfer;
    this.wpsTransfer.enabled = wpsTransfer;
    this.bulkRegister.enabled = bulkRegister;
    this.dpa.enabled = dpa;
    this.claims.enabled = claims;
    this.bulkTransfer.enabled = bulkTransfer;
    this.goal.enabled = goal;
    this.scheduledTransfer.enabled = scheduledTransfer;
    this.campaign.enabled = campaign;
    this.loyalty.enabled = loyalty;
    this.cardExpiry.enabled = cardExpiry;
    this.receivedSendMoney.enabled = receivedSendMoney;
    this.termDepositReminder.enabled = termDepositReminder;
    this.cashbackEarned.enabled = cashbackEarned;
    this.offerForMe.enabled = offerForMe;
    this.cashbackExpiryReminder.enabled = cashbackExpiryReminder;
    this.discountOfferForMe.enabled = discountOfferForMe;
    this.loanPaymentExpired.enabled = loanPaymentExpired;
    this.cardControl.enabled = cardControl;
    this.idExpiryReminded.enabled = idExpiryReminded;
  }

  final PrefAlert transaction =
      PrefAlert(key: 'transaction', label: 'transaction');
  final PrefAlert payment = PrefAlert(key: 'payment', label: 'payment');
  final PrefAlert transfer = PrefAlert(key: 'transfer', label: 'transfer');
  final PrefAlert wallet = PrefAlert(key: 'wallet', label: 'wallet');
  final PrefAlert walletTransaction =
      PrefAlert(key: 'wallet_transaction', label: 'wallet_transaction');
  final PrefAlert recurringTransfer =
      PrefAlert(key: 'recurring_transfer', label: 'recurring_transfer');
  final PrefAlert lowBalance =
      PrefAlert(key: 'low_balance', label: 'low_balance');
  final PrefAlert loanReminder =
      PrefAlert(key: 'loan_reminder', label: 'loan_reminder');
  final PrefAlert cardReminder =
      PrefAlert(key: 'card_reminder', label: 'card_reminder');
  final PrefAlert internationalBeneficiary = PrefAlert(
      key: 'international_beneficiary', label: 'international_beneficiary');
  final PrefAlert request = PrefAlert(key: 'request', label: 'requests');
  final PrefAlert inbox = PrefAlert(key: 'inbox', label: 'messages');
  final PrefAlert safeToSpend =
      PrefAlert(key: 'safe_to_spend', label: 'safe_to_spend');
  final PrefAlert appointmentReminder =
      PrefAlert(key: 'appointment_reminder', label: 'appointment_reminder');
  final PrefAlert vault = PrefAlert(key: 'vault', label: 'vault');
  final PrefAlert topup = PrefAlert(key: 'topup', label: 'topup');
  final PrefAlert c2cTransfer =
      PrefAlert(key: 'c2c_transfer', label: 'instant_debid_card_transfer');
  final PrefAlert wpsTransfer =
      PrefAlert(key: 'wps_transfer', label: 'wps_transfer');
  final PrefAlert bulkRegister =
      PrefAlert(key: 'bulk_register', label: 'bulk_register');
  final PrefAlert dpa = PrefAlert(key: 'dpa', label: 'products_requests');
  final PrefAlert claims = PrefAlert(key: 'claims', label: 'claims');
  final PrefAlert bulkTransfer =
      PrefAlert(key: 'bulk_transfer', label: 'bulk_transfer');
  final PrefAlert goal = PrefAlert(key: 'goal', label: 'goal_alerts');
  final PrefAlert scheduledTransfer =
      PrefAlert(key: 'scheduled_transfer', label: 'scheduled_transfer');
  final PrefAlert campaign = PrefAlert(key: 'campaign', label: 'offers_alerts');
  final PrefAlert loyalty = PrefAlert(key: 'loyalty', label: 'loyalty');
  final PrefAlert cardExpiry =
      PrefAlert(key: 'card_expiry', label: 'card_expiry_reminder');
  final PrefAlert receivedSendMoney =
      PrefAlert(key: 'received_send_money', label: 'money_to_mobile_requests');

  final PrefAlert termDepositReminder = PrefAlert(
    key: 'term_deposit_reminder',
    label: 'term_deposit_reminder',
  );

  final PrefAlert cashbackEarned =
      PrefAlert(key: 'cashback_earned', label: 'cashback_earned');
  final PrefAlert offerForMe =
      PrefAlert(key: 'offer_for_me', label: 'offer_for_me');

  final PrefAlert cashbackExpiryReminder = PrefAlert(
      key: 'cashback_expiry_reminder', label: 'cashback_expiry_reminder');
  final PrefAlert discountOfferForMe =
      PrefAlert(key: 'discount_offer_for_me', label: 'discount_offer_for_me');
  final PrefAlert loanPaymentExpired =
      PrefAlert(key: 'loan_payment_expired', label: 'loan_payment_expired');
  final PrefAlert cardControl = PrefAlert(
    key: 'card_control',
    label: 'card_control',
  );
  final PrefAlert idExpiryReminded =
      PrefAlert(key: 'id_expiry_reminder', label: 'id_expiry_reminder');

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PrefAlerts &&
          runtimeType == other.runtimeType &&
          transaction == other.transaction &&
          payment == other.payment &&
          transfer == other.transfer &&
          wallet == other.wallet &&
          walletTransaction == other.walletTransaction &&
          recurringTransfer == other.recurringTransfer &&
          lowBalance == other.lowBalance &&
          loanReminder == other.loanReminder &&
          cardReminder == other.cardReminder &&
          internationalBeneficiary == other.internationalBeneficiary &&
          request == other.request &&
          inbox == other.inbox &&
          safeToSpend == other.safeToSpend &&
          appointmentReminder == other.appointmentReminder &&
          vault == other.vault &&
          c2cTransfer == other.c2cTransfer &&
          topup == other.topup &&
          wpsTransfer == other.wpsTransfer &&
          bulkRegister == other.bulkRegister &&
          dpa == other.dpa &&
          claims == other.claims &&
          bulkTransfer == other.bulkTransfer &&
          goal == other.goal &&
          scheduledTransfer == other.scheduledTransfer &&
          campaign == other.campaign &&
          loyalty == other.loyalty &&
          cardExpiry == other.cardExpiry &&
          receivedSendMoney == other.receivedSendMoney &&
          termDepositReminder == other.termDepositReminder &&
          cashbackEarned == other.cashbackEarned &&
          offerForMe == other.offerForMe &&
          cashbackExpiryReminder == other.cashbackExpiryReminder &&
          discountOfferForMe == other.discountOfferForMe &&
          loanPaymentExpired == other.loanPaymentExpired &&
          cardControl == other.cardControl &&
          idExpiryReminded == other.idExpiryReminded;

  // ads

  List<PrefAlert> get alertTypes => [
        transaction,
        payment,
        transfer,
        wallet,
        walletTransaction,
        recurringTransfer,
        lowBalance,
        loanReminder,
        cardReminder,
        internationalBeneficiary,
        request,
        inbox,
        safeToSpend,
        appointmentReminder,
        vault,
        topup,
        c2cTransfer,
        wpsTransfer,
        bulkRegister,
        dpa,
        claims,
        bulkTransfer,
        goal,
        scheduledTransfer,
        campaign,
        loyalty,
        cardExpiry,
        receivedSendMoney,
        termDepositReminder,
        cashbackEarned,
        offerForMe,
        cashbackExpiryReminder,
        discountOfferForMe,
        loanPaymentExpired,
        cardControl,
        idExpiryReminded,
      ];

  PrefAlerts.fromJson(List? alerts) {
    alertTypes.forEach((pref) {
      pref.enabled = alerts!.contains(pref.key);
    });
  }

  List<String> toJson() {
    List<String> list = [];
    alertTypes.forEach((pref) {
      if (pref.enabled) list.add(pref.key);
    });
    return list;
  }

  PrefAlerts copyWith({
    bool? transaction,
    bool? payment,
    bool? transfer,
    bool? wallet,
    bool? walletTransaction,
    bool? recurringTransfer,
    bool? lowBalance,
    bool? loanReminder,
    bool? cardReminder,
    bool? internationalBeneficiary,
    bool? request,
    bool? inbox,
    bool? safeToSpend,
    bool? appointmentReminder,
    bool? vault,
    bool? topup,
    bool? c2cTransfer,
    bool? wpsTransfer,
    bool? bulkRegister,
    bool? message,
    bool? dpa,
    bool? claims,
    bool? bulkTransfer,
    bool? goal,
    bool? scheduledTransfer,
    bool? campaign,
    bool? loyalty,
    bool? cardExpiry,
    bool? receivedSendMoney,
    bool? termDepositReminder,
    bool? offerForMe,
    bool? cashbackEarned,
    bool? cashbackExpiryReminder,
    bool? discountOfferForMe,
    bool? loanPaymentExpired,
    bool? cardControl,
    bool? idExpiryReminded,
  }) {
    return PrefAlerts(
      transaction: transaction ?? this.transaction.enabled,
      payment: payment ?? this.payment.enabled,
      transfer: transfer ?? this.transfer.enabled,
      wallet: wallet ?? this.wallet.enabled,
      walletTransaction: walletTransaction ?? this.walletTransaction.enabled,
      recurringTransfer: recurringTransfer ?? this.recurringTransfer.enabled,
      lowBalance: lowBalance ?? this.lowBalance.enabled,
      loanReminder: loanReminder ?? this.loanReminder.enabled,
      cardReminder: cardReminder ?? this.cardReminder.enabled,
      internationalBeneficiary:
          internationalBeneficiary ?? this.internationalBeneficiary.enabled,
      request: request ?? this.request.enabled,
      inbox: inbox ?? this.inbox.enabled,
      safeToSpend: safeToSpend ?? this.safeToSpend.enabled,
      appointmentReminder:
          appointmentReminder ?? this.appointmentReminder.enabled,
      vault: vault ?? this.vault.enabled,
      topup: topup ?? this.topup.enabled,
      c2cTransfer: c2cTransfer ?? this.c2cTransfer.enabled,
      wpsTransfer: wpsTransfer ?? this.wpsTransfer.enabled,
      bulkRegister: bulkRegister ?? this.bulkRegister.enabled,
      dpa: dpa ?? this.dpa.enabled,
      claims: claims ?? this.claims.enabled,
      bulkTransfer: bulkTransfer ?? this.bulkTransfer.enabled,
      goal: goal ?? this.goal.enabled,
      scheduledTransfer: scheduledTransfer ?? this.scheduledTransfer.enabled,
      campaign: campaign ?? this.campaign.enabled,
      loyalty: loyalty ?? this.loyalty.enabled,
      cardExpiry: cardExpiry ?? this.cardExpiry.enabled,
      receivedSendMoney: receivedSendMoney ?? this.receivedSendMoney.enabled,
      termDepositReminder:
          termDepositReminder ?? this.termDepositReminder.enabled,
      cashbackEarned: cashbackEarned ?? this.cashbackEarned.enabled,
      offerForMe: offerForMe ?? this.offerForMe.enabled,
      cashbackExpiryReminder:
          cashbackExpiryReminder ?? this.cashbackExpiryReminder.enabled,
      discountOfferForMe: discountOfferForMe ?? this.discountOfferForMe.enabled,
      loanPaymentExpired: loanPaymentExpired ?? this.loanPaymentExpired.enabled,
      cardControl: cardControl ?? this.cardControl.enabled,
      idExpiryReminded: idExpiryReminded ?? this.idExpiryReminded.enabled,
    );
  }
}
