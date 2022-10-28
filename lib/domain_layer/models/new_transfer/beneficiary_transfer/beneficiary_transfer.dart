import 'dart:convert';

import '../../../../data_layer/dtos.dart';
import '../../../../data_layer/mappings.dart';
import '../../../models.dart';

/// The available destination beneficiary types.
enum DestinationBeneficiaryType {
  /// The beneficiary is new.
  newBeneficiary,

  /// The beneficiary is a current one.
  currentBeneficiary,
}

/// The new beneficiary transfer flow.
class BeneficiaryTransfer extends NewSchedulableTransfer {
  /// The transfer reason.
  final String? reason;

  /// The destination beneficiary type.
  ///
  /// Default is [DestinationBeneficiaryType.newBeneficiary].
  final DestinationBeneficiaryType beneficiaryType;

  /// A beneficiary that was created during the beneficiary transfer flow.
  final NewBeneficiary? newBeneficiary;

  /// Creates a new [BeneficiaryTransfer].
  const BeneficiaryTransfer({
    super.type,
    super.source,
    super.amount,
    super.currency,
    super.destination,
    this.reason,
    super.scheduleDetails,
    this.beneficiaryType = DestinationBeneficiaryType.newBeneficiary,
    this.newBeneficiary,
    super.saveToShortcut,
    super.shortcutName,
    super.note,
    super.transferId,
    super.deviceUID,
  }) : super();

  /// Whether if the beneficiary transfer is ready to be submitted or not.
  @override
  bool canBeSubmitted() =>
      type != null &&
      source?.account != null &&
      amount != null &&
      amount! > 0 &&
      currency != null &&
      currency?.code != null &&
      ((beneficiaryType == DestinationBeneficiaryType.currentBeneficiary &&
              destination?.beneficiary != null) ||
          (beneficiaryType == DestinationBeneficiaryType.newBeneficiary &&
              newBeneficiary != null &&
              (newBeneficiary?.canBeSubmitted ?? false))) &&
      (scheduleDetails.recurrence == Recurrence.none ||
          scheduleDetails.startDate != null) &&
      (!saveToShortcut || (shortcutName?.isNotEmpty ?? false));

  /// Creates a new [BeneficiaryTransfer] with the passed values.
  @override
  BeneficiaryTransfer copyWith({
    TransferType? type,
    NewTransferSource? source,
    double? amount,
    Currency? currency,
    NewTransferDestination? destination,
    String? reason,
    ScheduleDetails? scheduleDetails,
    DestinationBeneficiaryType? beneficiaryType,
    NewBeneficiary? newBeneficiary,
    bool? saveToShortcut,
    String? shortcutName,
    String? note,
    int? transferId,
    String? deviceUID,
  }) =>
      BeneficiaryTransfer(
        transferId: transferId ?? this.transferId,
        type: type ?? super.type,
        source: source ?? super.source,
        amount: amount ?? super.amount,
        currency: currency ?? super.currency,
        destination: destination ?? super.destination,
        reason: reason ?? this.reason,
        scheduleDetails: scheduleDetails ?? this.scheduleDetails,
        beneficiaryType: beneficiaryType ?? this.beneficiaryType,
        newBeneficiary: newBeneficiary ?? this.newBeneficiary,
        saveToShortcut: saveToShortcut ?? this.saveToShortcut,
        shortcutName: !(saveToShortcut ?? this.saveToShortcut)
            ? null
            : shortcutName ?? this.shortcutName,
        note: note ?? this.note,
        deviceUID: deviceUID ?? this.deviceUID,
      );

  /// Converts to [NewTransferPayloadDTO]
  @override
  NewTransferPayloadDTO toNewTransferPayloadDTO() {
    if (!canBeSubmitted()) {
      throw Exception('Uncompleted transfer');
    }

    return NewTransferPayloadDTO(
      type: type!.toTransferTypeDTO(),
      fromAccountId: source?.account?.id,
      amount: amount!,
      currencyCode: currency!.code!,
      toBeneficiaryId:
          beneficiaryType == DestinationBeneficiaryType.newBeneficiary
              ? null
              : destination?.beneficiary?.id,
      newBeneficiary:
          beneficiaryType == DestinationBeneficiaryType.currentBeneficiary
              ? null
              : newBeneficiary?.toBeneficiaryDTO(),
      reason: reason,
      extra: beneficiaryType == DestinationBeneficiaryType.currentBeneficiary
          ? jsonDecode(destination?.beneficiary?.extra ?? '')
          : null,
      recurrence: scheduleDetails.recurrence.toRecurrenceDTO(),
      startDate: scheduleDetails.startDate,
      endDate: scheduleDetails.endDate,
      note: note,
      transferId: transferId,
      deviceUID: deviceUID,
    );
  }

  @override
  List<Object?> get props => [
        type,
        source,
        amount,
        currency,
        destination,
        reason,
        scheduleDetails,
        beneficiaryType,
        newBeneficiary,
        saveToShortcut,
        shortcutName,
        note,
        transferId,
        deviceUID,
      ];
}
