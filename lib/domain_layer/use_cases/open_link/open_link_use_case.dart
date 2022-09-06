import 'dart:io';

import 'package:url_launcher/url_launcher.dart';

import '../../../_migration/data_layer/src/helpers/dto_helpers.dart';

/// The use case responsible for opening the urls
class OpenLinkUseCase {
  /// Creates new [OpenLinkUseCase].
  OpenLinkUseCase();

  /// Opens the provided link
  void openLink({required String link, required String url}) async {
    try {
      final linkUri = Uri.tryParse(link);
      final urlUri = Uri.tryParse(url);

      if (isNotEmpty(link) && linkUri != null && await canLaunchUrl(linkUri)) {
        await launchUrl(linkUri);
        return;
      } else if (isNotEmpty(url) &&
          urlUri != null &&
          await canLaunchUrl(urlUri)) {
        await launchUrl(urlUri);
        return;
      }
    } on Exception catch (e) {
      throw Exception('Error launching link ${e.toString()}');
    }
  }

  /// Opens the facebook profile
  void openFacebookProfile({
    required String facebookPageId,
  }) =>
      _openPlatformSpecificLink(
        iosValue: "fb://profile/$facebookPageId/",
        androidValue: "fb://page/$facebookPageId",
      );

  /// Opens the linkedin profile
  void openLinkedIn({
    required String username,
  }) =>
      _openPlatformSpecificLink(
        iosValue: "linkedin://company/$username",
        androidValue: "linkedin://$username",
      );

  /// Opens the platform specific link
  void _openPlatformSpecificLink({
    required String iosValue,
    required String androidValue,
  }) async {
    try {
      var isIOS = Platform.isIOS;

      if (isIOS) {
        final iosValueUri = Uri.tryParse(iosValue.replaceAll(' ', '%20'));

        if (await canLaunchUrl(iosValueUri!)) {
          await launchUrl(iosValueUri);
        }
      } else {
        final androidValueUri = Uri.tryParse(androidValue);

        if (await canLaunchUrl(androidValueUri!)) {
          await launchUrl(androidValueUri);
        }
      }
    } on Exception catch (e) {
      throw Exception('Error launching platform specific link ${e.toString()}');
    }
  }
}
