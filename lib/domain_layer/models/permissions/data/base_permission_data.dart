import 'package:equatable/equatable.dart';

import '../../../../data_layer/extensions.dart';

/// Holds the basic permission properties.
///
/// By default, the user does not have any permissions.
class BasePermissionData extends Equatable {
  /// User can view the data.
  final bool view;

  /// User can edit the data.
  final bool edit;

  /// User can modify the structure.
  final bool modify;

  /// User can publish the data.
  final bool publish;

  /// User can execute actions.
  final bool executeAction;

  /// User can create actions.
  final bool createAction;

  /// User can decrypt data.
  final bool decrypt;

  /// Creates a [BasePermissionData] object.
  const BasePermissionData({
    this.view = false,
    this.edit = false,
    this.modify = false,
    this.publish = false,
    this.executeAction = false,
    this.createAction = false,
    this.decrypt = false,
  });

  @override
  List<Object> get props => [
        view,
        edit,
        modify,
        publish,
        executeAction,
        createAction,
        decrypt,
      ];

  /// Returns a copy of this permission with select different values.
  BasePermissionData copyWith({
    bool? view,
    bool? edit,
    bool? modify,
    bool? publish,
    bool? executeAction,
    bool? createAction,
    bool? decrypt,
  }) =>
      BasePermissionData(
        view: view ?? this.view,
        edit: edit ?? this.edit,
        modify: modify ?? this.modify,
        publish: publish ?? this.publish,
        executeAction: executeAction ?? this.executeAction,
        createAction: createAction ?? this.createAction,
        decrypt: decrypt ?? this.decrypt,
      );

  @override
  String toString() => '<'
      '${[
        '${view.toLog('view')}',
        '${edit.toLog('edit')}',
        '${modify.toLog('modify')}',
        '${publish.toLog('publish')}',
        '${executeAction.toLog('executeAction')}',
        '${createAction.toLog('createAction')}',
        '${decrypt.toLog('decrypt')}',
      ].logJoin()}'
      '>';
}
