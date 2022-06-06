import '../../../dtos.dart';
import '../../../helpers.dart';

///Data transfer object that represents the offers response from the API
class OfferResponseDTO {
  ///The total amount of offers for the query made
  int? totalCount;

  ///The requested list of offers
  List<OfferDTO>? offers;

  ///Creates a [OfferResponseDTO]
  OfferResponseDTO({
    this.totalCount,
    this.offers,
  });

  ///Creates a [OfferResponseDTO] from a JSON object
  factory OfferResponseDTO.fromJson(Map<String, dynamic> json) =>
      OfferResponseDTO(
        totalCount: JsonParser.parseInt(json['count']),
        offers: OfferDTO.fromJsonList(json['offers']),
      );
}
