import '../../encryption.dart';

/// A strategy that defines encryption for
/// [MobileAndCardRegistrationParameters].
class MobileAndCardRegistrationEncryptionStrategy
    extends RegistrationEncryptionStrategy<
        MobileAndCardRegistrationParameters> {
  /// Creates [MobileAndCardRegistrationEncryptionStrategy].
  MobileAndCardRegistrationEncryptionStrategy({
    required String encryptionKey,
  }) : super(encryptionKey);

  @override
  Map<String, dynamic> getDictionary(
    MobileAndCardRegistrationParameters parameters,
  ) {
    if (parameters.cardNumber == null ||
        parameters.cardNumber!.length < 10 ||
        parameters.mobileNumber == null ||
        parameters.mobileNumber!.isEmpty ||
        parameters.expiryDate == null ||
        parameters.expiryDate!.length != 5 ||
        // Expiry date needs to follow the MM/YY format
        !RegExp(r'[0-9]{2}\/[0-9]{2}').hasMatch(parameters.expiryDate!) ||
        parameters.cvv == null ||
        parameters.cvv!.isEmpty) {
      throw ArgumentError.value(
        parameters,
        'parameters',
        'The parameters are invalid',
      );
    }
    final firstSix = parameters.cardNumber!.substring(0, 6);
    final lastFour = parameters.cardNumber!.substring(
      parameters.cardNumber!.length - 4,
      parameters.cardNumber!.length,
    );
    final obscuredMiddleDigits = List<String>.generate(
      parameters.cardNumber!.length - 10,
      (index) => 'X',
    ).join();
    final expiryDateSplit = parameters.expiryDate!.split('/');
    final expiryDate = '20${expiryDateSplit[1]}-${expiryDateSplit[0]}';
    return {
      'mobile_number': parameters.mobileNumber,
      'card_no': firstSix + obscuredMiddleDigits + lastFour,
      'card_expiry_date': expiryDate,
      'cvv': parameters.cvv,
    };
  }
}
