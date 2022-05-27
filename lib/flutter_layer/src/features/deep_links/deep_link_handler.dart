import 'dart:async';

import 'package:flutter/material.dart';
import 'package:logging/logging.dart';
import 'package:uni_links/uni_links.dart';

/// A Widget that handles the deep links.
///
/// Deep links are basic web links that activate the app and can contain
/// optional data.
///
/// These links are usually used for triggering a new flow on the app side or
/// for continue a current flow.
///
/// We use the uni_links flutter package. So previous to using this widget on
/// your app widget tree, pleas take a look at the installation notes from the
/// package, as you might need to do some platform specific changes in order
/// for the deep links to work:
///
/// [Installation notes](https://pub.dev/packages/uni_links#installation)
///
/// If a deep link is pressed and the related app is not installed, the
/// app store / play store will be opened with the app details so the user can
/// download the app.
///
/// For handling deep links, just include this widget on the root view of the
/// flow. For example:
///
///   * Control deeplinks on the unauthenticated flow of the app.
///     You can use this widget on the root view of the unauthenticated flow
///     and handle the incoming deep link events there.
///
///   * Control deeplinks on the authenticated flow of the app.
///     You can use this widget on the root view of the authenticated flow
///     and handle the incoming deep link events there.
///
/// The [shouldHandleInitialLink] is the parameter that will
/// decide if the initial deep link should be handled or not.
///
/// If your app was launched from a deep link event, the only way to retrieve
/// that event is by fetching the initial deep link. If this link is not
/// [null], you will be notified of this event when this widget gets rendered
/// on the widget tree.
///
/// Please, keep in mind that this initial link is persistent, so if your app
/// instance was launched from a deeplink and you reset the app by calling
/// a state refresh on a view that is placed on a higher level than
/// the [DeepLinkHandler] and the [shouldHandleInitialLink] was true,
/// the [onDeepLink] callback will be called again with the
/// initial deep link event.
///
/// The [onDeepLink] callback is called each time a deep link
/// event is detected. You can handle the following [Uri] data there:
///
/// * [Uri.host]. The host that triggered the deep link.
///
/// * [Uri.queryParameters]. The query parameters are optional but are passed
///   most of the times. They can contain the action to perform and additional
///   data relevant to the action.
///
/// An optional [onError] callback can be passed for checking all the possible
/// errors happening with the deep link subscription.
///
/// A [child] is required for this widget to be used in
/// the widget tree.
///
/// {@tool snippet}
///
/// Imagine that you have a root file for the unaunthenticated flow where you
/// are displaying 2 buttons: Login and register.
///
/// The user is currently registering on the app but he needs to verify his
/// email account previous to completing the register flow.
///
/// On that root view you will use the [DeepLinkHandler] widget for listening
/// to email verification events:
///
/// ```dart
/// DeepLinkHandler(
///   shouldHandleInitialLink: true,
///   onDeepLink: (link) {
///     if(link.queryParameters['action'] == 'email_verification'){
///       //Handle the link.
///     }
///   },
///   child: Container(),
/// );
/// ```
///
/// We set the [shouldHandleInitialLink] to true cause the user might have
/// closed the app previous to the deep link press event. This way, the
/// deep link event will be handled when the root view gets rendered.
/// {@end-tool}
class DeepLinkHandler extends StatefulWidget {
  /// Whether if the widget should handle the initial link or not.
  ///
  /// Default is false.
  final bool shouldHandleInitialLink;

  /// The [ValueSetter] that will be called when a
  /// deep link event is received.
  final ValueSetter<Uri> onDeepLink;

  /// The callback called when there's been an error on the link
  /// subscription.
  final ValueSetter<dynamic>? onError;

  /// The child.
  final Widget child;

  /// Creates a new [DeepLinkHandler].
  const DeepLinkHandler({
    Key? key,
    this.shouldHandleInitialLink = false,
    required this.onDeepLink,
    this.onError,
    required this.child,
  }) : super(key: key);

  @override
  State<DeepLinkHandler> createState() => _DeepLinkHandlerState();
}

class _DeepLinkHandlerState extends State<DeepLinkHandler> {
  final _logger = Logger('DeepLinkHandler');

  /// The deep link subscription;
  late StreamSubscription _deepLinkSub;

  @override
  void initState() {
    super.initState();
    if (widget.shouldHandleInitialLink) {
      _handleInitialLink();
    }

    _deepLinkSub = uriLinkStream.listen(
      _handleLink,
      onError: (error) {
        _logger.log(Level.WARNING, error);
        if (widget.onError != null) {
          widget.onError!(error);
        }
      },
    );
  }

  /// Handles the initial deep link if existent.
  Future<void> _handleInitialLink() async {
    final initialLink = await getInitialUri();
    _handleLink(initialLink);
  }

  /// Handles a deep link.
  void _handleLink(Uri? link) {
    if (link == null) {
      return;
    }

    widget.onDeepLink(link);
  }

  @override
  Widget build(BuildContext context) => widget.child;

  @override
  void dispose() {
    _deepLinkSub.cancel();
    super.dispose();
  }
}
