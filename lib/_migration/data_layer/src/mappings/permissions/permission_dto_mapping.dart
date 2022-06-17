import 'package:collection/collection.dart';

import '../../../../../data_layer/dtos.dart';
import '../../../../../domain_layer/models.dart';
import '../../../errors.dart';

/// Extension that provides mappings for a list of [PermissionDTO]
///
/// The backend returns a flat list of permissions, and this extension maps it
/// to our tree-like permission objects.
///
/// For instance, the backend may send this:
///
/// ```json
/// {
///   "permission_id": 132,
///   "module_id": "employees_details",
///   "object_id": "view",
///   "value": "T"
/// },
/// {
///   "permission_id": 133,
///   "module_id": "employees_details",
///   "object_id": "edit",
///   "value": "F"
/// }
/// ```
///
/// Which in turn sets the `employeesDetails.view` on [UserPermissions.]
/// property to `true` and the `employeesDetails.edit` on [UserPermissions]
/// property to false.
///
/// The mapping tries to group permissions in a way that makes sense.
///
/// Most of the permissions follow the base routine of edit/view/action/etc so
/// we have the [toBasePermissionData] method that parses these values. But
/// some permissions should be nested, or have different values, and that's
/// why we have different private methods to deal with them.
///
/// Now the app can just get the user permissions, and check if the user can
/// view the employee details with something like:
///
/// ```dart
/// if (userPermissions.employeesDetails.view) {...}
/// ```
///
/// ## Default values
///
/// ### Module default values
///
/// ```json
/// {
///   "permission_id": 71,
///   "module_id": "inbox",
///   "object_id": "*",
///   "value": "F"
/// },
/// {
///   "permission_id": 71,
///   "module_id": "inbox",
///   "object_id": "edit",
///   "value": "T"
/// }
/// ```
///
/// This will set `true` only for the edit property of the inbox module, setting
/// all the other properties to `false` on the inbox module, as they are not
/// explicitly specified.
///
/// ### General default value
///
/// ```json
/// {
///   "permission_id": 51,
///   "module_id": "*",
///   "object_id": "*",
///   "value": "T"
/// }
/// ```
///
/// This sets the default value for all modules and all properties that are not
/// specified.
///
/// So, in this case, first we look if the permission is set for a module_id
/// and object_id. If not, we'll try to set the default value based on the
/// module_id. If there's none, we fallback to general default value, in the
/// case above, everything will be set to `true` if not specified.
///
/// ## Non-boolean values
///
/// Not all permissions are boolean values. As such:
///
/// ```json
/// {
///   "permission_id": 17,
///   "module_id": "perfmon",
///   "object_id": "user",
///   "value": "editor"
/// }
/// ```
///
/// So this is mapped a bit differently, transforming the value into an
/// enumeration. We don't use anything generic (like [String]) for this kind
/// of value.
///
extension PermissionDTOListMapping on Iterable<PermissionDTO> {
  /// Maps into a [UserPermissions] object
  UserPermissions toUserPermissions() {
    // Gets the general defaults
    final defaults = where((e) => e.moduleId == PermissionDTO.defaultValue)
        .map(_Default.fromPermissionDTO)
        .toList(growable: false);

    return UserPermissions(
      accountTypes: toBasePermissionData('account_types', defaults),
      acl: toBasePermissionData('acl', defaults),
      appointmentScheduling:
          toBasePermissionData('appointment_scheduling', defaults),
      authorization: toBasePermissionData('authorization', defaults),
      balancesAndTransactions:
          toBasePermissionData('balances_and_transactions', defaults),
      banks: toBasePermissionData('banks', defaults),
      beneficiary: _toBeneficiaryPermissionData(defaults),
      benefitPay: toBasePermissionData('benefit_pay', defaults),
      calendarManagement:
          toBasePermissionData('calendars_management', defaults),
      campaign: toBasePermissionData('campaign', defaults),
      card: toBasePermissionData('card', defaults),
      cardTypes: toBasePermissionData('card_types', defaults),
      chatBot: toBasePermissionData('chatbot', defaults),
      checkbookTypes: toBasePermissionData('checkbook_types', defaults),
      countries: toBasePermissionData('countries', defaults),
      credentialsGeneration: _toCredentialsGenerationPermissionData(defaults),
      currencies: toBasePermissionData('currencies', defaults),
      customers: _toCustomersPermissionData(defaults),
      developerApp: toBasePermissionData('developer_app', defaults),
      developers: toBasePermissionData('developers', defaults),
      electronicStatement: toBasePermissionData('e_statement', defaults),
      employeesDetails: toBasePermissionData('employees_details', defaults),
      inbox: toBasePermissionData('inbox', defaults),
      info: _toInformationPermissionData(defaults),
      locations: toBasePermissionData('locations', defaults),
      manageDPA: toBasePermissionData('manage_DPA', defaults),
      messages: toBasePermissionData('messages', defaults),
      nextBestOffer: toBasePermissionData('next_best_offer', defaults),
      payment: _toPaymentPermissionData(defaults),
      payroll: toBasePermissionData('payroll', defaults),
      performanceMonitor: _toPerformanceMonitorPermissionData(),
      pfmRules: toBasePermissionData('PFM_rules', defaults),
      products: toBasePermissionData('products', defaults),
      reports: _toReportsPermissionsData(defaults),
      reporting: toBasePermissionData('reporting', defaults),
      rules: toBasePermissionData('rules', defaults),
      securitySettings: toBasePermissionData('security_settings', defaults),
      sendMoney: _toSendMoneyPermissionData(defaults),
      sysadmin: toBasePermissionData('sysadmin', defaults),
      transfer: _toTransferPermissionData(defaults),
    );
  }

  /// Filters the items by moduleId, and creates a new [BasePermissionData]
  /// taking into account the general defaults, the current module default,
  /// and also the optional suffix.
  ///
  /// The suffix is used when the data is on DTO in fields named like 'edit_bnk'
  /// and 'edit_crd', which means the first one is for the bank data and the
  /// second for the card. This allows us to break these items into separate
  /// [BasePermissionData] objects to make them easier to access.
  BasePermissionData toBasePermissionData(
    String moduleId,
    List<_Default> defaults, {
    String suffix = '',
    bool useSuffixForView = false,
  }) {
    final items = where(
      (e) => e.moduleId == moduleId,
    );

    final moduleDefaultValue = items._moduleDefaultValue();

    final end = suffix.isNotEmpty ? '_$suffix' : suffix;

    return BasePermissionData(
      view: items._calculateValue(
        useSuffixForView ? '$suffix' : 'view$end',
        defaults,
        moduleDefaultValue,
      ),
      edit: items._calculateValue('edit$end', defaults, moduleDefaultValue),
      modify: items._calculateValue('modify$end', defaults, moduleDefaultValue),
      publish:
          items._calculateValue('publish$end', defaults, moduleDefaultValue),
      executeAction: items._calculateValue(
          'exec_action$end', defaults, moduleDefaultValue),
      createAction: items._calculateValue(
          'create_action$end', defaults, moduleDefaultValue),
      decrypt:
          items._calculateValue('decrypt$end', defaults, moduleDefaultValue),
    );
  }

  /// Returns the boolean default value for the current module.
  bool? _moduleDefaultValue() {
    final value = firstWhereOrNull(
      (e) => e.moduleObjectId == PermissionDTO.defaultValue,
    )?.value;

    return value == null ? null : (value == PermissionDTO.trueValue);
  }

  /// Calculates the value of an object.
  ///
  /// If the value is explicitly defined on the DTO, use it. If not,
  /// try to use the module default value, the default for this kind of
  /// object, the general default, and, if nothing is set, return false.
  bool _calculateValue(
    String objectId,
    List<_Default>? defaults,
    bool? moduleDefaultValue,
  ) {
    final value = firstWhereOrNull(
      (e) => e.moduleObjectId == objectId,
    )?.value;

    final result = (value == null ? null : value == PermissionDTO.trueValue) ??
        moduleDefaultValue ??
        defaults
            ?.firstWhereOrNull(
              (e) => e.objectId == objectId,
            )
            ?.value ??
        defaults
            ?.firstWhereOrNull(
              (e) => e.objectId == null,
            )
            ?.value ??
        false;

    return result;
  }

  /// Creates a new permission data related to the beneficiary.
  BeneficiaryPermissionData _toBeneficiaryPermissionData(
    List<_Default> defaults,
  ) {
    final base = toBasePermissionData('beneficiary', defaults);

    return BeneficiaryPermissionData(
      view: base.view,
      edit: base.edit,
      modify: base.modify,
      publish: base.publish,
      executeAction: base.executeAction,
      createAction: base.createAction,
      decrypt: base.decrypt,
      international:
          toBasePermissionData('beneficiary', defaults, suffix: 'int'),
      domestic: toBasePermissionData('beneficiary', defaults, suffix: 'dom'),
      bank: toBasePermissionData('beneficiary', defaults, suffix: 'bnk'),
      management: toBasePermissionData('beneficiaries_management', defaults),
    );
  }

  /// Creates a new permission data related to the credentials generation.
  CredentialsGenerationPermissionData _toCredentialsGenerationPermissionData(
    List<_Default> defaults,
  ) {
    final base = toBasePermissionData('credentials_generation', defaults);

    return CredentialsGenerationPermissionData(
      view: base.view,
      edit: base.edit,
      modify: base.modify,
      publish: base.publish,
      executeAction: base.executeAction,
      createAction: base.createAction,
      decrypt: base.decrypt,
      individual:
          toBasePermissionData('credentials_generation_individual', defaults),
      corporate:
          toBasePermissionData('credentials_generation_corporate', defaults),
    );
  }

  /// Creates a new permission data related to the customers.
  CustomersPermissionData _toCustomersPermissionData(
    List<_Default> defaults,
  ) {
    /// Returns the extra data for the customers.
    CustomersExtraPermissionData _extra(
      String moduleId,
    ) {
      final items = where(
        (e) => e.moduleId == moduleId,
      );

      final moduleDefaultValue = items._moduleDefaultValue();

      return CustomersExtraPermissionData(
        view: items._calculateValue('view', defaults, moduleDefaultValue),
        edit: items._calculateValue('edit', defaults, moduleDefaultValue),
        modify: items._calculateValue('modify', defaults, moduleDefaultValue),
        publish: items._calculateValue('publish', defaults, moduleDefaultValue),
        executeAction:
            items._calculateValue('exec_action', defaults, moduleDefaultValue),
        createAction: items._calculateValue(
            'create_action', defaults, moduleDefaultValue),
        decrypt: items._calculateValue('decrypt', defaults, moduleDefaultValue),
        accounts:
            items._calculateValue('accounts', defaults, moduleDefaultValue),
        agents: items._calculateValue('agents', defaults, moduleDefaultValue),
        audit: items._calculateValue('audit', defaults, moduleDefaultValue),
        beneficiaries: items._calculateValue(
            'beneficiaries', defaults, moduleDefaultValue),
        bills: items._calculateValue('bills', defaults, moduleDefaultValue),
        cards: items._calculateValue('cards', defaults, moduleDefaultValue),
        checkbooks:
            items._calculateValue('checkbooks', defaults, moduleDefaultValue),
        details: items._calculateValue('details', defaults, moduleDefaultValue),
        devices: items._calculateValue('devices', defaults, moduleDefaultValue),
        payments:
            items._calculateValue('payments', defaults, moduleDefaultValue),
        topUps: items._calculateValue('topups', defaults, moduleDefaultValue),
        transfers:
            items._calculateValue('transfers', defaults, moduleDefaultValue),
      );
    }

    /// Returns the segments data for the customers.
    CustomerSegmentsPermissionData _segments() {
      final base = toBasePermissionData('customers', defaults);

      return CustomerSegmentsPermissionData(
        view: base.view,
        edit: base.edit,
        modify: base.modify,
        publish: base.publish,
        executeAction: base.executeAction,
        createAction: base.createAction,
        decrypt: base.decrypt,
        corporate:
            toBasePermissionData('customer_segments_corporate', defaults),
        individual:
            toBasePermissionData('customer_segments_individual', defaults),
      );
    }

    final base = toBasePermissionData('customers', defaults);

    return CustomersPermissionData(
      view: base.view,
      edit: base.edit,
      modify: base.modify,
      publish: base.publish,
      executeAction: base.executeAction,
      createAction: base.createAction,
      decrypt: base.decrypt,
      corporate: _extra('customers_corporate'),
      individual: _extra('customers_individual'),
      segments: _segments(),
      transaction: toBasePermissionData('customers', defaults, suffix: 'txn'),
      customerService: toBasePermissionData('customer_service', defaults),
    );
  }

  /// Creates a new permission data related to the information.
  InformationPermissionData _toInformationPermissionData(
    List<_Default> defaults,
  ) {
    final items = where(
      (e) => e.moduleId == 'info',
    );

    final moduleDefaultValue = items._moduleDefaultValue();

    return InformationPermissionData(
      accounts: items._calculateValue('accounts', defaults, moduleDefaultValue),
    );
  }

  /// Creates a new permission data related to the payments.
  PaymentPermissionData _toPaymentPermissionData(
    List<_Default> defaults,
  ) {
    final items = where(
      (e) => e.moduleId == 'payment',
    );

    final moduleDefaultValue = items._moduleDefaultValue();

    return PaymentPermissionData(
      view: items._calculateValue('view', defaults, moduleDefaultValue),
      edit: items._calculateValue('edit', defaults, moduleDefaultValue),
      modify: items._calculateValue('modify', defaults, moduleDefaultValue),
      publish: items._calculateValue('publish', defaults, moduleDefaultValue),
      executeAction:
          items._calculateValue('exec_action', defaults, moduleDefaultValue),
      createAction:
          items._calculateValue('create_action', defaults, moduleDefaultValue),
      decrypt: items._calculateValue('decrypt', defaults, moduleDefaultValue),
      bill: toBasePermissionData(
        'payment',
        defaults,
        suffix: 'bill',
        useSuffixForView: true,
      ),
      billers: toBasePermissionData('pmt_billers', defaults),
      settings: toBasePermissionData('pmt_settings', defaults),
      topUp: toBasePermissionData(
        'payment',
        defaults,
        suffix: 'topup',
        useSuffixForView: true,
      ),
      topUpProviders: toBasePermissionData('pmt_topup_providers', defaults),
    );
  }

  /// Creates a new permission data related to the performance monitor.
  PerformanceMonitorPermissionData _toPerformanceMonitorPermissionData() {
    final items = where(
      (e) => e.moduleId == 'perfmon',
    );

    return PerformanceMonitorPermissionData(
      user: items
              .firstWhereOrNull(
                (e) => e.moduleObjectId == 'user',
              )
              ?.value
              ?.toPerformanceMonitorPermissionType() ??
          PerformanceMonitorPermissionType.none,
    );
  }

  /// Creates a new permission data related to the reports.
  ReportsPermissionsData _toReportsPermissionsData(
    List<_Default> defaults,
  ) {
    final items = where(
      (e) => e.moduleId == 'reports',
    );

    final moduleDefaultValue = items._moduleDefaultValue();

    return ReportsPermissionsData(
      applicationIssue: items._calculateValue(
          'application_issue', defaults, moduleDefaultValue),
      applicationNotice: items._calculateValue(
          'application_notice', defaults, moduleDefaultValue),
      assign: items._calculateValue('assign', defaults, moduleDefaultValue),
      customerCare:
          items._calculateValue('customer_care', defaults, moduleDefaultValue),
      edit: items._calculateValue('edit', defaults, moduleDefaultValue),
      offerInquiry:
          items._calculateValue('offer_inquiry', defaults, moduleDefaultValue),
      others: items._calculateValue('others', defaults, moduleDefaultValue),
      productInquiry: items._calculateValue(
          'product_inquiry', defaults, moduleDefaultValue),
      productsService: items._calculateValue(
          'products_service', defaults, moduleDefaultValue),
      serviceFeedback: items._calculateValue(
          'service_feedback', defaults, moduleDefaultValue),
      serviceInquiry: items._calculateValue(
          'service_inquiry', defaults, moduleDefaultValue),
    );
  }

  /// Creates a new permission data related to sending money.
  SendMoneyPermissionData _toSendMoneyPermissionData(
    List<_Default> defaults,
  ) {
    final items = where(
      (e) => e.moduleId == 'sendmoney',
    );

    final moduleDefaultValue = items._moduleDefaultValue();

    return SendMoneyPermissionData(
      bank: items._calculateValue('bnk', defaults, moduleDefaultValue),
      domestic: items._calculateValue('dom', defaults, moduleDefaultValue),
      own: items._calculateValue('own', defaults, moduleDefaultValue),
    );
  }

  /// Creates a new permission data related to the transfers.
  TransferPermissionData _toTransferPermissionData(
    List<_Default> defaults,
  ) =>
      TransferPermissionData(
        allowedCurrencies: toBasePermissionData(
          'trf_allowed_currencies',
          defaults,
        ),
        bank: toBasePermissionData(
          'transfer',
          defaults,
          suffix: 'bnk',
          useSuffixForView: true,
        ),
        bulk: toBasePermissionData(
          'transfer',
          defaults,
          suffix: 'blk',
          useSuffixForView: true,
        ),
        card: toBasePermissionData(
          'transfer',
          defaults,
          suffix: 'crd',
          useSuffixForView: true,
        ),
        domestic: toBasePermissionData(
          'transfer',
          defaults,
          suffix: 'dom',
          useSuffixForView: true,
        ),
        instant: toBasePermissionData(
          'transfer',
          defaults,
          suffix: 'instant',
          useSuffixForView: true,
        ),
        international: toBasePermissionData(
          'transfer',
          defaults,
          suffix: 'int',
          useSuffixForView: true,
        ),
        limits: toBasePermissionData('trf_limits', defaults),
        merchant: toBasePermissionData(
          'transfer',
          defaults,
          suffix: 'merchant',
          useSuffixForView: true,
        ),
        mobile: toBasePermissionData(
          'transfer',
          defaults,
          suffix: 'mobile',
          useSuffixForView: true,
        ),
        own: toBasePermissionData(
          'transfer',
          defaults,
          suffix: 'own',
          useSuffixForView: true,
        ),
        reason: toBasePermissionData('trf_reasons', defaults),
      );
}

/// A class that holds a default boolean value for a module object or an entire
/// module.
class _Default {
  final String? objectId;
  final bool? value;

  _Default({
    this.objectId,
    this.value,
  });

  factory _Default.fromPermissionDTO(PermissionDTO p) => _Default(
        objectId: p.moduleObjectId == PermissionDTO.defaultValue
            ? null
            : p.moduleObjectId,
        value: p.value == PermissionDTO.trueValue,
      );

  @override
  String toString() => '<objectId: $objectId, value: $value>';
}

/// Internal extension to transform an object into the permissions enums.
extension _StringPermissionMapping on Object {
  /// Maps this object into a [PerformanceMonitorPermissionType].
  PerformanceMonitorPermissionType toPerformanceMonitorPermissionType() {
    if (this is! String) return PerformanceMonitorPermissionType.none;

    switch (this as String) {
      case 'editor':
        return PerformanceMonitorPermissionType.editor;

      case '':
      case 'none':
        return PerformanceMonitorPermissionType.none;

      default:
        throw MappingException(
          from: Object,
          to: PerformanceMonitorPermissionType,
          value: this,
        );
    }
  }
}
