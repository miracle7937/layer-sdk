import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:logging/logging.dart';

import '../../utils.dart';

/// A request interceptor that will handle an error when user is invalid
/// and needs to log in or register again.
class UserInactiveInterceptor extends FLInterceptor {
  final Logger _logger = Logger('DeviceInactiveInterceptor');

  /// A callback that should present an error to the user and return true
  /// if the user should be logged out.
  final Future<bool> Function(BuildContext context, String message)
      presentError;

  /// A callback that logs the user out.
  final ValueChanged<BuildContext> logoutUser;

  /// A callback for when the request status code is `unauthenticated` and
  /// we want to handle that by not loggin out the user
  final ValueChanged<BuildContext>? onTokenExpired;

  /// Creates [UserInactiveInterceptor].
  UserInactiveInterceptor({
    required this.presentError,
    required this.logoutUser,
    this.onTokenExpired,
  });

  /// Flag for not showing multiple errors at the same time when multiple
  /// requests are sent for a view
  bool _isErrorShowing = false;

  @override
  Future<void> onError(
    DioError err,
    ErrorInterceptorHandler handler,
  ) async {
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
        if ([
          'device_inactive',
          'user_inactive',
          'user_not_found',
          'unauthenticated'
        ].contains(jsonRes['code'])) {
          if (!_isErrorShowing) {
            _isErrorShowing = true;

            if (jsonRes['code'] == 'unauthenticated' &&
                onTokenExpired != null) {
              onTokenExpired!(context);
              _isErrorShowing = false;
              return false;
            }

            final shouldLogout =
                await presentError(context, jsonRes['message']);

            if (shouldLogout) {
              logoutUser(context);
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
