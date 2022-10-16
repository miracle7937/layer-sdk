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

  /// Checks if any of the underlying permissions are visible.
  bool get canDoAnyPayment => [
        bill,
        billers,
        settings,
        topUp,
        topUpProviders,
      ].any((e) => e.isFeatureVisible);

  @override
  bool get isFeatureVisible => canDoAnyPayment || (view || edit);

  /// Creates a [PaymentPermissionData] object.
  const PaymentPermissionData({
    super.view = false,
    super.edit = false,
    super.modify = false,
    super.publish = false,
    super.executeAction = false,
    super.createAction = false,
    super.decrypt = false,
    this.bill = const BasePermissionData(),
    this.billers = const BasePermissionData(),
    this.settings = const BasePermissionData(),
    this.topUp = const BasePermissionData(),
    this.topUpProviders = const BasePermissionData(),
  });

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
