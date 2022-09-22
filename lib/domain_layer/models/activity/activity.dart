import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';

/// The type of the [Activity]
enum ActivityType {
  /// Unknown
  unknown,

  /// Low Balance
  lowBalance,

  /// Card Reminder
  cardReminder,

  /// Card Top Up
  cardTopUp,

  /// Load Reminder
  loanReminder,

  /// Checkbook
  checkbook,

  /// Transfer
  transfer,

  /// Bulk Transfer
  bulkTransfer,

  /// Request
  request,

  /// Recurring Transfer
  recurringTransfer,

  /// Transaction
  transaction,

  /// Payment
  payment,

  /// Scheduled Payment
  scheduledPayment,

  /// Recurring Payment
  recurringPayment,

  /// Top up
  topup,

  /// DPA
  dpa,

  /// Goal
  goal,

  /// Safe to Spend
  safeToSpend,

  /// Wallet
  wallet,

  /// Wallet Payment
  walletPayment,

  /// Scheduled Transfer
  scheduledTransfer,

  /// Campaign
  campaign,

  /// Card Expiry
  cardExpiry,

  /// Message
  message,

  /// Claims
  claims,

  /// Internacional Beneficiary
  internationalBeneficiary,

  /// Inbox
  inbox,

  /// Pull Payment
  pullPayment,

  /// Request Payment
  requestPayment,

  /// Debit Payment
  debitPayment,

  /// Cash In Payment
  cashinPayment,

  /// Cash Out Payment
  cashoutPayment,

  /// Send Money
  sendMoney,

  /// Appointment Reminder
  appointmentReminder,

  /// Received Send Money
  receivedSendMoney,

  /// Cash In Transfer
  cashinTransfer,

  /// Cash Out Transfer
  cashoutTransfer,

  /// From Mobile Transfer
  fromMobileTransfer,

  /// C2C Transfer
  c2CTransfer,

  /// Vault
  vault,

  /// Merchant Transfer
  merchantTransfer,

  /// Card Control
  cardControl,

  /// Bulk Register
  bulkRegister,

  /// WPS Transfer
  wpsTransfer,

  /// Top Up Payment
  topupPayment,

  /// Cash Remittance
  cashRemittance,

  /// Bank Remittance
  bankRemittance,

  /// Wallet Remittance
  walletRemittance,

  /// Recurring Top Up
  recurringTopup,

  /// Scheduled Top Up
  scheduledTopup,

  /// Benefit Pay
  benefitPay,

  /// Benefit GW
  benefitGw,

  /// Issued Check
  issuedCheck,

  /// Term Deposit Reminder
  termDepositReminder,

  /// Cashback Earned
  cashbackEarned,

  /// Offer For me
  offerForMe,

  /// Cashback Expiry Reminder
  cashbackExpiryReminder,

  /// Discount Offer For me
  discountOfferForMe,

  /// Loan Payment Expired
  loanPaymentExpired,

  /// Loyalty
  loyalty,

  /// Goal Transactions
  goalTransactions,

  /// Penny Bank Transactions
  pennyBankTransactions,

  /// Id Expiry Reminder
  idExpiryReminder,

  /// Insufficient Balance
  insufficientBalance,
}

/// The action type of the [Activity]
enum ActivityActionType {
  /// Unknown
  unknown,

  /// Approve
  approve,

  /// Reject
  reject,

  /// Delete
  delete,

  /// Cancel
  cancel,

  /// Cancel Appointment
  cancelAppointment,

  /// Continue Process
  continueProcess,

  /// Patch Transfer
  patchTransfer,

  /// Cancel Recurring Transfer
  cancelRecurringTransfer,

  /// Cancel Recurring Payment
  cancelRecurringPayment,

  /// Delet Alert
  deleteAlert,

  /// Colect To Own
  collectToOwn,

  /// Sendo to Beneficiary
  sendToBeneficiary,

  /// Cancel Send Money
  cancelSendMoney,

  /// Repeat Action
  repeatAction,

  /// Add to Shortcut
  addToShortcut,

  /// Patch Payment
  patchPayment,

  /// Edit Appointment
  editAppointment,

  /// Share payment receipt
  sharePaymentReceipt,

  /// Renewal
  renewal,
}

/// The tag of the [Activity]
enum ActivityTag {
  /// Unknown
  unknown,

  /// Products and Services
  productsAndServices,

  /// Profile
  profile,
}

///The activity data used by the application
class Activity extends Equatable {
  /// The [Activity] id
  final String id;

  /// The [Activity] status
  final String status;

  /// The [Activity] message
  final String message;

  /// The [ActivityType]
  final ActivityType? type;

  /// The [Activity] actions
  final UnmodifiableListView<ActivityActionType>? actions;

  /// The [Activity] updated time
  final DateTime tsUpdated;

  /// The [Activity] alert id
  final int alertID;

  /// Whether the activity is read only
  final bool read;

  /// The [Activity] itemId
  final dynamic itemId;

  /// The [Activity] item
  final dynamic item;

  ///Creates a new immutable [Activity]
  Activity({
    required this.id,
    required this.itemId,
    required this.item,
    required this.status,
    required this.message,
    required this.alertID,
    required this.tsUpdated,
    required this.read,
    required this.type,
    Iterable<ActivityActionType>? actions,
  }) : actions = UnmodifiableListView(actions ?? []);

  @override
  List<Object?> get props => [
        id,
        status,
        message,
        tsUpdated,
        alertID,
        read,
        item,
        itemId,
        actions,
      ];
}
