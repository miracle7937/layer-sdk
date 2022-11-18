import '../../../../../domain_layer/models.dart';

/// Helper extension for [Transfer].
extension TransferHelperExtension on Transfer {
  /// Returns the display name for the source of the transfer.
  String? fromSourceName() =>
      fromAccount?.accountInfo?.accountName ??
      fromAccount?.accountInfo?.accountType?.index.toString() ??
      fromCard?.maskedCardNumber ??
      fromMobile;

  /// Returns the display name for the destination of the transfer.
  String? toDestinationName() =>
      toAccount?.accountInfo?.accountName ??
      toAccount?.accountInfo?.accountType?.index.toString() ??
      toCard?.nickname ??
      toCard?.type.name ??
      toBeneficiary?.displayName;

  /// Returns the source account/card/beneficiary number
  String? fromSourceNumber({bool ibanFirst = true}) =>
      fromAccount?.getNumber(ibanFirst: ibanFirst) ??
      fromCard?.maskedCardNumber ??
      fromMobile;

  /// Returns the destination account/card/beneficiary number
  String? toDestinationNumber({bool ibanFirst = true}) =>
      toAccount?.getNumber(ibanFirst: ibanFirst) ??
      toCard?.maskedCardNumber ??
      toBeneficiary?.accountNumber;
}
