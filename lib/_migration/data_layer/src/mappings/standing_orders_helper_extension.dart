import '../../../../domain_layer/models.dart';

/// Helper extension for [StandingOrder].
extension StandingOrderHelperExtension on StandingOrder {
  /// Returns the display name for the source of the standing order.
  String? toSourceName() =>
      fromAccount?.accountInfo?.accountName ??
      fromAccount?.accountInfo?.accountType?.index.toString() ??
      fromCard?.maskedCardNumber ??
      fromMobile;

  /// Returns the display name for the destination of the standing order.
  String? toDestinationName() =>
      toAccount?.accountInfo?.accountName ??
      toAccount?.accountInfo?.accountType?.index.toString() ??
      toCard?.maskedCardNumber ??
      toBeneficiary?.displayName;

  /// Returns the source account/card/beneficiary number
  String? toSourceNumber() =>
      fromAccount?.formattedAccountNumber ??
      fromAccount?.accountNumber ??
      fromCard?.maskedCardNumber ??
      fromMobile;

  /// Returns the destination account/card/beneficiary number
  String? toDestinationNumber() =>
      toAccount?.formattedAccountNumber ??
      toAccount?.accountNumber ??
      toCard?.maskedCardNumber ??
      toBeneficiary?.accountNumber;
}
