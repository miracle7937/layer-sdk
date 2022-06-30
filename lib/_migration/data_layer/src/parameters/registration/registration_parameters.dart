import 'package:equatable/equatable.dart';

import '../../../../../domain_layer/models.dart';


/// A class representing a set of base parameters for all
/// registration parameter types.
abstract class RegistrationParameters extends Equatable {
  /// The push notification token.
  final String? notificationToken;

  /// The device session
  final DeviceSession? deviceSession;

  /// Creates [RegistrationParameters].
  RegistrationParameters({
    this.notificationToken,
    this.deviceSession,
  });
}
