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
        return item != null ? (item as DPATaskDTO).toDPATask(customData) : null;

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

/// Extension that provides mappings for [ActivityTag]
extension ActivityTagDTOMapping on ActivityTag {
  /// Maps into [ActivityTagDTO].
  ActivityTagDTO toActivityTagDTO() {
    switch (this) {
      case ActivityTag.unknown:
        return ActivityTagDTO.unknown;

      case ActivityTag.profile:
        return ActivityTagDTO.profile;

      case ActivityTag.productsAndServices:
        return ActivityTagDTO.productsAndServices;
    }
  }
}

/// Extension that provides mappings for [ActivityType]
extension ActivityTypeMapping on ActivityType {
  /// Maps into a [ActivityType]
  ActivityTypeDTO toTypeDTO() {
    switch (this) {
      case ActivityType.appointmentReminder:
        return ActivityTypeDTO.appointmentReminder;

      case ActivityType.bankRemittance:
        return ActivityTypeDTO.bankRemittance;

      case ActivityType.benefitGw:
        return ActivityTypeDTO.benefitGw;

      case ActivityType.benefitPay:
        return ActivityTypeDTO.benefitPay;

      case ActivityType.bulkRegister:
        return ActivityTypeDTO.bulkRegister;

      case ActivityType.bulkTransfer:
        return ActivityTypeDTO.bulkTransfer;

      case ActivityType.c2CTransfer:
        return ActivityTypeDTO.c2cTransfer;

      case ActivityType.campaign:
        return ActivityTypeDTO.campaign;

      case ActivityType.cardControl:
        return ActivityTypeDTO.cardControl;

      case ActivityType.cardTopUp:
        return ActivityTypeDTO.cardTopup;

      case ActivityType.cardExpiry:
        return ActivityTypeDTO.cardExpiry;

      case ActivityType.cardReminder:
        return ActivityTypeDTO.cardReminder;

      case ActivityType.cashRemittance:
        return ActivityTypeDTO.cashRemittance;

      case ActivityType.cashbackEarned:
        return ActivityTypeDTO.cashbackEarned;

      case ActivityType.cashbackExpiryReminder:
        return ActivityTypeDTO.cashbackExpiryReminder;

      case ActivityType.cashinPayment:
        return ActivityTypeDTO.cashinPayment;

      case ActivityType.cashinTransfer:
        return ActivityTypeDTO.cashinTransfer;

      case ActivityType.cashoutPayment:
        return ActivityTypeDTO.cashoutPayment;

      case ActivityType.cashoutTransfer:
        return ActivityTypeDTO.cashoutTransfer;

      case ActivityType.checkbook:
        return ActivityTypeDTO.checkbook;

      case ActivityType.claims:
        return ActivityTypeDTO.claims;

      case ActivityType.debitPayment:
        return ActivityTypeDTO.debitPayment;

      case ActivityType.discountOfferForMe:
        return ActivityTypeDTO.discountOfferForMe;

      case ActivityType.dpa:
        return ActivityTypeDTO.dpa;

      case ActivityType.fromMobileTransfer:
        return ActivityTypeDTO.fromMobileTransfer;

      case ActivityType.goal:
        return ActivityTypeDTO.goal;

      case ActivityType.goalTransactions:
        return ActivityTypeDTO.goalTransactions;

      case ActivityType.idExpiryReminder:
        return ActivityTypeDTO.idExpiryReminder;

      case ActivityType.inbox:
        return ActivityTypeDTO.inbox;

      case ActivityType.insufficientBalance:
        return ActivityTypeDTO.insufficientBalance;

      case ActivityType.internationalBeneficiary:
        return ActivityTypeDTO.internationalBeneficiary;

      case ActivityType.issuedCheck:
        return ActivityTypeDTO.issuedCheck;

      case ActivityType.loanPaymentExpired:
        return ActivityTypeDTO.loanPaymentExpired;

      case ActivityType.loanReminder:
        return ActivityTypeDTO.loanReminder;

      case ActivityType.lowBalance:
        return ActivityTypeDTO.lowBalance;

      case ActivityType.loyalty:
        return ActivityTypeDTO.loyalty;

      case ActivityType.merchantTransfer:
        return ActivityTypeDTO.merchantTransfer;

      case ActivityType.message:
        return ActivityTypeDTO.message;

      case ActivityType.offerForMe:
        return ActivityTypeDTO.offerForMe;

      case ActivityType.payment:
        return ActivityTypeDTO.payment;

      case ActivityType.pennyBankTransactions:
        return ActivityTypeDTO.pennyBankTransactions;

      case ActivityType.pullPayment:
        return ActivityTypeDTO.pullPayment;

      case ActivityType.receivedSendMoney:
        return ActivityTypeDTO.receivedSendMoney;

      case ActivityType.recurringPayment:
        return ActivityTypeDTO.recurringPayment;

      case ActivityType.recurringTopup:
        return ActivityTypeDTO.recurringTopup;

      case ActivityType.recurringTransfer:
        return ActivityTypeDTO.recurringTransfer;

      case ActivityType.request:
        return ActivityTypeDTO.request;

      case ActivityType.requestPayment:
        return ActivityTypeDTO.requestPayment;

      case ActivityType.safeToSpend:
        return ActivityTypeDTO.safeToSpend;

      case ActivityType.scheduledPayment:
        return ActivityTypeDTO.scheduledPayment;

      case ActivityType.scheduledTopup:
        return ActivityTypeDTO.scheduledTopup;

      case ActivityType.scheduledTransfer:
        return ActivityTypeDTO.scheduledTransfer;

      case ActivityType.sendMoney:
        return ActivityTypeDTO.sendMoney;

      case ActivityType.termDepositReminder:
        return ActivityTypeDTO.termDepositReminder;

      case ActivityType.topup:
        return ActivityTypeDTO.topup;

      case ActivityType.topupPayment:
        return ActivityTypeDTO.topupPayment;

      case ActivityType.transaction:
        return ActivityTypeDTO.transaction;

      case ActivityType.transfer:
        return ActivityTypeDTO.transfer;

      case ActivityType.unknown:
        return ActivityTypeDTO.unknown;

      case ActivityType.vault:
        return ActivityTypeDTO.vault;

      case ActivityType.wallet:
        return ActivityTypeDTO.wallet;

      case ActivityType.walletPayment:
        return ActivityTypeDTO.walletPayment;

      case ActivityType.walletRemittance:
        return ActivityTypeDTO.walletRemittance;

      case ActivityType.wpsTransfer:
        return ActivityTypeDTO.wpsTransfer;

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
