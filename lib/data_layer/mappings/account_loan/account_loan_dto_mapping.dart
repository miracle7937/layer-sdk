import '../../../../domain_layer/models.dart';
import '../../dtos.dart';
import '../../mappings.dart';

/// Extension that provides mapping for [AccountLoanDTO]
extension AccountLoanDTOMapping on AccountLoanDTO {
  /// Returns an [AccountLoan] built from this [AccountLoanDTO].
  AccountLoan toAccountLoan() {
    return AccountLoan(
      id: id,
      name: name,
      totalAmount: amountFinanced ?? 0.0,
      amountRemaining: amountOutstanding ?? 0.0,
      amountRepaid: amountDisbursed ?? 0.0,
      totalPayments: totalPayments ?? 0,
      paidPayments: paidPayments ?? 0,
      payments: payments?.map((e) => e.toAccountLoanPayment()),
      nextPaymentAmount: amountDue ?? 0.0,
      nextPaymentDate: nextPayment,
      maturityDate: maturity,
      createdDate: created,
    );
  }
}
