import 'package:equatable/equatable.dart';

import '../../models.dart';

/// All the Checkbook data needed by the application
class Checkbook extends Equatable {
  /// Checkbook ID
  final int? id;

  /// The date the checkbook was created
  final DateTime? created;

  /// The date the checkbook was updated
  final DateTime? updated;

  /// The checkbook type ID
  final String checkbookTypeId;

  /// The checkbook type
  final CheckbookType? checkbookType;

  /// The account ID for which this checkbook was created
  final String accountId;

  /// The account for which this checkbook was created
  final Account? account;

  /// The charge amount
  final int? chargeAmount;

  /// The charge currency
  final String chargeCurrency;

  /// The reference
  final String reference;

  /// The system notes
  final String systemNotes;

  /// The customer id this checkbook belongs to
  final String customerId;

  /// The username this checkbook belongs to
  final String username;

  /// The checkbook status
  final CheckbookStatus status;

  /// Creates a new [Checkbook]
  Checkbook({
    this.id,
    this.created,
    this.updated,
    this.checkbookTypeId = '',
    this.checkbookType,
    this.accountId = '',
    this.account,
    this.chargeAmount,
    this.chargeCurrency = '',
    this.reference = '',
    this.systemNotes = '',
    this.customerId = '',
    this.username = '',
    this.status = CheckbookStatus.unknown,
  });

  @override
  List<Object?> get props => [
        id,
        created,
        updated,
        checkbookTypeId,
        checkbookType,
        accountId,
        account,
        chargeAmount,
        chargeCurrency,
        reference,
        systemNotes,
        customerId,
        username,
        status,
      ];
}

/// All the Checkbook Type data needed by the application
class CheckbookType extends Equatable {
  /// The checkbook type ID
  final String checkbookTypeId;

  /// The date the checkbook type was created
  final DateTime? created;

  /// The date the checkbook type was updated
  final DateTime? updated;

  /// The number of leaves
  final int? leaves;

  /// The start date
  final DateTime? start;

  /// The end date
  final DateTime? end;

  /// The maximum number of checkbooks per request
  final int? maxCheckbooks;

  /// The maximum number of checkbooks pending delivery
  final int? maxPending;

  /// The fees
  final int? fees;

  /// Creates a new [CheckbookType]
  CheckbookType({
    this.checkbookTypeId = '',
    this.created,
    this.updated,
    this.leaves,
    this.start,
    this.end,
    this.maxCheckbooks,
    this.maxPending,
    this.fees,
  });

  @override
  List<Object?> get props => [
        checkbookTypeId,
        created,
        updated,
        leaves,
        start,
        end,
        maxCheckbooks,
        maxPending,
        fees,
      ];
}

/// Status of a [Checkbook]
enum CheckbookStatus {
  /// OTP
  otp,

  /// Scheduled
  customersScheduled,

  /// In progress
  customersInprogress,

  /// Accepted
  accepted,

  /// Completed
  customersComplete,

  /// Failed
  customersFailed,

  /// Canceled
  customersCanceled,

  /// Rejected
  rejected,

  /// Pending expired
  pendingExpired,

  /// OTP expired
  otpExpired,

  /// Unknown
  unknown,
}

/// All the fields that can be used to sort customer checkbooks
enum CheckbookSort {
  /// The checkbook type number of leaves
  leaves,
}
