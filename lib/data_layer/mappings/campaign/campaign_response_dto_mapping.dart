import '../../../domain_layer/models.dart';
import '../../dtos.dart';
import '../../mappings.dart';

///Extension for mapping the [CampaignResponseDTO]
extension CampaignResponseDTOMapping on CampaignResponseDTO {
  ///Maps a [CampaignResponseDTO] into a [CampaignResponse]
  CampaignResponse toCampaignResponse() => CampaignResponse(
        totalCount: totalCount ?? 0,
        campaigns: campaigns
                ?.map((dtoCampaign) => dtoCampaign.toCampaign())
                .toList() ??
            [],
      );
}
