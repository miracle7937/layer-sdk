import 'dart:async';
import 'dart:convert';

import 'package:pointycastle/pointycastle.dart';

import '../../../../data_layer/network.dart';
import '../../../_migration/data_layer/src/encryption/rsa_cipher.dart';
import '../../../_migration/data_layer/src/helpers/dto_helpers.dart';
import '../../dtos.dart';

/// Provides data related to Cards
class CardProvider {
  /// NetClient used for network requests
  final NetClient netClient;

  /// Creates a new [CardProvider] instance
  CardProvider(
    this.netClient,
  ) {
    _generateKey();
  }

  late RSACipher _cipher;
  late dynamic _key;
  late AsymmetricKeyPair<PublicKey, PrivateKey> _keyPair;

  void _generateKey() {
    _cipher = RSACipher();
    _keyPair = _cipher.generateKeyPair();
    _key = _cipher.encodePublicKeyToPem(_keyPair.publicKey as RSAPublicKey);
  }

  /// Returns all cards of the supplied customer
  Future<List<CardDTO>> listCustomerCards({
    String? customerId,
    bool includeDetails = true,
    bool forceRefresh = false,
  }) async {
    final response = await netClient.request(
      netClient.netEndpoints.card,
      method: NetRequestMethods.get,
      queryParameters: {
        if (isNotEmpty(customerId)) 'customer_id': customerId,
        'include_details': includeDetails,
      },
      forceRefresh: forceRefresh,
    );

    return CardDTO.fromJsonList(
      List<Map<String, dynamic>>.from(response.data),
    );
  }

  /// Returns all completed transactions of the supplied customer card
  Future<List<CardTransactionDTO>> listCustomerCardTransactions({
    required String cardId,
    String? customerId,
    int limit = 50,
    int offset = 0,
    bool forceRefresh = false,
  }) async {
    final response = await netClient.request(
      netClient.netEndpoints.transaction,
      method: NetRequestMethods.get,
      queryParameters: {
        'customer_id': customerId,
        'card_id': cardId,
        'status': 'C',
        'limit': limit,
        'offset': offset,
      },
      forceRefresh: forceRefresh,
    );

    return CardTransactionDTO.fromJsonList(
      List<Map<String, dynamic>>.from(response.data),
    );
  }
}
