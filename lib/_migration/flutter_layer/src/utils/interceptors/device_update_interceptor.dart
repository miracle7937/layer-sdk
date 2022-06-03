import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

import '../../utils.dart';

/// A request interceptor that will handle an error when app version
/// is lower than the minimum required version.
class DeviceUpdateInterceptor extends FLInterceptor {
  final Logger _logger = Logger('DeviceUpdateInterceptor');

  /// A callback that should present an error to the user and return true
  /// if the the app store should open.
  final Future<bool> Function(BuildContext context, String message)
      presentError;

  /// A callback that opens the app store.
  final VoidCallback openAppStore;

  /// Creates [DeviceUpdateInterceptor].
  DeviceUpdateInterceptor({
    required this.presentError,
    required this.openAppStore,
  });

  /// Flag for not showing multiple errors at the same time when multiple
  /// requests are sent for a view
  bool _isErrorShowing = false;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    _logger.log(Level.INFO, 'onRequest');
    super.onRequest(options, handler);
  }

  @override
  Future<void> onError(
    DioError err,
    ErrorInterceptorHandler handler,
  ) async {
    _logger.log(Level.INFO, 'onError');
    if (err.response == null) {
      handler.next(err);
      return;
    }
    final shouldContinue = await _handleResponse(err.response!);
    if (shouldContinue) {
      handler.next(err);
    }
  }

  @override
  Future<void> onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) async {
    _logger.log(Level.INFO, 'onResponse');
    final shouldContinue = await _handleResponse(response);
    if (shouldContinue) {
      handler.next(response);
    }
  }

  Future<bool> _handleResponse(
    Response response,
  ) async {
    final status = response.statusCode;
    try {
      if (status == 401) {
        final Map<String, dynamic> jsonRes = json.decode(response.data);
        if (jsonRes['code'] == 'device_update_required') {
          if (!_isErrorShowing) {
            _isErrorShowing = true;

            _logger.log(Level.INFO, 'arrives');

            final shouldOpenAppStore =
                await presentError(context, jsonRes['message']);

            _logger.log(Level.INFO, 'continues');

            if (shouldOpenAppStore) {
              openAppStore();
              _isErrorShowing = false;
              return false;
            }

            _isErrorShowing = false;
          } else {
            return false;
          }
        }
      }

      return true;
    } on Exception {
      _logger.severe('Failed to parse response: $response');
    }

    return false;
  }
}
