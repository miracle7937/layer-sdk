import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:logging/logging.dart';

import '../../../../../presentation_layer/utils.dart';
import '../../../../business_layer/business_layer.dart';

/// A request interceptor that will read for the unread alerts count
/// value from the response headers
class UnreadAlertsCountInterceptor extends FLInterceptor {
  final Logger _logger = Logger('UnreadAlertsCountInterceptor');

  @override
  Future onResponse(
    Response response,
    ResponseInterceptorHandler handler,
  ) async {
    try {
      final totalUnread = response.headers.value('total-unread');

      if (totalUnread != null) {
        final unread = int.tryParse(totalUnread);
        if (unread != null) {
          context.read<UnreadAlertsCountCubit>().notify(unread);
        }
      }
      handler.next(response);
    } on Exception {
      _logger.severe(
        'Failed to parse response headers: ${response.headers.map}',
      );
    }
  }
}
