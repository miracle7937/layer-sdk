import 'package:meawallet_plugin/models/get_card_details_param.dart';

/// Abstract repository for the meawallet plugin.
abstract class MeawalletRepositoryInterface {
  /// Returns Meawallet OTOP secret for the passed [cardToken].
  Future<String> getSecretFromCardToken({
    required String cardToken,
  });

  /// Returns the [CardDetails] from Meawalet for the passed OTOP [secret].
  Future<CardDetails> getCardDetails({
    required String cardId,
    required String secret,
  });
}
