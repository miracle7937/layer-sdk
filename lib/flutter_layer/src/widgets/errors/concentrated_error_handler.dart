import 'dart:async';

import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

import '../../utils.dart';

/// Signature for callbacks to handle an error.
typedef OnConcentratedError = void Function(ErrorData error);

/// Listens for errors received by a [ErrorConcentrator], and calls a callback
/// for each, so that the app can handle them as it sees fit.
///
/// Best way to use this is to create a stateless widget that wraps this
/// widget by supplying an onError.
class ConcentratedErrorHandler extends StatefulWidget {
  /// Where to listens for errors. Required.
  final ErrorConcentrator errorConcentrator;

  /// The child. Required.
  final Widget child;

  /// The callback to call when an error arises.
  final OnConcentratedError onError;

  /// Create a new [ConcentratedErrorHandler].
  const ConcentratedErrorHandler({
    Key? key,
    required this.errorConcentrator,
    required this.child,
    required this.onError,
  }) : super(key: key);

  @override
  _ConcentratedErrorHandlerState createState() =>
      _ConcentratedErrorHandlerState();
}

class _ConcentratedErrorHandlerState extends State<ConcentratedErrorHandler> {
  static final _log = Logger('ConcentratedErrorHandler');

  StreamSubscription<ErrorData>? _subscription;

  @override
  void initState() {
    super.initState();

    _subscribe();
  }

  @override
  void didUpdateWidget(ConcentratedErrorHandler old) {
    super.didUpdateWidget(old);

    if (old.errorConcentrator != widget.errorConcentrator ||
        old.onError != widget.onError) {
      _unsubscribe();
      _subscribe();
    }
  }

  @override
  void dispose() {
    _unsubscribe();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;

  /// Subscribes to the error stream.
  void _subscribe() {
    _subscription = widget.errorConcentrator.stream.listen(
      widget.onError,
      onError: _onStreamError,
    );
  }

  /// Cleans up the error stream subscription.
  void _unsubscribe() {
    _subscription?.cancel();
    _subscription = null;
  }

  /// Handles errors on the stream itself.
  void _onStreamError(Object? error, StackTrace? stackTrace) => _log.severe(
        'Stream error: ${error?.toString() ?? ''}'
        '${stackTrace != null ? '\n$stackTrace' : ''}',
      );
}
