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
  }) async {
    var url = Uri.parse('https://www.facebook.com/$facebookPageId');
    try {
      await launchUrl(url, mode: LaunchMode.inAppWebView);
    } on Exception catch (e) {
      print(e);
    }
  }

  /// Opens the linkedin profile
  void openLinkedIn({
    required String username,
  }) async {
    var url = Uri.parse('https://www.linkedin.com/company/$username');
    try {
      await launchUrl(url, mode: LaunchMode.inAppWebView);
    } on Exception catch (e) {
      print(e);
    }
  }
}
