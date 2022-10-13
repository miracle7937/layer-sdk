import '../../../domain_layer/models.dart';
import '../../dtos.dart';
import '../../errors.dart';
import '../../mappings.dart';

/// Extension that provides mappings for [ActivityDTO]
extension ActivityDTOMapping on ActivityDTO {
  /// Maps into a [Activity]
  Activity toActivity(DPAMappingCustomData customData) => Activity(
        id: id ?? '',
        itemId: itemId,
        item: _itemDTOToModel(customData),
        status: status ?? '',
        message: message ?? '',
        alertID: alertID ?? 0,
        tsUpdated: tsUpdated ?? DateTime.now(),
        read: read ?? false,
        type: type?.toType(),
        actions: actions?.map((e) => e.toActivityActionType()).toList(),
      );

  dynamic _itemDTOToModel(DPAMappingCustomData customData) {
    switch (type) {
      case ActivityTypeDTO.dpa:
        return (item as DPATaskDTO).toDPATask(customData);

      case ActivityTypeDTO.transfer:
      case ActivityTypeDTO.scheduledTransfer:
      case ActivityTypeDTO.recurringTransfer:
        return (item as TransferDTO).toTransfer();

      case ActivityTypeDTO.payment:
      case ActivityTypeDTO.scheduledPayment:
      case ActivityTypeDTO.recurringPayment:
      case ActivityTypeDTO.topupPayment:
      case ActivityTypeDTO.scheduledTopup:
      case ActivityTypeDTO.recurringTopup:
        return (item as PaymentDTO).toPayment();

      case ActivityTypeDTO.sendMoney:
        return (item as PayToMobileDTO).toPayToMobile();

      default:
        return item;
    }
  }
}

/// Extension that provides mappings for [ActivityTypeDTO]
extension ActivityTypeDTOMapping on ActivityTypeDTO {
  /// Maps into a [ActivityType]
  ActivityType toType() {
    switch (this) {
      case ActivityTypeDTO.appointmentReminder:
        return ActivityType.appointmentReminder;

      case ActivityTypeDTO.bankRemittance:
        return ActivityType.bankRemittance;

      case ActivityTypeDTO.benefitGw:
        return ActivityType.benefitGw;

      case ActivityTypeDTO.benefitPay:
        return ActivityType.benefitPay;

      case ActivityTypeDTO.bulkRegister:
        return ActivityType.bulkRegister;

      case ActivityTypeDTO.bulkTransfer:
        return ActivityType.bulkTransfer;

      case ActivityTypeDTO.c2cTransfer:
        return ActivityType.c2CTransfer;

      case ActivityTypeDTO.campaign:
        return ActivityType.campaign;

      case ActivityTypeDTO.cardControl:
        return ActivityType.cardControl;

      case ActivityTypeDTO.cardTopup:
        return ActivityType.cardTopUp;

      case ActivityTypeDTO.cardExpiry:
        return ActivityType.cardExpiry;

      case ActivityTypeDTO.cardReminder:
        return ActivityType.cardReminder;

      case ActivityTypeDTO.cashRemittance:
        return ActivityType.cashRemittance;

      case ActivityTypeDTO.cashbackEarned:
        return ActivityType.cashbackEarned;

      case ActivityTypeDTO.cashbackExpiryReminder:
        return ActivityType.cashbackExpiryReminder;

      case ActivityTypeDTO.cashinPayment:
        return ActivityType.cashinPayment;

      case ActivityTypeDTO.cashinTransfer:
        return ActivityType.cashinTransfer;

      case ActivityTypeDTO.cashoutPayment:
        return ActivityType.cashoutPayment;

      case ActivityTypeDTO.cashoutTransfer:
        return ActivityType.cashoutTransfer;

      case ActivityTypeDTO.checkbook:
        return ActivityType.checkbook;

      case ActivityTypeDTO.claims:
        return ActivityType.claims;

      case ActivityTypeDTO.debitPayment:
        return ActivityType.debitPayment;

      case ActivityTypeDTO.discountOfferForMe:
        return ActivityType.discountOfferForMe;

      case ActivityTypeDTO.dpa:
        return ActivityType.dpa;

      case ActivityTypeDTO.fromMobileTransfer:
        return ActivityType.fromMobileTransfer;

      case ActivityTypeDTO.goal:
        return ActivityType.goal;

      case ActivityTypeDTO.goalTransactions:
        return ActivityType.goalTransactions;

      case ActivityTypeDTO.idExpiryReminder:
        return ActivityType.idExpiryReminder;

      case ActivityTypeDTO.inbox:
        return ActivityType.inbox;

      case ActivityTypeDTO.insufficientBalance:
        return ActivityType.insufficientBalance;

      case ActivityTypeDTO.internationalBeneficiary:
        return ActivityType.internationalBeneficiary;

      case ActivityTypeDTO.issuedCheck:
        return ActivityType.issuedCheck;

      case ActivityTypeDTO.loanPaymentExpired:
        return ActivityType.loanPaymentExpired;

      case ActivityTypeDTO.loanReminder:
        return ActivityType.loanReminder;

      case ActivityTypeDTO.lowBalance:
        return ActivityType.lowBalance;

      case ActivityTypeDTO.loyalty:
        return ActivityType.loyalty;

      case ActivityTypeDTO.merchantTransfer:
        return ActivityType.merchantTransfer;

      case ActivityTypeDTO.message:
        return ActivityType.message;

      case ActivityTypeDTO.offerForMe:
        return ActivityType.offerForMe;

      case ActivityTypeDTO.payment:
        return ActivityType.payment;

      case ActivityTypeDTO.pennyBankTransactions:
        return ActivityType.pennyBankTransactions;

      case ActivityTypeDTO.pullPayment:
        return ActivityType.pullPayment;

      case ActivityTypeDTO.receivedSendMoney:
        return ActivityType.receivedSendMoney;

      case ActivityTypeDTO.recurringPayment:
        return ActivityType.recurringPayment;

      case ActivityTypeDTO.recurringTopup:
        return ActivityType.recurringTopup;

      case ActivityTypeDTO.recurringTransfer:
        return ActivityType.recurringTransfer;

      case ActivityTypeDTO.request:
        return ActivityType.request;

      case ActivityTypeDTO.requestPayment:
        return ActivityType.requestPayment;

      case ActivityTypeDTO.safeToSpend:
        return ActivityType.safeToSpend;

      case ActivityTypeDTO.scheduledPayment:
        return ActivityType.scheduledPayment;

      case ActivityTypeDTO.scheduledTopup:
        return ActivityType.scheduledTopup;

      case ActivityTypeDTO.scheduledTransfer:
        return ActivityType.scheduledTransfer;

      case ActivityTypeDTO.sendMoney:
        return ActivityType.sendMoney;

      case ActivityTypeDTO.termDepositReminder:
        return ActivityType.termDepositReminder;

      case ActivityTypeDTO.topup:
        return ActivityType.topup;

      case ActivityTypeDTO.topupPayment:
        return ActivityType.topupPayment;

      case ActivityTypeDTO.transaction:
        return ActivityType.transaction;

      case ActivityTypeDTO.transfer:
        return ActivityType.transfer;

      case ActivityTypeDTO.unknown:
        return ActivityType.unknown;

      case ActivityTypeDTO.vault:
        return ActivityType.vault;

      case ActivityTypeDTO.wallet:
        return ActivityType.wallet;

      case ActivityTypeDTO.walletPayment:
        return ActivityType.walletPayment;

      case ActivityTypeDTO.walletRemittance:
        return ActivityType.walletRemittance;

      case ActivityTypeDTO.wpsTransfer:
        return ActivityType.wpsTransfer;

      default:
        throw MappingException(from: ActivityTypeDTO, to: ActivityType);
    }
  }
}

/// Extension that provides mappings for [ActivityActionTypeDTO]
extension ActivityActionTypeDTOMapping on ActivityActionTypeDTO {
  /// Maps into a [ActivityActionType]
  ActivityActionType toActivityActionType() {
    switch (this) {
      case ActivityActionTypeDTO.addToShortcut:
        return ActivityActionType.addToShortcut;

      case ActivityActionTypeDTO.approve:
        return ActivityActionType.approve;

      case ActivityActionTypeDTO.cancel:
        return ActivityActionType.cancel;

      case ActivityActionTypeDTO.cancelAppointment:
        return ActivityActionType.cancelAppointment;

      case ActivityActionTypeDTO.cancelRecurringPayment:
        return ActivityActionType.cancelRecurringPayment;

      case ActivityActionTypeDTO.cancelRecurringTransfer:
        return ActivityActionType.cancelRecurringTransfer;

      case ActivityActionTypeDTO.cancelSendMoney:
        return ActivityActionType.cancelSendMoney;

      case ActivityActionTypeDTO.collectToOwn:
        return ActivityActionType.collectToOwn;

      case ActivityActionTypeDTO.continueProcess:
        return ActivityActionType.continueProcess;

      case ActivityActionTypeDTO.delete:
        return ActivityActionType.delete;

      case ActivityActionTypeDTO.deleteAlert:
        return ActivityActionType.deleteAlert;

      case ActivityActionTypeDTO.editAppointment:
        return ActivityActionType.editAppointment;

      case ActivityActionTypeDTO.patchPayment:
        return ActivityActionType.patchPayment;

      case ActivityActionTypeDTO.patchTransfer:
        return ActivityActionType.patchTransfer;

      case ActivityActionTypeDTO.reject:
        return ActivityActionType.reject;

      case ActivityActionTypeDTO.renewal:
        return ActivityActionType.renewal;

      case ActivityActionTypeDTO.repeatAction:
        return ActivityActionType.repeatAction;

      case ActivityActionTypeDTO.sendToBeneficiary:
        return ActivityActionType.sendToBeneficiary;

      case ActivityActionTypeDTO.unknown:
        return ActivityActionType.unknown;

      case ActivityActionTypeDTO.resendWithdrawalCode:
        return ActivityActionType.resendWithdrawalCode;

      case ActivityActionTypeDTO.shareTransactionCode:
        return ActivityActionType.shareTransactionCode;

      default:
        throw MappingException(
          from: ActivityActionTypeDTO,
          to: ActivityActionType,
        );
    }
  }
}

/// Extension that provides mappings for [ActivityType]
extension ActivityTypeMapping on ActivityType {
  /// Maps into String that represents the [ActivityType]
  String get toJSONString {
    switch (this) {
      case ActivityType.appointmentReminder:
        return 'appointment_reminder';

      case ActivityType.bankRemittance:
        return 'bank_remittance';

      case ActivityType.benefitGw:
        return 'benefit_gw';

      case ActivityType.benefitPay:
        return 'benefit_pay';

      case ActivityType.bulkRegister:
        return 'bulk_register';

      case ActivityType.bulkTransfer:
        return 'bulk_transfer';

      case ActivityType.c2CTransfer:
        return 'c2c_transfer';

      case ActivityType.campaign:
        return 'campaign';

      case ActivityType.cardTopUp:
        return 'stripe_topup';

      case ActivityType.cardControl:
        return 'card_control';

      case ActivityType.cardExpiry:
        return 'card_expiry';

      case ActivityType.cardReminder:
        return 'card_reminder';

      case ActivityType.cashRemittance:
        return 'cash_remittance';

      case ActivityType.cashbackEarned:
        return 'cashback_earned';

      case ActivityType.cashbackExpiryReminder:
        return 'cashback_expiry_reminder';

      case ActivityType.cashinPayment:
        return 'cashin_payment';

      case ActivityType.cashinTransfer:
        return 'cashin_transfer';

      case ActivityType.cashoutPayment:
        return 'cashout_transfer';

      case ActivityType.cashoutTransfer:
        return 'cashout_transfer';

      case ActivityType.checkbook:
        return 'checkbook';

      case ActivityType.claims:
        return 'claims';

      case ActivityType.debitPayment:
        return 'debit_payment';

      case ActivityType.discountOfferForMe:
        return 'discount_offer_for_me';

      case ActivityType.dpa:
        return 'dpa';

      case ActivityType.fromMobileTransfer:
        return 'from_mobile_transfer';

      case ActivityType.goal:
        return 'goal';

      case ActivityType.goalTransactions:
        return 'goal_txn';

      case ActivityType.idExpiryReminder:
        return 'id_expiry_reminder';

      case ActivityType.inbox:
        return 'inbox';

      case ActivityType.insufficientBalance:
        return 'insufficient_balance';

      case ActivityType.internationalBeneficiary:
        return 'international_beneficiary';

      case ActivityType.issuedCheck:
        return 'issued_check';

      case ActivityType.loanPaymentExpired:
        return 'loan_payment_expired';

      case ActivityType.loanReminder:
        return 'loan_reminder';

      case ActivityType.lowBalance:
        return 'low_balance';

      case ActivityType.loyalty:
        return 'loyalty';

      case ActivityType.merchantTransfer:
        return 'merchant_transfer';

      case ActivityType.message:
        return 'message';

      case ActivityType.offerForMe:
        return 'offer_for_me';

      case ActivityType.payment:
        return 'payment';

      case ActivityType.pennyBankTransactions:
        return 'penny_bank_txn';

      case ActivityType.pullPayment:
        return 'pull_payment';

      case ActivityType.receivedSendMoney:
        return 'received_send_money';

      case ActivityType.recurringPayment:
        return 'recurring_payment';

      case ActivityType.recurringTopup:
        return 'recurring_topup_payment';

      case ActivityType.recurringTransfer:
        return 'recurring_transfer';

      case ActivityType.request:
        return 'request';

      case ActivityType.requestPayment:
        return 'request_payment';

      case ActivityType.safeToSpend:
        return 'safe_to_spend';

      case ActivityType.scheduledPayment:
        return 'scheduled_payment';

      case ActivityType.scheduledTopup:
        return 'scheduled_topup_payment';

      case ActivityType.scheduledTransfer:
        return 'scheduled_transfer';

      case ActivityType.sendMoney:
        return 'send_money';

      case ActivityType.termDepositReminder:
        return 'term_deposit_reminder';

      case ActivityType.topup:
        return 'topup';

      case ActivityType.topupPayment:
        return 'topup_payment';

      case ActivityType.transaction:
        return 'transaction';

      case ActivityType.transfer:
        return 'transfer';

      case ActivityType.unknown:
        return 'unknown';

      case ActivityType.vault:
        return 'vault';

      case ActivityType.wallet:
        return 'wallet';

      case ActivityType.walletPayment:
        return 'wallet_transaction';

      case ActivityType.walletRemittance:
        return 'wallet_remittance';

      case ActivityType.wpsTransfer:
        return 'wps_transfer';

      default:
        return '';
    }
  }
}

/// Extension that provides mappings for [ActivityTag]
extension ActivityTagsMapping on ActivityTag {
  /// Maps into String that represents the [ActivityTag]
  String get toJSONString {
    switch (this) {
      case ActivityTag.unknown:
        return 'unknown';

      case ActivityTag.profile:
        return 'profile';

      case ActivityTag.productsAndServices:
        return 'products_services';
      default:
        return '';
    }
  }
}
