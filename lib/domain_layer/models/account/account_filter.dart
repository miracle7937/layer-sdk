import 'package:equatable/equatable.dart';
import '../../../../domain_layer/models.dart';

/// Specifies all possible account filters
class AccountFilter extends Equatable {
  /// When set to true will filter accounts that can request a
  /// certificate of account
  final bool canRequestCertificateOfAccount;

  /// When set to true will filter accounts that can request a
  /// certificate of deposit
  final bool canRequestCertificateOfDeposit;

  /// When set to true will filter accounts that can request a bank statement
  final bool canRequestStatement;

  /// Creates a new [AccountFilter]
  AccountFilter({
    this.canRequestCertificateOfAccount = false,
    this.canRequestCertificateOfDeposit = false,
    this.canRequestStatement = false,
  });

  @override
  List<Object?> get props => [
        canRequestCertificateOfAccount,
        canRequestCertificateOfDeposit,
        canRequestStatement,
      ];

  /// Returns a copy of this filter modified by the provided data.
  AccountFilter copyWith({
    bool? canRequestCertificateOfAccount,
    bool? canRequestCertificateOfDeposit,
    bool? canRequestStatement,
    List<AccountStatus>? statuses,
  }) =>
      AccountFilter(
        canRequestCertificateOfAccount: canRequestCertificateOfAccount ??
            this.canRequestCertificateOfAccount,
        canRequestCertificateOfDeposit: canRequestCertificateOfDeposit ??
            this.canRequestCertificateOfDeposit,
        canRequestStatement: canRequestStatement ?? this.canRequestStatement,
      );
}
