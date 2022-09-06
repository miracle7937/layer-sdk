import 'package:equatable/equatable.dart';

/// The available contact us action types
enum ContactUsType {
  /// Facebook
  facebook,

  /// Twitter
  twitter,

  /// Email
  email,

  /// Complaints email
  complaintsEmail,

  /// Linkedin
  linkedin,

  /// Instagram
  instagram,

  /// Website
  website,

  /// Local number
  local,

  /// International number
  international,

  /// Complaints number
  complaintsNumber,
}

/// The available contact us action types
enum ContactUsActionType {
  /// Link
  link,

  /// Phone
  phone,

  /// Email
  email,
}

/// A model representing the contact us data
class ContactUs extends Equatable {
  /// The item id
  final ContactUsType? id;

  /// The item title
  final String? title;

  /// The item subtitle
  final String? subtitle;

  /// The item android value
  final String? androidValue;

  /// The item ios value
  final String? iosValue;

  /// The item web value
  final String? webValue;

  /// The item url
  final String? url;

  /// The item title
  final ContactUsActionType? actionType;

  /// Creates new [ContactUs].
  const ContactUs({
    this.id,
    this.title,
    this.subtitle,
    this.androidValue,
    this.iosValue,
    this.webValue,
    this.url,
    this.actionType,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        subtitle,
        androidValue,
        iosValue,
        webValue,
        url,
        actionType,
      ];
}
