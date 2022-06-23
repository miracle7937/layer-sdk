import '../../../domain_layer/models.dart';
import '../../dtos.dart';
import '../../mappings.dart';

/// Provides mapping for [CheckbookDTO]
extension CheckbookDTOMapping on CheckbookDTO {
  /// Maps into [Checkbook]
  Checkbook toCheckbook() => Checkbook(
        id: id,
        accountId: accountId ?? '',
        chargeAmount: chargeAmount,
        chargeCurrency: chargeCurrency ?? '',
        checkbookTypeId: checkbookTypeId ?? '',
        checkbookType: checkbookType?.toCheckbookType(),
        created: created,
        updated: updated,
        customerId: customerId ?? '',
        reference: reference ?? '',
        systemNotes: systemNotes ?? '',
        username: username ?? '',
        account: account?.toAccount(),
        status: toCheckbookStatus(),
      );

  /// Maps into [CheckbookStatus]
  CheckbookStatus toCheckbookStatus() {
    switch (status) {
      case "O":
        return CheckbookStatus.otp;
      case "S":
        return CheckbookStatus.customersScheduled;
      case "P":
        return CheckbookStatus.customersInprogress;
      case "A":
        return CheckbookStatus.accepted;
      case "C":
        return CheckbookStatus.customersComplete;
      case "F":
        return CheckbookStatus.customersFailed;
      case "X":
        return CheckbookStatus.customersCanceled;
      case "R":
        return CheckbookStatus.rejected;
      case "E":
        return CheckbookStatus.pendingExpired;
      case "T":
        return CheckbookStatus.otpExpired;
      default:
        return CheckbookStatus.unknown;
    }
  }
}

/// Provides mapping for [CheckbookTypeDTO]
extension CheckbookTypeDTOMapping on CheckbookTypeDTO {
  /// Maps into [CheckbookType]
  CheckbookType toCheckbookType() => CheckbookType(
        checkbookTypeId: checkbookTypeId ?? '',
        created: created,
        updated: updated,
        start: start,
        end: end,
        fees: fees,
        leaves: leaves,
        maxCheckbooks: maxCheckbooks,
        maxPending: maxPending,
      );
}

/// Provides mapping for [CheckbookSort]
extension CheckbookSortExtension on CheckbookSort {
  /// Maps into [String]
  String? toFieldName() {
    switch (this) {
      case CheckbookSort.leaves:
        return 'checkbook_type.leaves';
    }
  }
}
