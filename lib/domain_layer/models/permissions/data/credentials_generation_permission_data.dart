import '../../../../data_layer/extensions.dart';
import '../../../models.dart';

/// Permissions related to credentials generation.
///
/// The common permissions are at the root of the object.
class CredentialsGenerationPermissionData extends BasePermissionData {
  /// Corporate specific permissions.
  final BasePermissionData corporate;

  /// Individual specific permissions.
  final BasePermissionData individual;

  /// Creates a [CredentialsGenerationPermissionData] object.
  const CredentialsGenerationPermissionData({
    bool view = false,
    bool edit = false,
    bool modify = false,
    bool publish = false,
    bool executeAction = false,
    bool createAction = false,
    bool decrypt = false,
    this.individual = const BasePermissionData(),
    this.corporate = const BasePermissionData(),
  }) : super(
          view: view,
          edit: edit,
          modify: modify,
          publish: publish,
          executeAction: executeAction,
          createAction: createAction,
          decrypt: decrypt,
        );

  @override
  List<Object> get props => super.props
    ..addAll([
      corporate,
      individual,
    ]);

  /// Returns a copy of this permission with select different values.
  CredentialsGenerationPermissionData copyWith({
    bool? view,
    bool? edit,
    bool? modify,
    bool? publish,
    bool? executeAction,
    bool? createAction,
    bool? decrypt,
    BasePermissionData? individual,
    BasePermissionData? corporate,
  }) =>
      CredentialsGenerationPermissionData(
        view: view ?? this.view,
        edit: edit ?? this.edit,
        modify: modify ?? this.modify,
        publish: publish ?? this.publish,
        executeAction: executeAction ?? this.executeAction,
        createAction: createAction ?? this.createAction,
        decrypt: decrypt ?? this.decrypt,
        individual: individual ?? this.individual,
        corporate: corporate ?? this.corporate,
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
        'corporate: $corporate',
        'individual: $individual',
      ].logJoin()}'
      '>';
}
