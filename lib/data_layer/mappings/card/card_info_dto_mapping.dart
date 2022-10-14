import '../../../domain_layer/models.dart';
import '../../dtos.dart';
import '../../mappings.dart';

/// Extension that provides mapping for [CardInfoDTO]
extension CardInfoDTOMapping on CardInfoDTO {
  /// Maps a [CardInfoDTO] instance to a [CardInfo] model
  CardInfo toCardInfo() => CardInfo(
        cardPin: cardPin,
        expiryDate: expiryDate,
        unmaskedCardNumber: unmaskedCardNumber,
        otpId: otpId,
        secondFactorType: secondFactorType?.toSecondFactorType(),
      );
}
