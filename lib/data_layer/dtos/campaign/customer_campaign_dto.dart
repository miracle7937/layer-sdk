
import '../../helpers.dart';

/// Represents the customers campaigns
/// as provided by the campaign service
class CustomerCampaignDTO {
  ///The campaign's id
  final int? id;

  ///The campaign's start date
  final DateTime? startDate;

  ///The campaign's message
  final String? message;

  ///The campaign's medium
  final CampaignTypeDTO? medium;

  ///The campaign's action
  final CampaignActionTypeDTO? action;

  ///The campaign's action message
  final String? actionMessage;

  ///The campaign's action value
  final String? actionValue;

  ///The campaign's title
  final String? title;

  ///The campaign's message type
  final String? messageType;

  ///The campaign's description
  final String? description;

  ///The campaign's html that includes page url
  final String? html;

  ///The campaign's image url
  final String? imageUrl;

  ///The campaign's thumbnail url
  final String? thumbnailUrl;

  ///The campaign's video url
  final String? videoUrl;

  ///Last time the campaing was updated
  final String? updatedAt;

  ///Is campaign's video can share or not
  final bool? shareVideo;

  ///Campaign target [CampaignTargetDTO]
  final CampaignTargetDTO? target;

  ///The campaign's reference image
  final String? referenceImage;

  /// Contains all information about the card type
  CampaignTypeDTO? campaignType;

  /// Contains all the accountIDs related to this card
  List<String>? accountID;

  /// Creates a new [CustomerCampaignDTO]
  CustomerCampaignDTO({
    this.id,
    this.startDate,
    this.medium,
    this.message,
    this.action,
    this.actionMessage,
    this.actionValue,
    this.title,
    this.messageType,
    this.description,
    this.html,
    this.imageUrl,
    this.thumbnailUrl,
    this.videoUrl,
    this.shareVideo,
    this.target,
    this.referenceImage,
    this.updatedAt,
    this.campaignType,
  });

  /// Creates a [CustomerCampaignDTO] from a JSON
  factory CustomerCampaignDTO.fromJson(Map<String, dynamic> map) {
    return CustomerCampaignDTO(
      id: map['id'],
      startDate: JsonParser.parseStringDate(map['start_date']),
      medium: CampaignTypeDTO(map['medium']),
      message: map['message'],
      action: CampaignActionTypeDTO(map['action']),
      actionMessage: map['action_message'],
      actionValue: map['action_value'],
      title: map['title'],
      messageType: map['message_type'],
      description: map['ddescription'],
      html: map['html'],
      imageUrl: map['image'],
      thumbnailUrl: map['thumbnail'],
      videoUrl: map['video'],
      shareVideo: map['can_share'],
      target: CampaignTargetDTO(map['target']),
      referenceImage: map['reference_image'],
      updatedAt: map['ts_updated'].toString(),
    );
  }

  /// Creates a list of [CardDTO] from a JSON list
  static List<CustomerCampaignDTO> fromJsonList(
          List<Map<String, dynamic>> json) =>
      json.map(CustomerCampaignDTO.fromJson).toList(growable: false);
}

/// The type of Campaign
class CampaignTypeDTO extends EnumDTO {
  ///Newsfeed type
  static const container = CampaignTypeDTO._internal('C');

  ///Popup type
  static const popup = CampaignTypeDTO._internal('P');

  ///Inbox type
  static const inbox = CampaignTypeDTO._internal('I');

  ///Transaction Popup type
  static const transactionPopup = CampaignTypeDTO._internal('T');

  ///Landing Page
  static const landingPage = CampaignTypeDTO._internal('L');

  ///AR Campaign Type
  static const arCampaign = CampaignTypeDTO._internal('R');

  ///All Campaign types
  static const all = CampaignTypeDTO._internal('');

  ///None
  static const none = CampaignTypeDTO._internal('');

  /// List of all possible Campaign types
  static const List<CampaignTypeDTO> values = [
    container,
    popup,
    transactionPopup,
    landingPage,
    all,
    arCampaign,
    none
  ];
  const CampaignTypeDTO._internal(String value) : super.internal(value);

  /// Find [CampaignTypeDTO] based in the letter passed
  factory CampaignTypeDTO(String? raw) => values.singleWhere(
        (val) => val.value == raw,
        orElse: () => CampaignTypeDTO.none,
      );
}

/// The type of Campaign Action
class CampaignActionTypeDTO extends EnumDTO {
  ///For call
  static const call = CampaignActionTypeDTO._internal('C');

  ///Send message via inbox
  static const sendMessage = CampaignActionTypeDTO._internal('M');

  ///For call and send type
  static const callOrSend = CampaignActionTypeDTO._internal('S');

  ///For DPA type
  static const dpa = CampaignActionTypeDTO._internal('D');

  ///For open a link
  static const openLink = CampaignActionTypeDTO._internal('L');

  ///None
  static const none = CampaignActionTypeDTO._internal('');

  /// List of all possible Campaign Action types
  static const List<CampaignActionTypeDTO> values = [
    call,
    sendMessage,
    callOrSend,
    dpa,
    openLink,
    none
  ];
  const CampaignActionTypeDTO._internal(String value) : super.internal(value);

  /// Find [CampaignActionTypeDTO] based in the letter passed
  factory CampaignActionTypeDTO(String? raw) => values.singleWhere(
        (val) => val.value == raw,
        orElse: () => CampaignActionTypeDTO.none,
      );
}

///The target of campaign
class CampaignTargetDTO extends EnumDTO {
  ///Public campaigns
  static const public = CampaignTargetDTO._internal('P');

  ///Targeted campaigns
  static const targeted = CampaignTargetDTO._internal('T');

  ///None
  static const none = CampaignTargetDTO._internal('');

  /// List of Campaign target types
  static const List<CampaignTargetDTO> values = [public, targeted, none];
  const CampaignTargetDTO._internal(String value) : super.internal(value);

  /// Find [CampaignTargetDTO] based in the letter passed
  factory CampaignTargetDTO(String raw) => values.singleWhere(
        (it) => it.value == raw,
        orElse: () => CampaignTargetDTO.none,
      );
}
