import 'package:collection/collection.dart';

import '../../../../domain_layer/models.dart';

/// Extension that provides json mapping for [User].
///
/// This is the only mapping that is currently available for other layers,
/// as it is needed for the current storage solution.
extension UserJsonMapping on User {
  /// Returns a json map created from [User] data.
  Map<String, dynamic> toJson() => {
        'id': id,
        'username': username,
        'mobile_number': mobileNumber,
        'first_name': firstName,
        'last_name': lastName,
        'status': status?.toString(),
        'accessPin': accessPin,
        'pref': {
          'favorite_offers': favoriteOffers,
        },
        'device_id': deviceId,
        'roles': roles,
      };

  /// Creates the [User] from a json map.
  static User fromJson(Map<String, dynamic> json) => User(
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
      );
}
