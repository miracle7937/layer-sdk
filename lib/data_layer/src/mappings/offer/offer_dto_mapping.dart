import '../../../environment.dart';
import '../../../errors.dart';
import '../../../models.dart';
import '../../dtos.dart';
import '../../mappings.dart';

///Extension for mapping the [OfferDTO]
extension OfferDTOMapping on OfferDTO {
  ///Maps an [OfferDTO] into an [Offer]
  Offer toOffer() {
    if ([
      id,
      status,
      type,
    ].contains(null)) {
      throw MappingException(
        from: OfferDTO,
        to: Offer,
        value: this,
        details: 'One of the required parameters is null',
      );
    }
    return Offer(
      id: id!,
      consoleName: consoleName,
      customerName: customerName,
      starts: starts,
      ends: ends,
      imageURL: imageURL != null && imageURL!.isNotEmpty
          ? '${EnvironmentConfiguration.current.fullUrl}/infobanking/v1'
              '$imageURL'
          : null,
      description: description,
      shortDescription: shortDescription,
      tncURL: tncURL == null
          ? null
          : '${EnvironmentConfiguration.current.fullUrl}/infobanking/v1'
              '$tncURL',
      tncText: tncText,
      status: status!.toOfferStatus(),
      merchant: merchant?.toMerchant() ?? Merchant(),
      rules: rules == null
          ? null
          : rules!.map((rule) => rule.toOfferRule()).toList(),
      type: type!.toOfferType(),
      currency: currency,
    );
  }
}

///Extension for mapping the [MerchantDTO]
extension MerchantDTOMapping on MerchantDTO {
  ///Maps a [MerchantDTO] into a [Merchant]
  Merchant toMerchant() => Merchant(
        id: id,
        redemptionType: redemptionType?.toRedemptionType(),
        categories: categories?.map((e) => e.toCategory()).toList(),
        description: description,
        imageURL: imageURL != null && imageURL!.isNotEmpty
            ? '${EnvironmentConfiguration.current.fullUrl}/infobanking/v1'
                '$imageURL'
            : null,
        locations: locations?.map((e) => e.toMerchantLocation()).toList(),
        name: name,
        created: created,
        updated: updated,
      );
}

///Extension for mapping the [RedemptionTypeDTO]
extension RedemptionTypeDTOMapping on RedemptionTypeDTO {
  ///Maps a [RedemptionTypeDTO] into a [RedemptionType]
  RedemptionType toRedemptionType() {
    switch (this) {
      case RedemptionTypeDTO.cardActivation:
        return RedemptionType.cardActivation;
      case RedemptionTypeDTO.cardNoActivation:
        return RedemptionType.cardNoActivation;
      case RedemptionTypeDTO.couponQR:
        return RedemptionType.couponQR;
      case RedemptionTypeDTO.voucherNoActivation:
        return RedemptionType.voucherNoActivation;
      case RedemptionTypeDTO.voucherActivation:
        return RedemptionType.voucherActivation;
      default:
        throw MappingException(from: RedemptionTypeDTO, to: RedemptionType);
    }
  }
}

///Extension for mapping the [MerchantLocationDTO]
extension MerchantLocationDTOMapping on MerchantLocationDTO {
  ///Maps a [MerchantLocationDTO] into a [MerchantLocation]
  MerchantLocation toMerchantLocation() => MerchantLocation(
        id: id,
        address: address,
        email: email,
        latitude: latitude,
        longitude: longitude,
        type: type?.toMerchantLocationType() ?? MerchantLocationType.merchant,
        name: name,
        phone: phone,
        website: website,
        created: created,
        updated: updated,
        distance: distance,
      );
}

///Extension for mapping the [MerchantLocationTypeDTO]
extension MerchantLocationTypeDTOMapping on MerchantLocationTypeDTO {
  ///Maps a [MerchantLocationTypeDTO] into a [MerchantLocationType]
  MerchantLocationType toMerchantLocationType() {
    switch (this) {
      case MerchantLocationTypeDTO.merchant:
        return MerchantLocationType.merchant;
      default:
        throw MappingException(
            from: MerchantLocationTypeDTO, to: MerchantLocationType);
    }
  }
}

///Extension for mapping the [OfferStatusDTO]
extension OfferStatusDTOMapping on OfferStatusDTO {
  ///Maps a [OfferStatusDTO] into a [OfferStatus]
  OfferStatus toOfferStatus() {
    switch (this) {
      case OfferStatusDTO.active:
        return OfferStatus.active;
      case OfferStatusDTO.pending:
        return OfferStatus.pending;
      case OfferStatusDTO.deleted:
        return OfferStatus.deleted;
      case OfferStatusDTO.stopped:
        return OfferStatus.stopped;
      default:
        throw MappingException(from: OfferStatusDTO, to: OfferStatus);
    }
  }
}

///Extension for mapping the [OfferTypeDTO]
extension OfferTypeDTOMapping on OfferTypeDTO {
  ///Maps a [OfferTypeDTO] into a [OfferType]
  OfferType toOfferType() {
    switch (this) {
      case OfferTypeDTO.bankCampaign:
        return OfferType.bankCampaign;
      case OfferTypeDTO.cardScheme:
        return OfferType.cardScheme;
      case OfferTypeDTO.merchant:
        return OfferType.merchant;
      case OfferTypeDTO.cardSchemeMerchant:
        return OfferType.cardSchemeMerchant;
      default:
        throw MappingException(from: OfferTypeDTO, to: OfferType);
    }
  }
}
