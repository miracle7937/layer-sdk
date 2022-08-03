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
  final Message? reason;

  /// The destination beneficiary type.
  /// Default is [DestinationBeneficiaryType.newBeneficiary].
  final DestinationBeneficiaryType beneficiaryType;

  /// A beneficiary that was created during the beneficiary transfer flow.
  final NewBeneficiary? newBeneficiary;

  /// Creates a new [BeneficiaryTransfer].
  BeneficiaryTransfer({
    super.type,
    super.source,
    super.amount,
    super.currency,
    super.destination,
    this.reason,
    super.recurrence = Recurrence.none,
    super.starts,
    super.ends,
    this.beneficiaryType = DestinationBeneficiaryType.newBeneficiary,
    this.newBeneficiary,
    super.saveToShortcut,
    super.shortcutName,
    super.note,
  }) : super();

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
      (recurrence == Recurrence.none || starts != null) &&
      (!saveToShortcut || (shortcutName?.isNotEmpty ?? false));

  @override
  BeneficiaryTransfer copyWith({
    TransferType? type,
    NewTransferSource? source,
    double? amount,
    Currency? currency,
    NewTransferDestination? destination,
    Message? reason,
    Recurrence? recurrence,
    DateTime? starts,
    DateTime? ends,
    DestinationBeneficiaryType? beneficiaryType,
    NewBeneficiary? newBeneficiary,
    bool? saveToShortcut,
    String? shortcutName,
    String? note,
  }) =>
      BeneficiaryTransfer(
        type: type ?? super.type,
        source: source ?? super.source,
        amount: amount ?? super.amount,
        currency: currency ?? super.currency,
        destination: destination ?? super.destination,
        reason: reason ?? this.reason,
        recurrence: recurrence ?? super.recurrence,
        starts: starts ?? super.starts,
        ends: ends ?? super.ends,
        beneficiaryType: beneficiaryType ?? this.beneficiaryType,
        newBeneficiary: newBeneficiary ?? this.newBeneficiary,
        saveToShortcut: saveToShortcut ?? this.saveToShortcut,
        shortcutName: !(saveToShortcut ?? this.saveToShortcut)
            ? null
            : shortcutName ?? this.shortcutName,
        note: note ?? this.note,
      );

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
      reason: reason?.id,
      extra: beneficiaryType == DestinationBeneficiaryType.currentBeneficiary
          ? jsonDecode(destination?.beneficiary?.extra ?? '')
          : null,
      recurrence: recurrence.toRecurrenceDTO(),
      startDate: starts,
      endDate: ends,
      note: note,
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
        recurrence,
        starts,
        ends,
        beneficiaryType,
        newBeneficiary,
        saveToShortcut,
        shortcutName,
        note,
      ];
}
