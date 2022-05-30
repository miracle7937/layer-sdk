import '../../../../data_layer/extensions.dart';
import '../../../models.dart';

/// Permissions related to payments.
///
/// The common permissions are at the root of the object.
class PaymentPermissionData extends BasePermissionData {
  /// Bill specific permissions.
  final BasePermissionData bill;

  /// Billers specific permissions.
  final BasePermissionData billers;

  /// Settings specific permissions.
  final BasePermissionData settings;

  /// Top up specific permissions.
  final BasePermissionData topUp;

  /// Top up providers specific permissions.
  final BasePermissionData topUpProviders;

  /// Creates a [PaymentPermissionData] object.
  const PaymentPermissionData({
    bool view = false,
    bool edit = false,
    bool modify = false,
    bool publish = false,
    bool executeAction = false,
    bool createAction = false,
    bool decrypt = false,
    this.bill = const BasePermissionData(),
    this.billers = const BasePermissionData(),
    this.settings = const BasePermissionData(),
    this.topUp = const BasePermissionData(),
    this.topUpProviders = const BasePermissionData(),
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
      bill,
      billers,
      settings,
      topUp,
      topUpProviders,
    ]);

  /// Returns a copy of this permission with select different values.
  PaymentPermissionData copyWith({
    bool? view,
    bool? edit,
    bool? modify,
    bool? publish,
    bool? executeAction,
    bool? createAction,
    bool? decrypt,
    BasePermissionData? bill,
    BasePermissionData? billers,
    BasePermissionData? settings,
    BasePermissionData? topUp,
    BasePermissionData? topUpProviders,
  }) =>
      PaymentPermissionData(
        view: view ?? this.view,
        edit: edit ?? this.edit,
        modify: modify ?? this.modify,
        publish: publish ?? this.publish,
        executeAction: executeAction ?? this.executeAction,
        createAction: createAction ?? this.createAction,
        decrypt: decrypt ?? this.decrypt,
        bill: bill ?? this.bill,
        billers: billers ?? this.billers,
        settings: settings ?? this.settings,
        topUp: topUp ?? this.topUp,
        topUpProviders: topUpProviders ?? this.topUpProviders,
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
        'bill: $bill',
        'billers: $billers',
        'settings: $settings',
        'topUp: $topUp',
        'topUpProviders: $topUpProviders',
      ].logJoin()}'
      '>';
}
