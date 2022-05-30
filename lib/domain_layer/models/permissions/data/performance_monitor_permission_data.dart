import 'package:equatable/equatable.dart';

import '../../../../data_layer/extensions.dart';

/// The available types for the performance monitor
enum PerformanceMonitorPermissionType {
  /// None.
  none,

  /// Editor.
  editor,
}

/// Permissions related to performance monitor.
class PerformanceMonitorPermissionData extends Equatable {
  /// User specific permissions.
  final PerformanceMonitorPermissionType user;

  /// Creates a [PerformanceMonitorPermissionData] object.
  const PerformanceMonitorPermissionData({
    this.user = PerformanceMonitorPermissionType.none,
  });

  @override
  List<Object> get props => [
        user,
      ];

  /// Returns a copy of this permission with select different values.
  PerformanceMonitorPermissionData copyWith({
    PerformanceMonitorPermissionType? user,
  }) =>
      PerformanceMonitorPermissionData(
        user: user ?? this.user,
      );

  @override
  String toString() => '<'
      '${[
        'user: ${user.toLog()}',
      ].logJoin()}'
      '>';
}

extension _PerformanceMonitorPermissionTypeLog
    on PerformanceMonitorPermissionType {
  /// Returns the log string for this [PerformanceMonitorPermissionType].
  String toLog() {
    switch (this) {
      case PerformanceMonitorPermissionType.none:
        return 'none';

      case PerformanceMonitorPermissionType.editor:
        return 'editor';

      default:
        return 'Index not recognized: $index';
    }
  }
}
