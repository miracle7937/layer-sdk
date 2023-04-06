import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';

import '../../data_layer/network.dart';

/// This class is used to log cubit method exceptions
mixin CubitLogger {
  /// Logs an exception
  /// so it can be stored in a [Logger] file by [FileLogger] class
  static void logException(Exception e, StackTrace st) {
    /// TODO - In the future, we need to find a better string to use to identify this in the logs.
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
