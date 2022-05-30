import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_jailbreak_detection/flutter_jailbreak_detection.dart';

/// A wrapper class for the `flutter_jailbreak_detection` library. It allows to
/// easily mock the `isDeviceRooted` method for testing.
class CheckSuperWrapper {
  /// Creates a new [CheckSuperWrapper].
  const CheckSuperWrapper();

  /// Returns `true` when called on a rooted mobile device, `false` otherwise.
  Future<bool> isDeviceRooted() =>
      (kIsWeb || (!Platform.isIOS && !Platform.isAndroid))
          ? Future.value(false)
          : FlutterJailbreakDetection.jailbroken;
}
