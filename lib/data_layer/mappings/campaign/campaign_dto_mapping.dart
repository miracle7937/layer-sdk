import '../../../domain_layer/models.dart';
import '../../dtos.dart';
import '../../environment.dart';
import '../../errors.dart';

///Extension for mapping the [CustomerCampaignDTO]
extension CampaignDTOMapping on CustomerCampaignDTO {
  ///Maps an [OfferDTO] into an [Offer]
  CustomerCampaign toCampaign() => CustomerCampaign(
        id: id,
        startDate: startDate,
        medium: medium?.toCampaignType(),
        message: message,
        action: action?.toCampaignActionType(),
        actionMessage: actionMessage,
        actionValue: actionValue,
        title: title,
        messageType: messageType,
        description: description,
        html: html,
        imageUrl: imageUrl != null && imageUrl!.isNotEmpty
            ? '${EnvironmentConfiguration.current.fullUrl}/infobanking/v1'
                '$imageUrl'
            : null,
        thumbnailUrl: thumbnailUrl != null && thumbnailUrl!.isNotEmpty
            ? '${EnvironmentConfiguration.current.fullUrl}/infobanking/v1'
                '$thumbnailUrl'
            : null,
        videoUrl: videoUrl != null && videoUrl!.isNotEmpty
            ? '${EnvironmentConfiguration.current.fullUrl}/infobanking/v1'
                '$videoUrl'
            : null,
        shareVideo: shareVideo,
        target: target?.toCampaignTarget(),
        referenceImage: referenceImage,
        updatedAt: updatedAt.toString(),
      );
}

///Extension for mapping the [CampaignTypeDTO]
extension CampaignTypeDTOMapping on CampaignTypeDTO {
  ///Maps a [CampaignTypeDTO] into a [CampaignType]
  CampaignType toCampaignType() {
    switch (this) {
      case CampaignTypeDTO.container:
        return CampaignType.container;
      case CampaignTypeDTO.arCampaign:
        return CampaignType.arCampaign;
      case CampaignTypeDTO.inbox:
        return CampaignType.inbox;
      case CampaignTypeDTO.all:
        return CampaignType.all;
      case CampaignTypeDTO.landingPage:
        return CampaignType.landingPage;
      case CampaignTypeDTO.popup:
        return CampaignType.popup;
      case CampaignTypeDTO.transactionPopup:
        return CampaignType.transactionPopup;
      default:
        throw MappingException(from: CampaignTypeDTO, to: CampaignType);
    }
  }
}

///Extension for mapping the [CampaignActionTypeDTO]
extension CampaignActionTypeDTOMapping on CampaignActionTypeDTO {
  ///Maps a [CampaignActionTypeDTO] into a [CampaignActionType]
  CampaignActionType toCampaignActionType() {
    switch (this) {
      case CampaignActionTypeDTO.call:
        return CampaignActionType.call;
      case CampaignActionTypeDTO.sendMessage:
        return CampaignActionType.sendMessage;
      case CampaignActionTypeDTO.callOrSend:
        return CampaignActionType.callOrSend;
      case CampaignActionTypeDTO.dpa:
        return CampaignActionType.dpa;
      case CampaignActionTypeDTO.dpa:
        return CampaignActionType.dpa;
      case CampaignActionTypeDTO.openLink:
        return CampaignActionType.openLink;
      case CampaignActionTypeDTO.none:
        return CampaignActionType.none;
      default:
        throw MappingException(
            from: CampaignActionTypeDTO, to: CampaignActionType);
    }
  }
}

///Extension for mapping the [CampaignTargetDTO]
extension CampaignTargetDTOMapping on CampaignTargetDTO {
  ///Maps a [CampaignActionTypeDTO] into a [CampaignTarget]
  CampaignTarget toCampaignTarget() {
    switch (this) {
      case CampaignTargetDTO.public:
        return CampaignTarget.public;
      case CampaignTargetDTO.targeted:
        return CampaignTarget.targeted;
      case CampaignTargetDTO.none:
        return CampaignTarget.none;
      default:
        throw MappingException(from: CampaignTargetDTO, to: CampaignTarget);
    }
  }
}
