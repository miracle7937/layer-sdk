import 'package:collection/collection.dart';

import '../../helpers.dart';

/// The different activity types
class ActivityTypeDTO extends EnumDTO {
  static const unknown = ActivityTypeDTO._internal('unknown');
  static const lowBalance = ActivityTypeDTO._internal('low_balance');
  static const cardReminder = ActivityTypeDTO._internal('card_reminder');
  static const loanReminder = ActivityTypeDTO._internal('loan_reminder');
  static const checkbook = ActivityTypeDTO._internal('checkbook');
  static const transfer = ActivityTypeDTO._internal('transfer');
  static const bulkTransfer = ActivityTypeDTO._internal('bulk_transfer');
  static const request = ActivityTypeDTO._internal('request');
  static const recurringTransfer =
      ActivityTypeDTO._internal('recurring_transfer');
  static const transaction = ActivityTypeDTO._internal('transaction');
  static const payment = ActivityTypeDTO._internal('payment');
  static const scheduledPayment =
      ActivityTypeDTO._internal('scheduled_payment');
  static const recurringPayment =
      ActivityTypeDTO._internal('recurring_payment');
  static const topup = ActivityTypeDTO._internal('topup');
  static const dpa = ActivityTypeDTO._internal('dpa');
  static const goal = ActivityTypeDTO._internal('goal');
  static const safeToSpend = ActivityTypeDTO._internal('safe_to_spend');
  static const wallet = ActivityTypeDTO._internal('wallet');
  static const walletPayment = ActivityTypeDTO._internal('wallet_transaction');
  static const scheduledTransfer =
      ActivityTypeDTO._internal('scheduled_transfer');
  static const campaign = ActivityTypeDTO._internal('campaign');
  static const cardExpiry = ActivityTypeDTO._internal('card_expiry');
  static const message = ActivityTypeDTO._internal('message');
  static const claims = ActivityTypeDTO._internal('claims');
  static const internationalBeneficiary =
      ActivityTypeDTO._internal('international_beneficiary');
  static const inbox = ActivityTypeDTO._internal('inbox');
  static const pullPayment = ActivityTypeDTO._internal('pull_payment');
  static const requestPayment = ActivityTypeDTO._internal('request_payment');
  static const debitPayment = ActivityTypeDTO._internal('debit_payment');
  static const cashinPayment = ActivityTypeDTO._internal('cashin_payment');
  static const cashoutPayment = ActivityTypeDTO._internal('cashout_payment');
  static const sendMoney = ActivityTypeDTO._internal('send_money');
  static const appointmentReminder =
      ActivityTypeDTO._internal('appointment_reminder');
  static const receivedSendMoney =
      ActivityTypeDTO._internal('received_send_money');
  static const cashinTransfer = ActivityTypeDTO._internal('cashin_transfer');
  static const cashoutTransfer = ActivityTypeDTO._internal('cashout_transfer');
  static const fromMobileTransfer =
      ActivityTypeDTO._internal('from_mobile_transfer');
  static const c2cTransfer = ActivityTypeDTO._internal('c2c_transfer');
  static const vault = ActivityTypeDTO._internal('vault');
  static const merchantTransfer =
      ActivityTypeDTO._internal('merchant_transfer');
  static const cardControl = ActivityTypeDTO._internal('card_control');
  static const bulkRegister = ActivityTypeDTO._internal('bulk_register');
  static const wpsTransfer = ActivityTypeDTO._internal('wps_transfer');
  static const topupPayment = ActivityTypeDTO._internal('topup_payment');
  static const cashRemittance = ActivityTypeDTO._internal('cash_remittance');
  static const bankRemittance = ActivityTypeDTO._internal('bank_remittance');
  static const walletRemittance =
      ActivityTypeDTO._internal('wallet_remittance');
  static const recurringTopup =
      ActivityTypeDTO._internal('recurring_topup_payment');
  static const scheduledTopup =
      ActivityTypeDTO._internal('scheduled_topup_payment');
  static const benefitPay = ActivityTypeDTO._internal('benefit_pay');
  static const benefitGw = ActivityTypeDTO._internal('benefit_gw');
  static const issuedCheck = ActivityTypeDTO._internal('issued_check');
  static const termDepositReminder =
      ActivityTypeDTO._internal('term_deposit_reminder');
  static const cashbackEarned = ActivityTypeDTO._internal('cashback_earned');
  static const offerForMe = ActivityTypeDTO._internal('offer_for_me');
  static const cashbackExpiryReminder =
      ActivityTypeDTO._internal('cashback_expiry_reminder');
  static const discountOfferForMe =
      ActivityTypeDTO._internal('discount_offer_for_me');
  static const loanPaymentExpired =
      ActivityTypeDTO._internal('loan_payment_expired');
  static const loyalty = ActivityTypeDTO._internal('loyalty');
  static const goalTransactions = ActivityTypeDTO._internal('goal_txn');
  static const pennyBankTransactions =
      ActivityTypeDTO._internal('penny_bank_txn');
  static const idExpiryReminder =
      ActivityTypeDTO._internal('id_expiry_reminder');
  static const insufficientBalance =
      ActivityTypeDTO._internal('insufficient_balance');
  static const cardTopup = ActivityTypeDTO._internal('stripe_topup');

  /// All possible activities type values
  static const List<ActivityTypeDTO> values = [
    unknown,
    lowBalance,
    cardReminder,
    loanReminder,
    checkbook,
    transfer,
    bulkTransfer,
    request,
    recurringTransfer,
    transaction,
    payment,
    scheduledPayment,
    recurringPayment,
    topup,
    dpa,
    goal,
    safeToSpend,
    wallet,
    walletPayment,
    scheduledTransfer,
    campaign,
    cardExpiry,
    message,
    claims,
    internationalBeneficiary,
    inbox,
    pullPayment,
    requestPayment,
    debitPayment,
    cashinPayment,
    cashoutPayment,
    sendMoney,
    cashinTransfer,
    cashoutTransfer,
    fromMobileTransfer,
    appointmentReminder,
    receivedSendMoney,
    c2cTransfer,
    vault,
    bulkRegister,
    wpsTransfer,
    merchantTransfer,
    topupPayment,
    cashRemittance,
    bankRemittance,
    walletRemittance,
    recurringTopup,
    scheduledTopup,
    benefitPay,
    benefitGw,
    issuedCheck,
    cardControl,
    termDepositReminder,
    cashbackEarned,
    offerForMe,
    cashbackExpiryReminder,
    discountOfferForMe,
    loanPaymentExpired,
    loyalty,
    goalTransactions,
    pennyBankTransactions,
    idExpiryReminder,
    insufficientBalance,
    cardTopup,
  ];

  const ActivityTypeDTO._internal(super.value) : super.internal();

  /// Creates a [ActivityTypeDTO] from a [String]
  static ActivityTypeDTO? fromRaw(String? raw) => values.firstWhereOrNull(
        (val) => val.value == raw,
      );
}
