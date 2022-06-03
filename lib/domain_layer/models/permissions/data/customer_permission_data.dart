import '../../../../data_layer/extensions.dart';
import '../../../models.dart';

/// Common permissions related to customers.
///
/// The common permissions are at the root of the object.
class CustomersPermissionData extends BasePermissionData {
  /// Corporate specific permissions.
  final CustomersExtraPermissionData corporate;

  /// Individual specific permissions.
  final CustomersExtraPermissionData individual;

  /// Segments specific permissions.
  final CustomerSegmentsPermissionData segments;

  /// Transaction specific permissions.
  final BasePermissionData transaction;

  /// Permissions for customer Service.
  final BasePermissionData customerService;

  /// Creates a [CustomersPermissionData] object.
  const CustomersPermissionData({
    bool view = false,
    bool edit = false,
    bool modify = false,
    bool publish = false,
    bool executeAction = false,
    bool createAction = false,
    bool decrypt = false,
    this.corporate = const CustomersExtraPermissionData(),
    this.individual = const CustomersExtraPermissionData(),
    this.segments = const CustomerSegmentsPermissionData(),
    this.transaction = const BasePermissionData(),
    this.customerService = const BasePermissionData(),
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
      segments,
      transaction,
      customerService,
    ]);

  /// Returns a copy of this permission with select different values.
  CustomersPermissionData copyWith({
    bool? view,
    bool? edit,
    bool? modify,
    bool? publish,
    bool? executeAction,
    bool? createAction,
    bool? decrypt,
    CustomersExtraPermissionData? corporate,
    CustomersExtraPermissionData? individual,
    CustomerSegmentsPermissionData? segments,
    BasePermissionData? transaction,
    BasePermissionData? customerService,
  }) =>
      CustomersPermissionData(
        view: view ?? this.view,
        edit: edit ?? this.edit,
        modify: modify ?? this.modify,
        publish: publish ?? this.publish,
        executeAction: executeAction ?? this.executeAction,
        createAction: createAction ?? this.createAction,
        decrypt: decrypt ?? this.decrypt,
        corporate: corporate ?? this.corporate,
        individual: individual ?? this.individual,
        segments: segments ?? this.segments,
        transaction: transaction ?? this.transaction,
        customerService: customerService ?? this.customerService,
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
        'segments: $segments',
        'transaction: $transaction',
        'customerService: $customerService',
      ].logJoin()}'
      '>';
}

/// Common permissions related to specific customer modules.
///
/// The common permissions are at the root of the object.
class CustomersExtraPermissionData extends BasePermissionData {
  /// Accounts specific permissions.
  final bool accounts;

  /// Agents specific permissions.
  final bool agents;

  /// Audit specific permissions.
  final bool audit;

  /// Beneficiaries specific permissions.
  final bool beneficiaries;

  /// Bills specific permissions.
  final bool bills;

  /// Cards specific permissions.
  final bool cards;

  /// Checkbooks specific permissions.
  final bool checkbooks;

  /// Details specific permissions.
  final bool details;

  /// Devices specific permissions.
  final bool devices;

  /// Payments specific permissions.
  final bool payments;

  /// Top up specific permissions.
  final bool topUps;

  /// Transfers specific permissions.
  final bool transfers;

  /// Creates a [CustomersExtraPermissionData] object.
  const CustomersExtraPermissionData({
    bool view = false,
    bool edit = false,
    bool modify = false,
    bool publish = false,
    bool executeAction = false,
    bool createAction = false,
    bool decrypt = false,
    this.accounts = false,
    this.agents = false,
    this.audit = false,
    this.beneficiaries = false,
    this.bills = false,
    this.cards = false,
    this.checkbooks = false,
    this.details = false,
    this.devices = false,
    this.payments = false,
    this.topUps = false,
    this.transfers = false,
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
      accounts,
      agents,
      audit,
      beneficiaries,
      bills,
      cards,
      checkbooks,
      details,
      devices,
      payments,
      topUps,
      transfers,
    ]);

  /// Returns a copy of this permission with select different values.
  CustomersExtraPermissionData copyWith({
    bool? view,
    bool? edit,
    bool? modify,
    bool? publish,
    bool? executeAction,
    bool? createAction,
    bool? decrypt,
    bool? accounts,
    bool? agents,
    bool? audit,
    bool? beneficiaries,
    bool? bills,
    bool? cards,
    bool? checkbooks,
    bool? details,
    bool? devices,
    bool? payments,
    bool? topUps,
    bool? transfers,
  }) =>
      CustomersExtraPermissionData(
        view: view ?? this.view,
        edit: edit ?? this.edit,
        modify: modify ?? this.modify,
        publish: publish ?? this.publish,
        executeAction: executeAction ?? this.executeAction,
        createAction: createAction ?? this.createAction,
        decrypt: decrypt ?? this.decrypt,
        accounts: accounts ?? this.accounts,
        agents: agents ?? this.agents,
        audit: audit ?? this.audit,
        beneficiaries: beneficiaries ?? this.beneficiaries,
        bills: bills ?? this.bills,
        cards: cards ?? this.cards,
        checkbooks: checkbooks ?? this.checkbooks,
        details: details ?? this.details,
        devices: devices ?? this.devices,
        payments: payments ?? this.payments,
        topUps: topUps ?? this.topUps,
        transfers: transfers ?? this.transfers,
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
        '${accounts.toLog('accounts')}',
        '${agents.toLog('agents')}',
        '${audit.toLog('audit')}',
        '${beneficiaries.toLog('beneficiaries')}',
        '${bills.toLog('bills')}',
        '${cards.toLog('cards')}',
        '${checkbooks.toLog('checkbooks')}',
        '${details.toLog('details')}',
        '${devices.toLog('devices')}',
        '${payments.toLog('payments')}',
        '${topUps.toLog('topUps')}',
        '${transfers.toLog('transfers')}',
      ].logJoin()}'
      '>';
}

/// Permissions related to customer segments.
///
/// The common permissions are at the root of the object.
class CustomerSegmentsPermissionData extends BasePermissionData {
  /// Corporate specific permissions.
  final BasePermissionData corporate;

  /// Individual specific permissions.
  final BasePermissionData individual;

  /// Creates a [CustomerSegmentsPermissionData] object.
  const CustomerSegmentsPermissionData({
    bool view = false,
    bool edit = false,
    bool modify = false,
    bool publish = false,
    bool executeAction = false,
    bool createAction = false,
    bool decrypt = false,
    this.corporate = const BasePermissionData(),
    this.individual = const BasePermissionData(),
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
  CustomerSegmentsPermissionData copyWith({
    bool? view,
    bool? edit,
    bool? modify,
    bool? publish,
    bool? executeAction,
    bool? createAction,
    bool? decrypt,
    BasePermissionData? corporate,
    BasePermissionData? individual,
  }) =>
      CustomerSegmentsPermissionData(
        view: view ?? this.view,
        edit: edit ?? this.edit,
        modify: modify ?? this.modify,
        publish: publish ?? this.publish,
        executeAction: executeAction ?? this.executeAction,
        createAction: createAction ?? this.createAction,
        decrypt: decrypt ?? this.decrypt,
        corporate: corporate ?? this.corporate,
        individual: individual ?? this.individual,
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
