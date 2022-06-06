import 'package:equatable/equatable.dart';

/// All campaigns action types how to use campaigns.
enum CampaignActionType {
  ///The type for call the local or internal number
  call,

  ///The type for send message to
  sendMessage,

  ///The type for both send message and call the local or internal number
  callOrSend,

  ///The type for dpa process that includes start process
  dpa,

  ///The type for open a link
  openLink,

  ///The type for not includes the other types
  none,
}

///The campaign type to show where
enum CampaignType {
  ///To show newsfeed
  container,

  ///To show popup
  popup,

  ///To show inbox
  inbox,

  ///To show transaction pop up
  transactionPopup,

  ///To show landing page
  landingPage,

  ///To show all
  all,

  ///To show AR campaign with qr or something
  arCampaign,

  ///To not show anywhere
  none
}

///The campaign taget
enum CampaignTarget {
  ///To public
  public,

  ///To targeted something
  targeted,

  ///To not show anywhere
  none
}

/// Contains the data for a customer campaign
class CustomerCampaign extends Equatable {
  ///The campaign's id
  final int? id;

  ///The campaign's start date
  final DateTime? startDate;

  ///The campaign's message
  final String? message;

  ///The campaign's medium
  final CampaignType? medium;

  ///The campaign's action
  final CampaignActionType? action;

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

  ///The campaign's target to show public or spesific target
  final CampaignTarget? target;

  ///The campaign's reference image
  final String? referenceImage;

  ///Creates a new [CustomerCampaign]
  CustomerCampaign({
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
  });

  @override
  List<Object?> get props => [
        id,
        startDate,
        medium,
        message,
        action,
        actionMessage,
        actionValue,
        title,
        messageType,
        description,
        html,
        imageUrl,
        thumbnailUrl,
        videoUrl,
        shareVideo,
        referenceImage,
        updatedAt,
      ];

  ///Creates a copy of this category with different values
  CustomerCampaign copyWith({
    int? id,
    DateTime? startDate,
    String? message,
    CampaignType? medium,
    CampaignActionType? action,
    String? actionMessage,
    String? actionValue,
    String? title,
    String? messageType,
    String? description,
    String? html,
    String? imageUrl,
    String? thumbnailUrl,
    String? videoUrl,
    String? updatedAt,
    CampaignTarget? target,
    bool? shareVideo,
    String? referenceImage,
  }) =>
      CustomerCampaign(
        id: id ?? this.id,
        startDate: startDate ?? this.startDate,
        message: message ?? this.message,
        medium: medium ?? this.medium,
        action: action ?? this.action,
        target: target ?? this.target,
        actionMessage: actionMessage ?? this.actionMessage,
        actionValue: actionValue ?? this.actionValue,
        title: title ?? this.title,
        messageType: messageType ?? this.messageType,
        description: description ?? this.description,
        html: html ?? this.html,
        imageUrl: imageUrl ?? this.imageUrl,
        thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
        videoUrl: videoUrl ?? this.videoUrl,
        updatedAt: updatedAt ?? this.updatedAt,
        shareVideo: shareVideo ?? this.shareVideo,
        referenceImage: referenceImage ?? this.referenceImage,
      );
}
