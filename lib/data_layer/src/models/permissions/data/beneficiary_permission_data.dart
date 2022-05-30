import '../../../../extensions.dart';
import '../../../../models.dart';

/// Permissions related to the Beneficiary.
///
/// The common permissions are at the root of the object.
class BeneficiaryPermissionData extends BasePermissionData {
  /// International specific permissions.
  final BasePermissionData international;

  /// Domestic specific permissions.
  final BasePermissionData domestic;

  /// Bank specific permissions.
  final BasePermissionData bank;

  /// Management specific permissions
  final BasePermissionData management;

  /// Creates a [BeneficiaryPermissionData] object.
  const BeneficiaryPermissionData({
    bool view = false,
    bool edit = false,
    bool modify = false,
    bool publish = false,
    bool executeAction = false,
    bool createAction = false,
    bool decrypt = false,
    this.international = const BasePermissionData(),
    this.domestic = const BasePermissionData(),
    this.bank = const BasePermissionData(),
    this.management = const BasePermissionData(),
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
      international,
      domestic,
      bank,
      management,
    ]);

  /// Returns a copy of this permission with select different values.
  BeneficiaryPermissionData copyWith({
    bool? view,
    bool? edit,
    bool? modify,
    bool? publish,
    bool? executeAction,
    bool? createAction,
    bool? decrypt,
    BasePermissionData? international,
    BasePermissionData? domestic,
    BasePermissionData? bank,
    BasePermissionData? management,
  }) =>
      BeneficiaryPermissionData(
        view: view ?? this.view,
        edit: edit ?? this.edit,
        modify: modify ?? this.modify,
        publish: publish ?? this.publish,
        executeAction: executeAction ?? this.executeAction,
        createAction: createAction ?? this.createAction,
        decrypt: decrypt ?? this.decrypt,
        international: international ?? this.international,
        domestic: domestic ?? this.domestic,
        bank: bank ?? this.bank,
        management: management ?? this.management,
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
        'international: $international',
        'domestic: $domestic',
        'bank: $bank',
        'management: $management',
      ].logJoin()}'
      '>';
}
