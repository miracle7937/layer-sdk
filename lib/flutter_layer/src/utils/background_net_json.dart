import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:layer_sdk/data_layer/data_layer.dart';

/// A Flutter-specific NetJson that encodes/decodes JSON outside the UI thread.
class BackgroundNetJson extends NetJson {
  /// Creates a const [BackgroundNetJson]
  const BackgroundNetJson();

  /// Decodes the JSON outside the UI thread.
  @override
  Future decode(
    String source, {
    Object? Function(Object? key, Object? value)? reviver,
  }) =>
      compute(
        _jsonDecoder,
        _DecodeMessage(source, reviver),
      );

  /// Encodes the JSON outside the UI thread.
  @override
  Future<String> encode(
    Object? object, {
    Object? Function(Object? nonEncodable)? toEncodable,
  }) =>
      compute(
        _jsonEncoder,
        _EncodeMessage(object, toEncodable),
      );
}

class _EncodeMessage {
  final Object? object;
  final Object? Function(Object? nonEncodable)? toEncodable;

  _EncodeMessage(this.object, this.toEncodable);
}

class _DecodeMessage {
  final String source;
  final Function(Object? key, Object? value)? reviver;

  _DecodeMessage(this.source, this.reviver);
}

String _jsonEncoder(
  _EncodeMessage message,
) =>
    jsonEncode(
      message.object,
      toEncodable: message.toEncodable,
    );

dynamic _jsonDecoder(
  _DecodeMessage message,
) =>
    jsonDecode(
      message.source,
      reviver: message.reviver,
    );
