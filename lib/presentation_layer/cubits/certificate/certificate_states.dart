import 'dart:collection';

import 'package:equatable/equatable.dart';

import '../../../../domain_layer/models.dart';

/// All possible actions for the [CertificateCubit]
enum CertificateStatesActions {
  /// No action
  none,

  /// Certificate was requested successfully
  certificateRequestedSuccessfully,

  /// Certificate request failed
  certificateRequestFailed,

  /// No transactions was found on the provided time period.
  noTransactionsFound,
}

/// Represents the state of [CertificateCubit]
class CertificateStates extends Equatable {
  /// The last performed action
  final CertificateStatesActions action;

  /// The customer to be used by the request
  final Customer? customer;

  /// The account to be used by the request
  final Account? account;

  /// Whether or not the cubit is busy
  final bool busy;

  /// The request file list of bytes
  final UnmodifiableListView<int>? certificateBytes;

  /// The start date range of the desired certificate
  final DateTime? startDate;

  /// The end date range of the desired certificate
  final DateTime? endDate;

  /// The selected file extension/type to be downloaded
  final FileType fileType;

  /// Creates a new [CertificateStates] instance
  CertificateStates({
    this.action = CertificateStatesActions.none,
    this.customer,
    this.account,
    this.busy = false,
    Iterable<int>? certificateBytes,
    this.startDate,
    this.endDate,
    this.fileType = FileType.image,
  }) : certificateBytes = certificateBytes == null
            ? null
            : UnmodifiableListView(certificateBytes);

  @override
  List<Object?> get props => [
        action,
        customer,
        account,
        certificateBytes,
        busy,
        startDate,
        endDate,
        fileType,
      ];

  /// Creates a new instance from the current data
  CertificateStates copyWith({
    CertificateStatesActions? action,
    Customer? customer,
    Account? account,
    bool? busy,
    Iterable<int>? certificateBytes,
    DateTime? startDate,
    DateTime? endDate,
    FileType? fileType,
  }) {
    return CertificateStates(
      action: action ?? this.action,
      customer: customer ?? this.customer,
      account: account ?? this.account,
      busy: busy ?? this.busy,
      certificateBytes: certificateBytes ?? this.certificateBytes,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      fileType: fileType ?? this.fileType,
    );
  }
}
