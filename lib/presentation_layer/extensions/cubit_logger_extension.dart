import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:logging/logging.dart';

import '../../data_layer/network/net_exceptions.dart';

/// Extension function to help logging exceptions thrown by cubits
extension CubitLogHelper on Cubit {
  /// Logs the exception from the stacktrace
  void logException(Exception e, StackTrace st) {
    /// TODO - In the future, we need to find a better string
    /// to use to identify this in the logs.
    /// For now we'll keep it as `SystemStateError`
    final _log = Logger('SystemStateError');
    final frame = StackFrame.fromStackTrace(st).first;
    final exceptionString =
        e is NetException ? (e.message ?? '') : e.toString();

    _log.log(
      Level.SEVERE,
      "${frame.className} - ${frame.method} exception: $exceptionString",
    );
  }
}
