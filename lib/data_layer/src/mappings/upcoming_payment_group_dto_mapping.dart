import '../../models.dart';
import '../dtos.dart';
import '../mappings.dart';

/// Extension that provides mappings for [UpcomingPaymentGroupDTO]
extension UpcomingPaymentGroupDTOMapping on UpcomingPaymentGroupDTO {
  /// Maps into a [UpcomingPaymentGroup]
  UpcomingPaymentGroup toUpcomingPaymentGroup() => UpcomingPaymentGroup(
        accountLoanPayments: accountLoanPayments?.toUpcomingPaymentList(),
        billPayments: billPayments?.toUpcomingPaymentList(),
        creditCardPayments: creditCardPayments?.toUpcomingPaymentList(),
        scheduledTransferPayments:
            scheduledTransferPayments?.toUpcomingPaymentList(),
        goalPayments: goalPayments?.toUpcomingPaymentList(),
        allPayments: allPayments?.toUpcomingPaymentList(),
        scheduledPayments: scheduledPayments?.toUpcomingPaymentList(),
        accountLoanDues: accountLoanDues is double ? accountLoanDues : 0.0,
        billDues: billDues is double ? billDues : 0.0,
        creditCardDues: creditCardDues is double ? creditCardDues : 0.0,
        scheduledTransferDues:
            scheduledTransferDues is double ? scheduledTransferDues : 0.0,
        goalDues: goalDues is double ? goalDues : 0.0,
        scheduledPaymentsDues:
            scheduledPaymentsDues is double ? scheduledPaymentsDues : 0.0,
        total: total is double ? total : 0.0,
        prefCurrency: prefCurrency,
        hideValues: [
          accountLoanDues,
          billDues,
          creditCardDues,
          scheduledTransferDues,
          goalDues,
          scheduledPaymentsDues,
          total
        ].any((element) => element is String),
      );
}

/// Extension that provides mappings for lists of [UpcomingPaymentDTO]
extension UpcomingPaymentDTOListMapping on List<UpcomingPaymentDTO> {
  /// Maps into a list of [UpcomingPayment]
  List<UpcomingPayment> toUpcomingPaymentList() => map(
        (e) => e.toUpcomingPayment(),
      ).toList();
}
