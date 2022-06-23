import 'package:collection/collection.dart';

import '../../../../data_layer/dtos.dart';
import '../../../_migration/data_layer/src/dtos.dart';
import '../../helpers.dart';

///Data transfer object that represents an upcoming payment
class UpcomingPaymentDTO {
  ///The payment id
  String? id;

  ///The loan id
  String? loanId;

  ///The merchant name
  String? merchantName;

  ///When this payment was created
  DateTime? created;

  ///Last time this payment was updated
  DateTime? updated;

  ///The date the payment should be completed
  DateTime? maturityDate;

  ///The amount for this payment
  double? amount;

  ///The currency for this payment
  String? currency;

  ///The status of the payment
  UpcomingPaymentStatusDTO? status;

  ///The amount in the base currency
  double? convertedAmount;

  ///The total payments for this loan
  int? totalPayments;

  ///The order of this payment inside the loan
  int? currentPayment;

  ///Nickname
  String? nickName;

  ///Name
  String? name;

  ///Recurrence
  String? recurrence;

  ///Date
  DateTime? dateTime;

  ///Number
  String? number;

  ///Payment type
  UpcomingPaymentTypeDTO? paymentType;

  ///Transfer
  TransferDTO? transfer;

  ///Bill
  BillDTO? bill;

  ///Is name localized
  bool? isNameLocalized;

  ///The original payment object
  dynamic originalObject;

  ///Creates a new [UpcomingPaymentDTO] object
  UpcomingPaymentDTO({
    this.id,
    this.loanId,
    this.merchantName,
    this.created,
    this.updated,
    this.maturityDate,
    this.amount,
    this.currency,
    this.status,
    this.convertedAmount,
    this.totalPayments,
    this.currentPayment,
    this.nickName,
    this.name,
    this.recurrence,
    this.dateTime,
    this.number,
    this.paymentType,
    this.transfer,
    this.bill,
    this.isNameLocalized,
    this.originalObject,
  });

  /// Creates a new [UpcomingPaymentDTO] from json
  factory UpcomingPaymentDTO.fromJson(Map<String, dynamic> json) {
    final accountLoan = json['account_loan'];

    return UpcomingPaymentDTO(
      id: json['payment_id'],
      loanId: accountLoan == null ? null : accountLoan['account_loan_id'],
      merchantName: accountLoan == null ? null : accountLoan['name'] ?? '',
      created: JsonParser.parseDate(json['ts_created']),
      updated: JsonParser.parseDate(json['ts_updated']),
      maturityDate: JsonParser.parseStringDate(json['maturity_date']),
      amount: JsonParser.parseDouble(json['amount']),
      currency: json['currency'],
      status: UpcomingPaymentStatusDTO.fromRaw(json['status']),
      convertedAmount: JsonParser.parseDouble(json['converted_amount']),
      totalPayments: JsonParser.parseInt(json['total_payments']),
      currentPayment: JsonParser.parseInt(json['current_payment']),
    );
  }

  /// Creates a list of [UpcomingPaymentDTO]s from the given JSON list.
  static List<UpcomingPaymentDTO> fromJsonList(List json) => json
      .map(
          (payment) => UpcomingPaymentDTO.fromJson(payment['upcoming_payment']))
      .toList();

  /// Creates a new [UpcomingPaymentDTO] from json
  factory UpcomingPaymentDTO.fromBill(BillDTO bill) => UpcomingPaymentDTO(
        id: bill.billId.toString(),
        nickName: bill.nickname,
        name: bill.service?.name,
        dateTime: bill.dueDate,
        amount: bill.amount,
        currency: bill.feesCurrency,
        paymentType: UpcomingPaymentTypeDTO.bill,
        originalObject: bill,
      );

  /// Creates a new [UpcomingPaymentDTO] from json
  factory UpcomingPaymentDTO.fromSchedulePayment(PaymentDTO payment) =>
      UpcomingPaymentDTO(
        id: payment.paymentId.toString(),
        nickName: payment.bill?.nickname,
        name: payment.bill?.service?.name,
        dateTime: payment.scheduled,
        amount: payment.amount,
        currency: payment.currency,
        paymentType: UpcomingPaymentTypeDTO.recurringPayment,
        originalObject: payment,
      );

  /// Creates a new [UpcomingPaymentDTO] from json list
  static List<UpcomingPaymentDTO> fromBillsList(List json) {
    return json
        .map((bill) => UpcomingPaymentDTO.fromBill(BillDTO.fromJson(bill)))
        .toList();
  }

  ///Keep for later use
  // factory UpcomingPaymentDTO.fromAccount(AccountLoanDTO loan) {
  //   var upcoming = UpcomingPaymentDTO(
  //       id: loan.id,
  //       nickName: loan.account.nickname,
  //       number: loan.account.formattedAccountNumber,
  //       amount: loan.amountDue,
  //       dateTime: loan.nextPaymentDate,
  //       currency: loan.account.currency,
  //       name: loan.account.displayName,
  //       paymentType: UpcomingPaymentTypeDTO.finance_account);
  //   upcoming.originalObject = loan;
  //   return upcoming;
  // }
  //
  // static List<UpcomingPaymentDTO> fromAccountsList(List json) {
  //   return json
  //       .map((account) =>
  //           UpcomingPaymentDTO.fromAccount(AccountLoanDTO.fromJson(account)))
  //       .toList();
  // }

  /// Creates a new [UpcomingPaymentDTO] from json
  factory UpcomingPaymentDTO.fromCard(CardDTO card) => UpcomingPaymentDTO(
        id: card.cardId?.toString(),
        // nickName: card.nickname,
        // name: card.cardType.type,
        number: card.maskedCardNumber,
        // amount: card.minimumDue,
        // dateTime: card.dueDate,
        currency: card.currency,
        paymentType: UpcomingPaymentTypeDTO.creditCard,
        originalObject: card,
      );

  /// Creates a new [UpcomingPaymentDTO] from json list
  static List<UpcomingPaymentDTO> fromCardsList(List json) {
    return json
        .map((card) => UpcomingPaymentDTO.fromCard(CardDTO.fromJson(card)))
        .toList();
  }

  /// Creates a new [UpcomingPaymentDTO] from json
  factory UpcomingPaymentDTO.fromRecurringTransfer(TransferDTO transfer) =>
      UpcomingPaymentDTO(
        id: transfer.id?.toString(),
        nickName: transfer.toCard?.nickname ?? transfer.toBeneficiary?.nickname,
        amount: transfer.amount,
        currency: transfer.currency,
        dateTime: transfer.scheduled,
        paymentType: UpcomingPaymentTypeDTO.recurringTransfer,
        transfer: transfer,
        isNameLocalized: true,
        originalObject: transfer,
        name: (transfer.recurring ?? false)
            ? 'recurring_transfer'
            : 'scheduled_transfer',
      );

  /// Creates a new [UpcomingPaymentDTO] from json list
  static List<UpcomingPaymentDTO> fromTransfersList(List json) {
    return json
        .map((transfer) => UpcomingPaymentDTO.fromRecurringTransfer(
            TransferDTO.fromJson(transfer)))
        .toList();
  }

  ///Keep for later use
  // factory UpcomingPayment.fromGoal(Goal goal) {
  //   UpcomingPayment upcoming = UpcomingPayment(
  //     id: goal.id.toString(),
  //     name: goal.name,
  //     amount: goal.transferAmount,
  //     dateTime: goal.dueDate,
  //     currency: goal.currency,
  //     paymentType: UpcomingPaymentType.goal,
  //   );
  //   upcoming.originalObject = goal;
  //   return upcoming;
  // }
}

///The upcoming payment status
class UpcomingPaymentStatusDTO extends EnumDTO {
  /// Unpaid payment
  static const unpaid = UpcomingPaymentStatusDTO._internal('U');

  /// Payed payment
  static const paid = UpcomingPaymentStatusDTO._internal('P');

  /// All the available payment status in a list
  static const List<UpcomingPaymentStatusDTO> values = [
    unpaid,
    paid,
  ];

  const UpcomingPaymentStatusDTO._internal(String value)
      : super.internal(value);

  /// Creates a [UpcomingPaymentStatusDTO] from a [String]
  static UpcomingPaymentStatusDTO? fromRaw(String? raw) =>
      values.firstWhereOrNull(
        (val) => val.value == raw,
      );
}

///The upcoming payment type
class UpcomingPaymentTypeDTO extends EnumDTO {
  /// Account loan instalment.
  static const accountLoan = UpcomingPaymentTypeDTO._internal(
    'account_loan_payment',
  );

  /// Bill
  static const bill = UpcomingPaymentTypeDTO._internal('bill');

  /// Recurring transfer
  static const recurringTransfer =
      UpcomingPaymentTypeDTO._internal('scheduled_transfer');

  /// Finance account
  static const financeAccount =
      UpcomingPaymentTypeDTO._internal('account_loan');

  /// Credit card
  static const creditCard = UpcomingPaymentTypeDTO._internal('card');

  /// Goal
  static const goal = UpcomingPaymentTypeDTO._internal('goal');

  /// Recurring payment
  static const recurringPayment =
      UpcomingPaymentTypeDTO._internal('scheduled_payment');

  /// All the available payment types in a list
  static const List<UpcomingPaymentTypeDTO> values = [
    accountLoan,
    bill,
    recurringTransfer,
    financeAccount,
    creditCard,
    goal,
    recurringPayment,
  ];

  const UpcomingPaymentTypeDTO._internal(String value) : super.internal(value);

  /// Creates a [UpcomingPaymentTypeDTO] from a [String]
  static UpcomingPaymentTypeDTO? fromRaw(String? raw) =>
      values.firstWhereOrNull(
        (val) => val.value == raw,
      );
}
