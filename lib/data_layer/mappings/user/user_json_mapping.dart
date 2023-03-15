import 'package:collection/collection.dart';

import '../../../../data_layer/dtos.dart';
import '../../../../data_layer/mappings.dart';
import '../../../../domain_layer/models.dart';

/// Extension that provides json mapping for [User].
///
/// This is the only mapping that is currently available for other layers,
/// as it is needed for the current storage solution.
extension UserJsonMapping on User {
  /// Returns a json map created from [User] data.
  Map<String, dynamic> toJson() {
    final alert = enabledAlerts
        .map(
          (enabledAlert) => enabledAlert.toTypeDTO().value,
        )
        .toList();
    return {
      // DO NOT SAVE THE ACCESS PIN WITH THE USER OBJECT
      'id': id,
      'username': username,
      'mobile_number': mobileNumber,
      'first_name': firstName,
      'last_name': lastName,
      'status': status?.toString(),
      'pref': {
        'favorite_offers': favoriteOffers,
        'alert': alert.isEmpty ? null : alert,
      },
      'device_id': deviceId,
      'roles': roles,
    };
  }

  /// Creates the [User] from a json map.
  static User fromJson(Map<String, dynamic> json) {
    final enabledAlerts = json['pref'] != null && json['pref']['alert'] != null
        ? List<String>.from(json['pref']['alert'])
            .map((alert) =>
                ActivityTypeDTO.fromRaw(alert)?.toType() ??
                ActivityType.unknown)
            .toList()
        : List<ActivityType>.from([]);
    return User(
      id: json['id'],
      username: json['username'],
      mobileNumber: json['mobile_number'],
      firstName: json['first_name'],
      lastName: json['last_name'],
      status: UserStatus.values.firstWhereOrNull(
        (status) => status.toString() == json['status'],
      ),
      token: json['token'],
      accessPin: json['accessPin'],
      favoriteOffers: json['pref'] != null
          ? json['pref']['favorite_offers'].cast<int>()
          : [],
      deviceId: json['device_id'],
      enabledAlerts: enabledAlerts,
    );
  }
}
