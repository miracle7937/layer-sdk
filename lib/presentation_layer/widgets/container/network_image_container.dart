import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../environment.dart';

///A container that shows an image using the [CachedNetworkImage] plugin
///
/// An authorization token is added to the HTTP headers. This can be a
/// [customToken], or if that's not supplied, it uses the default token from
/// the current [FlutterEnvironmentConfiguration].
class NetworkImageContainer extends StatelessWidget {
  ///The image URL
  final String imageURL;

  ///The widget to show while loading the image
  final Widget? placeholder;

  ///The widget to show when an error ocurred while loading the image
  final Widget? errorWidget;

  ///The [BoxFit] property for the image, [BoxFit.scaleDown] by default
  final BoxFit fit;

  /// An optional token to be used in place of the default
  /// [FlutterEnvironmentConfiguration] token.
  final String? customToken;

  ///Creates a new [NetworkImageContainer]
  const NetworkImageContainer({
    required this.imageURL,
    this.placeholder,
    this.errorWidget,
    this.fit = BoxFit.scaleDown,
    this.customToken,
  });

  @override
  Widget build(BuildContext context) => CachedNetworkImage(
        fit: fit,
        imageUrl: imageURL,
        httpHeaders: {
          'Authorization': customToken ??
              FlutterEnvironmentConfiguration.current.defaultToken,
        },
        placeholder: (context, url) => placeholder ?? Container(),
        errorWidget: (context, url, error) => errorWidget ?? Container(),
      );
}
