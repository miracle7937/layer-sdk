import '../../dtos.dart';
import '../../helpers.dart';

///Data transfer object that represents the campaigns response from the API
class CampaignResponseDTO {
  ///The total amount of campaigns for the query made
  int? totalCount;

  ///The requested list of campaigns
  List<CustomerCampaignDTO>? campaigns;

  ///Creates a [CampaignResponseDTO]
  CampaignResponseDTO({
    this.totalCount,
    this.campaigns,
  });

  ///Creates a [CampaignResponseDTO] from a JSON object
  factory CampaignResponseDTO.fromJson(Map<String, dynamic> json) =>
      CampaignResponseDTO(
        totalCount: JsonParser.parseInt(json['count']),
        campaigns: CustomerCampaignDTO.fromJsonList(
          List<Map<String, dynamic>>.from(json['campaigns']),
        ),
      );
}
