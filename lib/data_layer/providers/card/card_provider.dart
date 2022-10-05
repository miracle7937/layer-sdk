import 'dart:async';
import 'dart:convert';

import 'package:pointycastle/pointycastle.dart';

import '../../../../data_layer/network.dart';
import '../../../_migration/data_layer/src/encryption/rsa_cipher.dart';
import '../../../_migration/data_layer/src/helpers/dto_helpers.dart';
import '../../../domain_layer/models/second_factor/second_factor_type.dart';
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

  /// Returns the card info for the specified card
  Future<CardInfoDTO> getCardInfo({
    required int cardId,
    int? otpId,
    String? otpValue,
    SecondFactorType? secondFactorType,
    String? clientResponse,
    bool forceRefresh = false,
  }) async {
    final response = await netClient.request(
      netClient.netEndpoints.cardInfo,
      method: NetRequestMethods.post,
      queryParameters: {
        if (otpValue != null || clientResponse != null)
          'second_factor_verification': true,
      },
      data: {
        "card_id": cardId,
        "key": _key,
        if (secondFactorType != null)
          "second_factor":
              secondFactorType == SecondFactorType.otp ? "OTP" : "OCRA",
        if (clientResponse != null && secondFactorType != SecondFactorType.otp)
          "client_response": clientResponse,
        if (otpId != null && secondFactorType == SecondFactorType.otp)
          "otp_id": otpId,
        if (otpValue != null && secondFactorType == SecondFactorType.otp)
          "otp_value": otpValue,
      },
      forceRefresh: forceRefresh,
    );

    if (response.data != null) {
      return CardInfoDTO.fromJson(_decryptCardInfo(response.data));
    }

    throw Exception('Invalid response');
  }

  Map<String, dynamic> _decryptCardInfo(dynamic data) {
    if (data is Map<String, dynamic> &&
        data['second_factor'] != null &&
        data['card_info'] == null) {
      return data;
    } else if (data is Map<String, dynamic> && data['card_info'] != null) {
      final decrypted = _cipher.decryptBase64(
        base64.decode(data['card_info']),
        _keyPair.privateKey as RSAPrivateKey,
      );
      try {
        return json.decode(decrypted);
      } on Exception {
        throw Exception('Invalid response');
      }
    }
    return data;
  }
}
