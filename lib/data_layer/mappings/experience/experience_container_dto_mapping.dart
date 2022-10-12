import 'package:collection/collection.dart';
import 'package:logging/logging.dart';

import '../../../domain_layer/models.dart';
import '../../dtos.dart';
import '../../errors.dart';

/// Extension that provides mapping
/// from [ExperienceContainerDTO] to [ExperienceContainer].
extension ExperienceContainerDTOMapping on ExperienceContainerDTO {
  /// Returns an [ExperienceContainer] built from this [ExperienceContainerDTO].
  ExperienceContainer toExperienceContainer({
    required String experienceImageURL,
  }) {
    if ([
      containerId,
      containerName,
      typeCode,
      typeName,
      typeCode!.toExperienceContainerType(),
      cardTitle,
    ].contains(null)) {
      throw MappingException(
        from: ExperienceContainerDTO,
        to: ExperienceContainer,
        value: this,
        details: 'One of the required parameters is null',
      );
    }

    return ExperienceContainer(
      id: containerId!,
      name: containerName!,
      typeCode: typeCode!,
      typeName: typeName!,
      type: typeCode!.toExperienceContainerType(),
      title: cardTitle!,
      order: order,
      settings: _mapSettingsWithValues(
        containerId: containerId!,
        experienceImageURL: experienceImageURL,
      ),
      messages: Map<String, String>.from(messages),
    );
  }

  /// Merges [settingDefinitions] with [settingValues]
  /// to be used in the [ExperienceContainer] model.
  ///
  /// Settings with types not defined in [ExperienceSettingType]
  /// will be filtered out.
  UnmodifiableListView<ExperienceSetting> _mapSettingsWithValues({
    required int containerId,
    required String experienceImageURL,
  }) {
    final definitions = settingDefinitions ?? <ExperienceSettingDTO>[];
    return UnmodifiableListView<ExperienceSetting>(
      definitions.map(
        (definition) {
          final type = definition.type?.toExperienceSettingType();

          var value = settingValues[definition.setting];
          if (type == ExperienceSettingType.image) {
            value = '$experienceImageURL/${definition.setting}$containerId.png';
          }

          return type != null && definition.setting != null
              ? ExperienceSetting(
                  setting: definition.setting!,
                  type: type,
                  user: definition.user ?? false,
                  value: value,
                )
              : null;
        },
      ).whereNotNull(),
    );
  }
}

/// Extension that provides mapping
/// from [ExperienceSettingTypeDTO] to [ExperienceSettingType].
extension ExperienceSettingTypeDTOMapping on ExperienceSettingTypeDTO {
  /// Returns an [ExperienceSettingType] built from
  /// this [ExperienceSettingTypeDTOMapping].
  ExperienceSettingType toExperienceSettingType() {
    switch (this) {
      case ExperienceSettingTypeDTO.integer:
        return ExperienceSettingType.integer;

      case ExperienceSettingTypeDTO.string:
        return ExperienceSettingType.string;

      case ExperienceSettingTypeDTO.boolean:
        return ExperienceSettingType.boolean;

      case ExperienceSettingTypeDTO.image:
        return ExperienceSettingType.image;

      case ExperienceSettingTypeDTO.multiChoice:
        return ExperienceSettingType.multiChoice;

      case ExperienceSettingTypeDTO.currencyMultiChoice:
        return ExperienceSettingType.currencyMultiChoice;

      case ExperienceSettingTypeDTO.currencyChoice:
        return ExperienceSettingType.currencyChoice;

      default:
        throw MappingException(
          from: ExperienceSettingTypeDTO,
          to: ExperienceSettingType,
          value: this,
        );
    }
  }
}

/// Extension that provides mapping
/// from [String] to [ExperienceContainerType].
extension ExperienceContainerTypeMapping on String {
  /// Returns an [ExperienceContainerType] built from
  /// this [ExperienceContainerTypeMapping].
  ExperienceContainerType toExperienceContainerType() {
    switch (this) {
      case "activity":
        return ExperienceContainerType.activity;

      case "campaign":
        return ExperienceContainerType.campaign;

      case "appointments":
        return ExperienceContainerType.appointments;

      case "inquiries":
        return ExperienceContainerType.inquiries;

      case "instant":
        return ExperienceContainerType.instant;

      case "transfer":
        return ExperienceContainerType.transfer;

      case "bill":
        return ExperienceContainerType.bill;

      case "dpa":
        return ExperienceContainerType.dpa;

      case "settings":
        return ExperienceContainerType.settings;

      case "tradeFinance":
        return ExperienceContainerType.tradeFinance;

      case "zakat":
        return ExperienceContainerType.zakat;

      case "alerts":
        return ExperienceContainerType.alerts;

      case "forex":
        return ExperienceContainerType.forex;

      case "locateUs":
        return ExperienceContainerType.locateUs;

      case "merchant_offers":
      case "loyalty":
        return ExperienceContainerType.loyalty;

      case "donation":
        return ExperienceContainerType.donation;

      case "accounts":
        return ExperienceContainerType.accounts;

      case "cards":
        return ExperienceContainerType.cards;

      case "financeCalculator":
        return ExperienceContainerType.financeCalculator;

      case "pfm":
        return ExperienceContainerType.pfm;

      case "inbox":
        return ExperienceContainerType.inbox;

      case "prayers":
        return ExperienceContainerType.prayers;

      case "contactUs":
        return ExperienceContainerType.contactUs;

      case "qr":
        return ExperienceContainerType.qr;

      case "topup":
        return ExperienceContainerType.topup;

      case "upcomingPayments":
        return ExperienceContainerType.upcomingPayments;

      case "dashboard":
        return ExperienceContainerType.dashboard;

      case "wallet":
        return ExperienceContainerType.wallet;

      case "walletLinking":
        return ExperienceContainerType.walletLinking;

      case "profile":
        return ExperienceContainerType.profile;

      case "vault":
        return ExperienceContainerType.vault;

      case "instantTransfer":
        return ExperienceContainerType.instantTransfer;

      case "appointment":
        return ExperienceContainerType.appointment;

      case "payment":
        return ExperienceContainerType.payment;

      case "mastercard":
        return ExperienceContainerType.mastercard;

      case "chatbot":
        return ExperienceContainerType.chatbot;

      case "arCampaigns":
        return ExperienceContainerType.arCampaigns;

      default:
        final _log = Logger('ExperienceContainerTypeMapping');
        _log.severe('Error parsing $this experience');

        throw MappingException(
          from: String,
          to: ExperienceContainerType,
          value: this,
        );
    }
  }
}
