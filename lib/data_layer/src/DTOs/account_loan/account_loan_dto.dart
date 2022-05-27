import 'package:collection/collection.dart';

import '../../dtos.dart';
import '../../helpers.dart';

/// Data transfer object representing an account loan.
class AccountLoanDTO {
  /// The loan id.
  String? id;

  /// The id of the account that's associated with this loan.
  String? accountId;

  /// The total amount to be paid.
  double? amountFinanced;

  /// The amount already repaid.
  double? amountDisbursed;

  /// The remaining amount of the loan.
  double? amountOutstanding;

  /// The amount to be paid in the next payment.
  double? amountDue;

  /// The amount borrowed.
  double? amountDuePrincipal;

  /// The amount of interest to be repaid.
  double? amountDueInterest;

  /// The amount of penalties to be repaid.
  double? amountDuePenalty;

  /// The date of the next payment.
  DateTime? nextPayment;

  /// The due date of the entire loan.
  DateTime? maturity;

  /// The interest rate of the loan.
  double? interestRate;

  /// The amount of the payments that should have already been paid but haven't.
  int? arrears;

  /// The life insurance rate.
  double? lifeInsuranceRate;

  /// The loan name.
  String? name;

  /// The loan description.
  String? description;

  /// The frequency of loan payments.
  AccountLoanFrequencyDTO? frequency;

  /// The loan status.
  AccountLoanStatusDTO? status;

  /// The loan identifier on the bank side.
  String? reference;

  /// The date the loan was created.
  DateTime? created;

  /// The date the loan was last updated.
  DateTime? updated;

  /// Any additional saved information.
  dynamic extra;

  /// The account associated with this loan.
  AccountDTO? account;

  /// The payments of the loan.
  List<AccountLoanPaymentDTO>? payments;

  /// The amount of paid payments
  int? paidPayments;

  /// The amount of payments inside this loan
  int? totalPayments;

  /// Creates [AccountLoanDTO].
  AccountLoanDTO({
    this.id,
    this.accountId,
    this.amountFinanced,
    this.amountDisbursed,
    this.amountOutstanding,
    this.amountDue,
    this.amountDuePrincipal,
    this.amountDueInterest,
    this.amountDuePenalty,
    this.nextPayment,
    this.maturity,
    this.interestRate,
    this.arrears,
    this.lifeInsuranceRate,
    this.name,
    this.description,
    this.frequency,
    this.status,
    this.reference,
    this.created,
    this.updated,
    this.extra,
    this.account,
    this.payments,
    this.paidPayments,
    this.totalPayments,
  });

  /// Creates the [AccountLoanDTO] from json map.
  factory AccountLoanDTO.fromJson(Map<String, dynamic> json) {
    return AccountLoanDTO(
      id: json['account_loan_id'],
      accountId: json['account_id'],
      amountFinanced: JsonParser.parseDouble(json['amount_financed']),
      amountDisbursed: JsonParser.parseDouble(json['amount_disbursed']),
      amountOutstanding: JsonParser.parseDouble(json['amount_outstanding']),
      amountDue: JsonParser.parseDouble(json['amount_due']),
      amountDuePrincipal: JsonParser.parseDouble(json['amount_due_principal']),
      amountDueInterest: JsonParser.parseDouble(json['amount_due_interest']),
      amountDuePenalty: JsonParser.parseDouble(json['amount_due_penalty']),
      nextPayment: JsonParser.parseStringDate(json['next_payment_date']),
      maturity: JsonParser.parseStringDate(json['maturity_date']),
      interestRate: JsonParser.parseDouble(json['interest_rate']),
      arrears: JsonParser.parseInt(json['arrears']),
      lifeInsuranceRate: JsonParser.parseDouble(json['life_insurance_rate']),
      name: json['name'],
      description: json['description'],
      frequency: AccountLoanFrequencyDTO.fromRaw(json['frequency']),
      status: AccountLoanStatusDTO.fromRaw(json['status']),
      reference: json['reference'],
      created: JsonParser.parseDate(json['ts_created']),
      updated: JsonParser.parseDate(json['ts_updated']),
      extra: json['extra'],
      account:
          json['account'] == null ? null : AccountDTO.fromJson(json['account']),
      payments: json['account_loan_payments'] == null
          ? null
          : AccountLoanPaymentDTO.fromJsonList(
              json['account_loan_payments'],
            ),
      paidPayments: JsonParser.parseInt(json['installments_paid']),
      totalPayments: JsonParser.parseInt(json['installments_total']),
    );
  }

  /// Creates a [AccountLoanDTO]s from a list of json maps.
  static List<AccountLoanDTO> fromJsonList(List json) =>
      json.map((loanJson) => AccountLoanDTO.fromJson(loanJson)).toList();
}

/// The status of the account loan.
class AccountLoanStatusDTO extends EnumDTO {
  /// The loan is active.
  static const active = AccountLoanStatusDTO._internal('A');

  /// The loan was deleted.
  static const deleted = AccountLoanStatusDTO._internal('D');

  const AccountLoanStatusDTO._internal(String value) : super.internal(value);

  /// All loan status values.
  static const values = [
    active,
    deleted,
  ];

  /// Creates [AccountLoanStatusDTO] from raw value.
  static AccountLoanStatusDTO? fromRaw(String? raw) => values.firstWhereOrNull(
        (element) => raw == element.value,
      );
}

/// The frequency of loan payments.
class AccountLoanFrequencyDTO extends EnumDTO {
  /// Payments every week.
  static const weekly = AccountLoanFrequencyDTO._internal('W');

  /// Payments every month.
  static const monthly = AccountLoanFrequencyDTO._internal('M');

  /// Payments once every 3 months.
  static const quarterly = AccountLoanFrequencyDTO._internal('Q');

  /// Payments twice a year.
  static const semianually = AccountLoanFrequencyDTO._internal('S');

  /// Payments once a year.
  static const yearly = AccountLoanFrequencyDTO._internal('Y');

  /// All possible loan frequency values.
  static const values = [
    weekly,
    monthly,
    quarterly,
    semianually,
    yearly,
  ];

  const AccountLoanFrequencyDTO._internal(String value) : super.internal(value);

  /// Creates [AccountLoanFrequencyDTO] from raw value.
  static AccountLoanFrequencyDTO? fromRaw(String? raw) =>
      values.firstWhereOrNull(
        (element) => raw == element.value,
      );
}
