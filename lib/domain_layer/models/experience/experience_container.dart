import 'dart:collection';

import 'package:equatable/equatable.dart';

import '../../models.dart';

/// A model representing a card container configured in the Experience Studio.
class ExperienceContainer extends Equatable {
  /// Unique identifier of the container.
  final int id;

  /// Internal name of the container as defined in the experience sheet.
  final String name;

  /// Code of the container type as defined in the experience sheet.
  final String typeCode;

  /// Name of the container type as defined in the experience sheet.
  final String typeName;

  /// Name of the type for getting the container type enum
  final ExperienceContainerType type;

  /// Title of the container.
  final String title;

  /// Default order in which the containers should be displayed.
  final int order;

  /// Settings included in this container.
  ///
  /// This list contains only settings with types defined
  /// in [ExperienceSettingType]. If the setting type you need is not defined
  /// there please add it to the type enum and implement required mapping.
  final UnmodifiableListView<ExperienceSetting> settings;

  /// Messages included in this container.
  final UnmodifiableMapView<String, String> messages;

  /// Creates [ExperienceContainer].
  ExperienceContainer({
    required this.id,
    required this.name,
    required this.typeCode,
    required this.typeName,
    required this.type,
    required this.title,
    required this.order,
    required Iterable<ExperienceSetting> settings,
    required Map<String, String> messages,
  })  : settings = UnmodifiableListView(settings),
        messages = UnmodifiableMapView(messages);

  /// Creates a copy with the passed values.
  ExperienceContainer copyWith({
    int? id,
    String? name,
    String? typeCode,
    ExperienceContainerType? type,
    String? typeName,
    String? title,
    int? order,
    Iterable<ExperienceSetting>? settings,
    Map<String, String>? messages,
  }) =>
      ExperienceContainer(
        id: id ?? this.id,
        name: name ?? this.name,
        typeCode: typeCode ?? this.typeCode,
        typeName: typeName ?? this.typeName,
        type: type ?? this.type,
        title: title ?? this.title,
        order: order ?? this.order,
        settings: settings ?? this.settings,
        messages: messages ?? this.messages,
      );

  @override
  List<Object?> get props => [
        id,
        name,
        typeCode,
        typeName,
        type,
        title,
        order,
        settings,
      ];
}

/// The type code of experience container
enum ExperienceContainerType {
  /// The activity type
  activity,

  /// The campaign type
  campaign,

  /// The appointments type
  appointments,

  /// The inquiries type
  inquiries,

  /// The instant transfer type

  instant,

  /// The transfer type
  transfer,

  /// The bill type
  bill,

  /// The dpa type
  dpa,

  /// The settings type
  settings,

  /// The trade finance type
  tradeFinance,

  /// The zakat type
  zakat,

  /// The alerts type
  alerts,

  /// The forex type
  forex,

  /// The locate us type
  locateUs,

  /// The loyalty type
  loyalty,

  /// The donation type
  donation,

  /// The accounts type
  accounts,

  /// The cards type
  cards,

  /// The finance calculator type
  financeCalculator,

  /// The pfm type
  pfm,

  /// The inbox type
  inbox,

  /// The prayers type
  prayers,

  /// The contact us type
  contactUs,

  /// The qr type
  qr,

  /// The topup type
  topup,

  /// The upcoming payments type
  upcomingPayments,

  /// The dashboard type
  dashboard,

  /// The wallet type
  wallet,

  /// The link wallet type
  walletLinking,

  /// The profile type
  profile,

  /// The vault type
  vault,

  /// The instant transfer type
  instantTransfer,

  /// The appointment type
  appointment,

  /// The payment type
  payment,

  /// The mastercard type
  mastercard,

  /// The chat bot type
  chatbot,

  /// The ar campaign type
  arCampaigns,

  /// The landing page type.
  landingPage,

  /// The beneficiaries type.
  beneficiaries,

  /// The lifestyle type.
  lifestyle,

  /// The QR payments type.
  qrPayments,

  /// The QR emv type.
  qrEmv,

  /// The favourites type.
  favourites,

  /// The card reward hub type.
  cardRewardHub,

  /// The flight booking type.
  flightBooking,

  /// The quickpay type.
  quickpay,

  /// The frequent transfers type.
  frequentTransfers,

  /// The walkthrough type
  walkthrough,

  /// The bankInformation type
  bankInformation,

  /// The shortcuts type
  shortcuts,
}
