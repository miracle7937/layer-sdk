import '../../../models.dart';
import '../../dtos.dart';
import '../../mappings.dart';

///Extension for mapping the [OfferResponseDTO]
extension OfferResponseDTOMapping on OfferResponseDTO {
  ///Maps a [OfferResponseDTO] into a [OfferResponse]
  OfferResponse toOfferResponse() => OfferResponse(
        totalCount: totalCount ?? 0,
        offers: offers?.map((dtoOffer) => dtoOffer.toOffer()).toList() ?? [],
      );
}
