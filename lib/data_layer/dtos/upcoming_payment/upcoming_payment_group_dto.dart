import '../../../../data_layer/dtos.dart';
import '../../../_migration/data_layer/src/dtos.dart';
import '../../helpers.dart';

/// The DTO that parses the response of the upcoming payments
/// and divides them into separate lists
class UpcomingPaymentGroupDTO {
  /// Account loan payments
  List<UpcomingPaymentDTO>? accountLoanPayments;

  /// Bill payments
  List<UpcomingPaymentDTO>? billPayments;

  /// Credit card payments
  List<UpcomingPaymentDTO>? creditCardPayments;

  /// Scheduled transfer payments
  List<UpcomingPaymentDTO>? scheduledTransferPayments;

  /// Goal payments
  List<UpcomingPaymentDTO>? goalPayments;

  /// All payments
  List<UpcomingPaymentDTO>? allPayments;

  /// Scheduled payments
  List<UpcomingPaymentDTO>? scheduledPayments;

  /// Account loan dues
  dynamic accountLoanDues;

  /// Bill dues
  dynamic billDues;

  /// Credit card dues
  dynamic creditCardDues;

  /// Schedules transfer dues
  dynamic scheduledTransferDues;

  /// Goal dues
  dynamic goalDues;

  /// Schedule payments dues
  dynamic scheduledPaymentsDues;

  /// Total
  dynamic total;

  /// Pref currency
  String? prefCurrency;

  /// Creates a new [UpcomingPaymentGroupDTO]
  UpcomingPaymentGroupDTO({
    this.prefCurrency,
    this.accountLoanPayments,
    this.billPayments,
    this.creditCardPayments,
    this.scheduledTransferPayments,
    this.accountLoanDues,
    this.billDues,
    this.allPayments,
    this.total,
    this.creditCardDues,
    this.scheduledTransferDues,
    this.goalDues,
    this.goalPayments,
    this.scheduledPayments,
    this.scheduledPaymentsDues,
  });

  /// Creates a new [UpcomingPaymentGroupDTO] from json
  factory UpcomingPaymentGroupDTO.fromJson(Map<String, dynamic> json) {
    List<dynamic>? allUpcomingPaymentsMap = json["upcoming_payments"];

    final accountLoanPayments = <UpcomingPaymentDTO>[];
    final billPayments = <UpcomingPaymentDTO>[];
    final creditPayments = <UpcomingPaymentDTO>[];
    final transferPayments = <UpcomingPaymentDTO>[];
    final goalPayments = <UpcomingPaymentDTO>[];
    final scheduledPayments = <UpcomingPaymentDTO>[];

    if (allUpcomingPaymentsMap != null && allUpcomingPaymentsMap.isNotEmpty) {
      for (var upcomingPaymentJson in allUpcomingPaymentsMap) {
        final type =
            UpcomingPaymentTypeDTO.fromRaw(upcomingPaymentJson["type"]);

        Map<String, dynamic> body =
            upcomingPaymentJson["upcoming_payment"] ?? {};

        if (type != null && (body.isNotEmpty)) {
          switch (type) {

            // case UpcomingPaymentTypeDTO.finance_account:
            //   accountLoanPayments.add(
            //     UpcomingPaymentDTO.fromAccount(
            //       AccountLoan.fromJson(body),
            //     ),
            //   );
            //   break;

            case UpcomingPaymentTypeDTO.recurringPayment:
              scheduledPayments.add(
                UpcomingPaymentDTO.fromSchedulePayment(
                  PaymentDTO.fromJson(body),
                ),
              );
              break;

            case UpcomingPaymentTypeDTO.bill:
              billPayments.add(
                UpcomingPaymentDTO.fromBill(
                  BillDTO.fromJson(body),
                ),
              );
              break;

            case UpcomingPaymentTypeDTO.creditCard:
              creditPayments.add(
                UpcomingPaymentDTO.fromCard(
                  CardDTO.fromJson(body),
                ),
              );
              break;

            case UpcomingPaymentTypeDTO.recurringTransfer:
              transferPayments.add(
                UpcomingPaymentDTO.fromRecurringTransfer(
                  TransferDTO.fromJson(body),
                ),
              );
              break;
          }
        }
      }
      ;
    }

    final payments = <UpcomingPaymentDTO>[
      ...accountLoanPayments,
      ...billPayments,
      ...creditPayments,
      ...transferPayments,
      ...scheduledPayments,
    ]..sort(_comparePayments);

    Map<String, dynamic>? paymentObject = json['upcoming_payment'];

    return UpcomingPaymentGroupDTO(
      accountLoanPayments: accountLoanPayments,
      billPayments: billPayments,
      creditCardPayments: creditPayments,
      scheduledTransferPayments: transferPayments,
      goalPayments: goalPayments,
      scheduledPayments: scheduledPayments,
      accountLoanDues: paymentObject?['account_loan_dues'] is String
          ? paymentObject!['account_loan_dues']
          : JsonParser.parseDouble(paymentObject?['account_loan_dues']),
      billDues: paymentObject?['bill_dues'] is String
          ? paymentObject!['bill_dues']
          : JsonParser.parseDouble(paymentObject?['bill_dues']),
      creditCardDues: paymentObject?['credit_card_dues'] is String
          ? paymentObject!['credit_card_dues']
          : JsonParser.parseDouble(paymentObject?['credit_card_dues']),
      prefCurrency: paymentObject?['pref_currency'],
      scheduledTransferDues: paymentObject?['scheduled_transfer_dues'] is String
          ? paymentObject!['scheduled_transfer_dues']
          : JsonParser.parseDouble(paymentObject?['scheduled_transfer_dues']),
      goalDues: paymentObject?['due_date'] is String
          ? paymentObject!['due_date']
          : JsonParser.parseDouble(paymentObject?['due_date']),
      scheduledPaymentsDues: paymentObject?['scheduled_payment_dues'] is String
          ? paymentObject!['scheduled_payment_dues']
          : JsonParser.parseDouble(paymentObject?['scheduled_payment_dues']),
      allPayments: payments,
      total: paymentObject?['total'] is String
          ? paymentObject!['total']
          : JsonParser.parseDouble(paymentObject?['total']),
    );
  }

  static int _comparePayments(UpcomingPaymentDTO a, UpcomingPaymentDTO b) {
    if (a.dateTime != null && b.dateTime != null) {
      return a.dateTime!.compareTo(b.dateTime!);
    }
    if (a.dateTime != null && b.dateTime == null) {
      return 1;
    }
    if (a.dateTime == null && b.dateTime != null) {
      return -1;
    }
    return 0;
  }
}
