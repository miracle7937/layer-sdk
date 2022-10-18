import 'package:equatable/equatable.dart';

import '../../../../data_layer/extensions.dart';

/// Permissions related to information.
///
/// The common permissions are at the root of the object.
class InformationPermissionData extends Equatable {
  /// User has access to accounts information.
  final bool accounts;

  /// Creates a [InformationPermissionData] object.
  const InformationPermissionData({
    this.accounts = false,
  });

  ///TODO: Temporary solution for alerts
  bool get canDoAnyTransaction => true;

  @override
  List<Object> get props => [
        accounts,
      ];

  /// Returns a copy of this permission with select different values.
  InformationPermissionData copyWith({
    bool? accounts,
  }) =>
      InformationPermissionData(
        accounts: accounts ?? this.accounts,
      );

  @override
  String toString() => '<'
      '${[
        '${accounts.toLog('accounts')}',
      ].logJoin()}'
      '>';
}
