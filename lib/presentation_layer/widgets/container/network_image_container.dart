import 'dart:async';
import 'dart:ui' as ui;

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

  Map<String, String> get _headers => {
        'Authorization':
            customToken ?? FlutterEnvironmentConfiguration.current.defaultToken,
      };

  Future<ui.Image> _loadImage(String url) async {
    final imageStream = CachedNetworkImageProvider(
      url,
      headers: _headers,
    ).resolve(ImageConfiguration());
    final completer = Completer<ui.Image>();
    imageStream.addListener(ImageStreamListener((image, _) {
      completer.complete(image.image);
    }));
    return completer.future;
  }

  @override
  Widget build(BuildContext context) => FutureBuilder<ui.Image>(
      future: _loadImage(imageURL),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return SizedBox(
            height: snapshot.requireData.height.toDouble(),
            child: CachedNetworkImage(
              fit: fit,
              imageUrl: imageURL,
              height: snapshot.requireData.height.toDouble(),
              httpHeaders: _headers,
              placeholder: (context, url) => placeholder ?? Container(),
              errorWidget: (context, url, error) => errorWidget ?? Container(),
            ),
          );
        } else {
          return Container();
        }
      });
}
