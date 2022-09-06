import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

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

  /// Whatsapp
  whatsapp,

  /// Complaints number
  complaintsNumber,
}

/// A model representing the contact us data
class ContactUs extends Equatable {
  /// The item id
  final ContactUsType? id;

  /// The item title
  final String? title;

  /// The item subtitle
  final String? subtitle;

  /// On tap callback
  final VoidCallback? onTap;

  /// Creates new [ContactUs].
  const ContactUs({
    this.id,
    this.title,
    this.subtitle,
    this.onTap,
  });

  @override
  List<Object?> get props => [
        id,
        title,
        subtitle,
        onTap,
      ];
}
