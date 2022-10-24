import 'package:collection/collection.dart';

import '../../helpers.dart';

/// The different activity types
class ActivityTypeDTO extends EnumDTO {
  /// The activity type is unknown
  static const unknown = ActivityTypeDTO._internal('unknown');

  /// The activity type is Low Balance
  static const lowBalance = ActivityTypeDTO._internal('low_balance');

  /// The activity type is Card Reminder
  static const cardReminder = ActivityTypeDTO._internal('card_reminder');

  /// The activity type is Loan Reminder
  static const loanReminder = ActivityTypeDTO._internal('loan_reminder');

  /// The activity type is Check Book
  static const checkbook = ActivityTypeDTO._internal('checkbook');

  /// The activity type is Transfer
  static const transfer = ActivityTypeDTO._internal('transfer');

  /// The activity type is Bulk Transfer
  static const bulkTransfer = ActivityTypeDTO._internal('bulk_transfer');

  /// The activity type is request
  static const request = ActivityTypeDTO._internal('request');

  /// The activity type is Recurring Transfer
  static const recurringTransfer =
      ActivityTypeDTO._internal('recurring_transfer');

  /// The activity type is transaction
  static const transaction = ActivityTypeDTO._internal('transaction');

  /// The activity type is payment
  static const payment = ActivityTypeDTO._internal('payment');

  /// The activity type is Scheduled Payment
  static const scheduledPayment =
      ActivityTypeDTO._internal('scheduled_payment');

  /// The activity type is Recurring Payment
  static const recurringPayment =
      ActivityTypeDTO._internal('recurring_payment');

  /// The activity type is topup
  static const topup = ActivityTypeDTO._internal('topup');

  /// The activity type is dpa
  static const dpa = ActivityTypeDTO._internal('dpa');

  /// The activity type is goal
  static const goal = ActivityTypeDTO._internal('goal');

  /// The activity type is Safe To Spend
  static const safeToSpend = ActivityTypeDTO._internal('safe_to_spend');

  /// The activity type is wallet
  static const wallet = ActivityTypeDTO._internal('wallet');

  /// The activity type is Wallet Payment
  static const walletPayment = ActivityTypeDTO._internal('wallet_transaction');

  /// The activity type is Scheduled Transfer
  static const scheduledTransfer =
      ActivityTypeDTO._internal('scheduled_transfer');

  /// The activity type is campaign
  static const campaign = ActivityTypeDTO._internal('campaign');

  /// The activity type is Card Expiry
  static const cardExpiry = ActivityTypeDTO._internal('card_expiry');

  /// The activity type is Profile Update
  static const profileUpdate = ActivityTypeDTO._internal('profile_update');

  /// The activity type is message
  static const message = ActivityTypeDTO._internal('message');

  /// The activity type is claims
  static const claims = ActivityTypeDTO._internal('claims');

  /// The activity type is International Beneficiary
  static const internationalBeneficiary =
      ActivityTypeDTO._internal('international_beneficiary');

  /// The activity type is inbox
  static const inbox = ActivityTypeDTO._internal('inbox');

  /// The activity type is Pull Payment
  static const pullPayment = ActivityTypeDTO._internal('pull_payment');

  /// The activity type is Request Payment
  static const requestPayment = ActivityTypeDTO._internal('request_payment');

  /// The activity type is Debit Payment
  static const debitPayment = ActivityTypeDTO._internal('debit_payment');

  /// The activity type is Cashin Payment
  static const cashinPayment = ActivityTypeDTO._internal('cashin_payment');

  /// The activity type is Cashout Payment
  static const cashoutPayment = ActivityTypeDTO._internal('cashout_payment');

  /// The activity type is Send Money
  static const sendMoney = ActivityTypeDTO._internal('send_money');

  /// The activity type is Appointment Reminder
  static const appointmentReminder =
      ActivityTypeDTO._internal('appointment_reminder');

  /// The activity type is Received SendMoney
  static const receivedSendMoney =
      ActivityTypeDTO._internal('received_send_money');

  /// The activity type is Cashin Transfer
  static const cashinTransfer = ActivityTypeDTO._internal('cashin_transfer');

  /// The activity type is Cashout Transfer
  static const cashoutTransfer = ActivityTypeDTO._internal('cashout_transfer');

  /// The activity type is From Mobile Transfer
  static const fromMobileTransfer =
      ActivityTypeDTO._internal('from_mobile_transfer');

  /// The activity type is c2c Transfer
  static const c2cTransfer = ActivityTypeDTO._internal('c2c_transfer');

  /// The activity type is vault
  static const vault = ActivityTypeDTO._internal('vault');

  /// The activity type is Merchant Transfer
  static const merchantTransfer =
      ActivityTypeDTO._internal('merchant_transfer');

  /// The activity type is Card Control
  static const cardControl = ActivityTypeDTO._internal('card_control');

  /// The activity type is Bulk Register
  static const bulkRegister = ActivityTypeDTO._internal('bulk_register');

  /// The activity type is wps Transfer
  static const wpsTransfer = ActivityTypeDTO._internal('wps_transfer');

  /// The activity type is topup Payment
  static const topupPayment = ActivityTypeDTO._internal('topup_payment');

  /// The activity type is Cash Remittance
  static const cashRemittance = ActivityTypeDTO._internal('cash_remittance');

  /// The activity type is Bank Remittance
  static const bankRemittance = ActivityTypeDTO._internal('bank_remittance');

  /// The activity type is Wallet Remittance
  static const walletRemittance =
      ActivityTypeDTO._internal('wallet_remittance');

  /// The activity type is Recurring Topup
  static const recurringTopup =
      ActivityTypeDTO._internal('recurring_topup_payment');

  /// The activity type is Scheduled Topup
  static const scheduledTopup =
      ActivityTypeDTO._internal('scheduled_topup_payment');

  /// The activity type is Benefit Pay
  static const benefitPay = ActivityTypeDTO._internal('benefit_pay');

  /// The activity type is Benefit Gw
  static const benefitGw = ActivityTypeDTO._internal('benefit_gw');

  /// The activity type is Issued Check
  static const issuedCheck = ActivityTypeDTO._internal('issued_check');

  /// The activity type is Term Deposit Reminder
  static const termDepositReminder =
      ActivityTypeDTO._internal('term_deposit_reminder');

  /// The activity type is Cashback Earned
  static const cashbackEarned = ActivityTypeDTO._internal('cashback_earned');

  /// The activity type is Offer For Me
  static const offerForMe = ActivityTypeDTO._internal('offer_for_me');

  /// The activity type is Cashback Expiry Reminder
  static const cashbackExpiryReminder =
      ActivityTypeDTO._internal('cashback_expiry_reminder');

  /// The activity type is Discount Offer For Me
  static const discountOfferForMe =
      ActivityTypeDTO._internal('discount_offer_for_me');

  /// The activity type is Loan Payment Expired
  static const loanPaymentExpired =
      ActivityTypeDTO._internal('loan_payment_expired');

  /// The activity type is loyalty
  static const loyalty = ActivityTypeDTO._internal('loyalty');

  /// The activity type is Goal Transactions
  static const goalTransactions = ActivityTypeDTO._internal('goal_txn');

  /// The activity type is Penny Bank Transactions
  static const pennyBankTransactions =
      ActivityTypeDTO._internal('penny_bank_txn');

  /// The activity type is Id Expiry Reminder
  static const idExpiryReminder =
      ActivityTypeDTO._internal('id_expiry_reminder');

  /// The activity type is Insufficient Balance
  static const insufficientBalance =
      ActivityTypeDTO._internal('insufficient_balance');

  /// The activity type is Card Topup
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
