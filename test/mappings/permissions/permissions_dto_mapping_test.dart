import 'package:equatable/equatable.dart';
import 'package:layer_sdk/_migration/data_layer/data_layer.dart';
import 'package:layer_sdk/_migration/data_layer/src/dtos.dart';
import 'package:layer_sdk/_migration/data_layer/src/mappings.dart';
import 'package:test/test.dart';

void main() {
  EquatableConfig.stringify = true;

  group('Permission DTO Mapping', () {
    final _nothingAllowed = _createPermissions(defaultValue: false);
    final _allAllowed = _createPermissions(defaultValue: true);

    final _dtoPermitted = <PermissionDTO>[
      PermissionDTO(
        id: 1,
        moduleId: PermissionDTO.defaultValue,
        moduleObjectId: PermissionDTO.defaultValue,
        value: PermissionDTO.trueValue,
      ),
    ];

    test('Should default to false on all permissions.', () {
      expect(
        <PermissionDTO>[].toUserPermissions(),
        _nothingAllowed,
      );
    });

    test('Should use general default true when passed.', () {
      expect(
        _dtoPermitted.toUserPermissions(),
        _allAllowed,
      );
    });

    test('Should use general object default when passed.', () {
      expect(
        <PermissionDTO>[
          PermissionDTO(
            id: 2,
            moduleId: PermissionDTO.defaultValue,
            moduleObjectId: 'edit',
            value: PermissionDTO.trueValue,
          ),
        ].toUserPermissions(),
        _createPermissions(defaultEdit: true),
      );
    });

    test('Should use module default when passed.', () {
      expect(
        <PermissionDTO>[
          PermissionDTO(
            id: 2,
            moduleId: 'authorization',
            moduleObjectId: PermissionDTO.defaultValue,
            value: PermissionDTO.trueValue,
          ),
        ].toUserPermissions(),
        _nothingAllowed.copyWith(
          authorization: _createBasePermission(defaultValue: true),
        ),
      );
    });

    test('Should set individual values.', () {
      expect(
        <PermissionDTO>[
          PermissionDTO(
            id: 3,
            moduleId: 'banks',
            moduleObjectId: PermissionDTO.defaultValue,
            value: PermissionDTO.trueValue,
          ),
          PermissionDTO(
            id: 4,
            moduleId: 'banks',
            moduleObjectId: 'edit',
            value: 'F',
          ),
          PermissionDTO(
            id: 5,
            moduleId: 'banks',
            moduleObjectId: 'publish',
            value: 'F',
          ),
        ].toUserPermissions(),
        _nothingAllowed.copyWith(
          banks: _createBasePermission(
            defaultValue: true,
          ).copyWith(
            publish: false,
            edit: false,
          ),
        ),
      );
    });

    test('Should set performance monitor data.', () {
      expect(
        [
          ..._dtoPermitted,
          PermissionDTO(
            id: 52,
            moduleId: 'perfmon',
            moduleObjectId: 'user',
            value: 'editor',
          ),
        ].toUserPermissions(),
        _allAllowed.copyWith(
          performanceMonitor: PerformanceMonitorPermissionData(
            user: PerformanceMonitorPermissionType.editor,
          ),
        ),
      );
    });

    test('Should set send money data.', () {
      expect(
        [
          ..._dtoPermitted,
          PermissionDTO(
            id: 50,
            moduleId: 'sendmoney',
            moduleObjectId: PermissionDTO.defaultValue,
            value: 'F',
          ),
          PermissionDTO(
            id: 50,
            moduleId: 'sendmoney',
            moduleObjectId: 'bnk',
            value: PermissionDTO.trueValue,
          ),
        ].toUserPermissions(),
        _allAllowed.copyWith(
          sendMoney: SendMoneyPermissionData(
            domestic: false,
            bank: true,
            own: false,
          ),
        ),
      );
    });
  }); // Permission DTO Mapping Group
}

BasePermissionData _createBasePermission({
  bool defaultValue = false,
  bool? defaultEdit,
}) =>
    BasePermissionData(
      view: defaultValue,
      edit: defaultEdit ?? defaultValue,
      modify: defaultValue,
      publish: defaultValue,
      executeAction: defaultValue,
      createAction: defaultValue,
      decrypt: defaultValue,
    );

UserPermissions _createPermissions({
  bool defaultValue = false,
  bool? defaultEdit,
}) {
  final defaultBase = _createBasePermission(
    defaultValue: defaultValue,
  );

  final base = _createBasePermission(
    defaultValue: defaultValue,
    defaultEdit: defaultEdit,
  );

  final customerExtra = CustomersExtraPermissionData(
    view: base.view,
    edit: base.edit,
    modify: base.modify,
    publish: base.publish,
    executeAction: base.executeAction,
    createAction: base.createAction,
    decrypt: base.decrypt,
    accounts: defaultValue,
    agents: defaultValue,
    audit: defaultValue,
    beneficiaries: defaultValue,
    bills: defaultValue,
    cards: defaultValue,
    checkbooks: defaultValue,
    details: defaultValue,
    devices: defaultValue,
    payments: defaultValue,
    topUps: defaultValue,
    transfers: defaultValue,
  );

  return UserPermissions(
    accountTypes: base,
    acl: base,
    appointmentScheduling: base,
    authorization: base,
    balancesAndTransactions: base,
    banks: base,
    beneficiary: BeneficiaryPermissionData(
      view: base.view,
      edit: base.edit,
      modify: base.modify,
      publish: base.publish,
      executeAction: base.executeAction,
      createAction: base.createAction,
      decrypt: base.decrypt,
      international: defaultBase,
      domestic: defaultBase,
      bank: defaultBase,
      management: base,
    ),
    benefitPay: base,
    calendarManagement: base,
    campaign: base,
    card: base,
    cardTypes: base,
    chatBot: base,
    checkbookTypes: base,
    countries: base,
    credentialsGeneration: CredentialsGenerationPermissionData(
      view: base.view,
      edit: base.edit,
      modify: base.modify,
      publish: base.publish,
      executeAction: base.executeAction,
      createAction: base.createAction,
      decrypt: base.decrypt,
      individual: base,
      corporate: base,
    ),
    currencies: base,
    customers: CustomersPermissionData(
      view: base.view,
      edit: base.edit,
      modify: base.modify,
      publish: base.publish,
      executeAction: base.executeAction,
      createAction: base.createAction,
      decrypt: base.decrypt,
      corporate: customerExtra,
      individual: customerExtra,
      segments: CustomerSegmentsPermissionData(
        view: base.view,
        edit: base.edit,
        modify: base.modify,
        publish: base.publish,
        executeAction: base.executeAction,
        createAction: base.createAction,
        decrypt: base.decrypt,
        individual: base,
        corporate: base,
      ),
      transaction: defaultBase,
      customerService: base,
    ),
    developerApp: base,
    developers: base,
    electronicStatement: base,
    employeesDetails: base,
    inbox: base,
    info: InformationPermissionData(
      accounts: defaultValue,
    ),
    locations: base,
    manageDPA: base,
    messages: base,
    nextBestOffer: base,
    payment: PaymentPermissionData(
      view: base.view,
      edit: base.edit,
      modify: base.modify,
      publish: base.publish,
      executeAction: base.executeAction,
      createAction: base.createAction,
      decrypt: base.decrypt,
      bill: defaultBase,
      billers: base,
      settings: base,
      topUp: defaultBase,
      topUpProviders: base,
    ),
    payroll: base,
    performanceMonitor: PerformanceMonitorPermissionData(
      user: PerformanceMonitorPermissionType.none,
    ),
    pfmRules: base,
    products: base,
    reports: ReportsPermissionsData(
      applicationIssue: defaultValue,
      applicationNotice: defaultValue,
      assign: defaultValue,
      customerCare: defaultValue,
      edit: defaultEdit ?? defaultValue,
      offerInquiry: defaultValue,
      others: defaultValue,
      productInquiry: defaultValue,
      productsService: defaultValue,
      serviceFeedback: defaultValue,
      serviceInquiry: defaultValue,
    ),
    reporting: base,
    rules: base,
    securitySettings: base,
    sendMoney: SendMoneyPermissionData(
      bank: defaultValue,
      domestic: defaultValue,
      own: defaultValue,
    ),
    sysadmin: base,
    transfer: TransferPermissionData(
      allowedCurrencies: base,
      bank: defaultBase,
      bulk: defaultBase,
      card: defaultBase,
      domestic: defaultBase,
      instant: defaultBase,
      international: defaultBase,
      limits: base,
      merchant: defaultBase,
      mobile: defaultBase,
      own: defaultBase,
      reason: base,
    ),
  );
}
