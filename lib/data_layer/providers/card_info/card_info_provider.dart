import 'dart:async';
import 'dart:convert';

import 'package:pointycastle/pointycastle.dart';

import '../../../../data_layer/network.dart';
import '../../../_migration/data_layer/encryption.dart';
import '../../dtos.dart';

/// Provides the card info for cards.
class CardInfoProvider {
  /// NetClient used for network requests
  final NetClient _netClient;

  /// The cipher for decrpyting the card info response.
  final RSACipher _cipher = RSACipher();

  /// The key sent in every request for encrypting the card info.
  late dynamic _key;

  /// Key pair for decrypting the card info response.
  late AsymmetricKeyPair<PublicKey, PrivateKey> _keyPair;

  /// Creates a new [CardInfoProvider] instance
  CardInfoProvider({
    required NetClient netClient,
  }) : _netClient = netClient {
    _generateRSACipherValues();
  }

  /// Generates the RSA Cipher elements needed for decrypting the card info
  /// response.
  void _generateRSACipherValues() {
    _keyPair = _cipher.generateKeyPair();
    _key = _cipher.encodePublicKeyToPem(_keyPair.publicKey as RSAPublicKey);
  }

  /// Returns the [CardInfoDTO] for the passed [cardId].
  Future<CardInfoDTO> getCardInfo({
    required String cardId,
  }) async {
    final response = await _netClient.request(
      _netClient.netEndpoints.cardInfo,
      method: NetRequestMethods.post,
      data: {
        /// TODO: Change this back to a String when the BE solves the
        /// issue with parsing on their end.
        'card_id': int.tryParse(cardId) ?? 0,
        'key': _key,
      },
    );

    return CardInfoDTO.fromJson(
      _decryptCardInfo(
        cardInfoResponse: response.data,
      ),
    );
  }

  /// Returns the [CardInfoDTO] resulting on sending the OTP code for the
  /// passed [cardId].
  ///
  /// Used for resending the OTP code aswell.
  Future<CardInfoDTO> sendOTPCode({
    required String cardId,
  }) async {
    final response = await _netClient.request(
      _netClient.netEndpoints.cardInfo,
      method: NetRequestMethods.post,
      data: {
        /// TODO: Change this back to a String when the BE solves the
        /// issue with parsing on their end.
        'card_id': int.tryParse(cardId) ?? 0,
        'key': _key,
        'second_factor': SecondFactorTypeDTO.otp.value,
      },
    );

    return CardInfoDTO.fromJson(
      _decryptCardInfo(
        cardInfoResponse: response.data,
      ),
    );
  }

  /// Returns the [CardInfoDTO] resulting on verifying the second factor for
  /// the passed [cardId].
  Future<CardInfoDTO> verifySecondFactor({
    required String cardId,
    required String value,
    required SecondFactorTypeDTO secondFactorTypeDTO,
  }) async {
    final response = await _netClient.request(
      _netClient.netEndpoints.cardInfo,
      method: NetRequestMethods.post,
      queryParameters: {
        'second_factor_verification': true,
      },
      data: {
        /// TODO: Change this back to a String when the BE solves the
        /// issue with parsing on their end.
        'card_id': int.tryParse(cardId) ?? 0,
        'key': _key,
        'second_factor': secondFactorTypeDTO.value,
        if (secondFactorTypeDTO == SecondFactorTypeDTO.ocra)
          'client_response': value,
        if (secondFactorTypeDTO == SecondFactorTypeDTO.otp) 'otp_value': value,
      },
    );

    return CardInfoDTO.fromJson(
      _decryptCardInfo(
        cardInfoResponse: response.data,
      ),
    );
  }

  /// Retruns the JSON Object resulting on decrypting the passed the card info
  /// encrypted response.
  Map<String, dynamic> _decryptCardInfo({
    required Map<String, dynamic> cardInfoResponse,
  }) {
    final secondFactor = cardInfoResponse['second_factor'];
    final cardInfo = cardInfoResponse['cardInfo'];

    if (cardInfo != null && secondFactor == null) {
      final decrypted = _cipher.decryptBase64(
        base64.decode(cardInfo),
        _keyPair.privateKey as RSAPrivateKey,
      );

      try {
        return json.decode(decrypted);
      } on Exception {
        throw Exception('Invalid response');
      }
    }

    return cardInfoResponse;
  }
}
