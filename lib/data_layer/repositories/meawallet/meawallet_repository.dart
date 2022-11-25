import 'package:meawallet_plugin/meawallet_plugin.dart';
import 'package:meawallet_plugin/models/get_card_details_param.dart';

import '../../../domain_layer/abstract_repositories.dart';
import '../../providers.dart';

/// Handles the data from the Meawallet plugin.
class MeawalletRepository implements MeawalletRepositoryInterface {
  final MeawalletProvider _provider;

  /// Creates a new [MeawalletRepository] instance
  MeawalletRepository({
    required MeawalletProvider provider,
  }) : _provider = provider;

  /// Returns Meawallet OTOP secret for the passed [cardToken].
  @override
  Future<String> getSecretFromCardToken({
    required String cardToken,
  }) =>
      _provider.getSecretFromCardToken(
        cardToken: cardToken,
      );

  /// Returns the [CardDetails] from Meawalet for the passed [cardId] and
  /// OTOP [secret].
  @override
  Future<CardDetails> getCardDetails({
    required String cardId,
    required String secret,
  }) =>
      MeawalletPlugin.getCardDetails(
        cardId,
        secret,
      );
}
