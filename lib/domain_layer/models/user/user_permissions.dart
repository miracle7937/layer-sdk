import 'package:equatable/equatable.dart';

import '../../models.dart';

/// Holds the permissions of an user.
class UserPermissions extends Equatable {
  /// Permissions for account types.
  final BasePermissionData accountTypes;

  /// Permissions for ACL (allowance for credit losses).
  final BasePermissionData acl;

  /// Permissions for appointment scheduling.
  final BasePermissionData appointmentScheduling;

  /// Permissions for authorization.
  final BasePermissionData authorization;

  /// Permissions for balances and transactions.
  final BasePermissionData balancesAndTransactions;

  /// Permissions for banks.
  final BasePermissionData banks;

  /// Permissions for beneficiaries.
  final BeneficiaryPermissionData beneficiary;

  /// Permissions for benefit pay.
  final BasePermissionData benefitPay;

  /// Permissions for calendar management.
  final BasePermissionData calendarManagement;

  /// Permissions for campaign.
  final BasePermissionData campaign;

  /// Permissions for card.
  final BasePermissionData card;

  /// Permissions for card types.
  final BasePermissionData cardTypes;

  /// Permissions for chat bot.
  final BasePermissionData chatBot;

  /// Permissions for checkbook types.
  final BasePermissionData checkbookTypes;

  /// Permissions for countries.
  final BasePermissionData countries;

  /// Permissions for credentials generation.
  final CredentialsGenerationPermissionData credentialsGeneration;

  /// Permissions for currencies.
  final BasePermissionData currencies;

  /// Permissions for customers.
  final CustomersPermissionData customers;

  /// Permissions for developer application.
  final BasePermissionData developerApp;

  /// Permissions for developers.
  final BasePermissionData developers;

  /// Permissions for e-statement.
  final BasePermissionData electronicStatement;

  /// Permissions for employees details.
  final BasePermissionData employeesDetails;

  /// Permissions for inbox.
  final BasePermissionData inbox;

  /// Permissions for information.
  final InformationPermissionData info;

  /// Permissions for locations.
  final BasePermissionData locations;

  /// Permissions for managing DPA.
  final BasePermissionData manageDPA;

  /// Permissions for messages.
  final BasePermissionData messages;

  /// Permissions for next best offer.
  final BasePermissionData nextBestOffer;

  /// Permissions for payment.
  final PaymentPermissionData payment;

  /// Permissions for payroll.
  final BasePermissionData payroll;

  /// Permissions for perfmon (performance monitoring).
  final PerformanceMonitorPermissionData performanceMonitor;

  /// Permissions for PFM (Personal Financial Management) rules.
  final BasePermissionData pfmRules;

  /// Permissions for products.
  final BasePermissionData products;

  /// Permissions for reports.
  final ReportsPermissionsData reports;

  /// Permissions for reporting.
  final BasePermissionData reporting;

  /// Permissions for general rules.
  final BasePermissionData rules;

  /// Permissions for security settings.
  final BasePermissionData securitySettings;

  /// Permissions for sending money.
  final SendMoneyPermissionData sendMoney;

  /// Permissions for system administration.
  final BasePermissionData sysadmin;

  /// Permissions for transfers.
  final TransferPermissionData transfer;

  /// Creates a new [UserPermissions].
  const UserPermissions({
    this.accountTypes = const BasePermissionData(),
    this.acl = const BasePermissionData(),
    this.appointmentScheduling = const BasePermissionData(),
    this.authorization = const BasePermissionData(),
    this.balancesAndTransactions = const BasePermissionData(),
    this.banks = const BasePermissionData(),
    this.beneficiary = const BeneficiaryPermissionData(),
    this.benefitPay = const BasePermissionData(),
    this.calendarManagement = const BasePermissionData(),
    this.campaign = const BasePermissionData(),
    this.card = const BasePermissionData(),
    this.cardTypes = const BasePermissionData(),
    this.chatBot = const BasePermissionData(),
    this.checkbookTypes = const BasePermissionData(),
    this.countries = const BasePermissionData(),
    this.credentialsGeneration = const CredentialsGenerationPermissionData(),
    this.currencies = const BasePermissionData(),
    this.customers = const CustomersPermissionData(),
    this.developerApp = const BasePermissionData(),
    this.developers = const BasePermissionData(),
    this.electronicStatement = const BasePermissionData(),
    this.employeesDetails = const BasePermissionData(),
    this.inbox = const BasePermissionData(),
    this.info = const InformationPermissionData(),
    this.locations = const BasePermissionData(),
    this.manageDPA = const BasePermissionData(),
    this.messages = const BasePermissionData(),
    this.nextBestOffer = const BasePermissionData(),
    this.payment = const PaymentPermissionData(),
    this.payroll = const BasePermissionData(),
    this.performanceMonitor = const PerformanceMonitorPermissionData(),
    this.pfmRules = const BasePermissionData(),
    this.products = const BasePermissionData(),
    this.reports = const ReportsPermissionsData(),
    this.reporting = const BasePermissionData(),
    this.rules = const BasePermissionData(),
    this.securitySettings = const BasePermissionData(),
    this.sendMoney = const SendMoneyPermissionData(),
    this.sysadmin = const BasePermissionData(),
    this.transfer = const TransferPermissionData(),
  });

  @override
  List<Object> get props => [
        accountTypes,
        acl,
        appointmentScheduling,
        authorization,
        balancesAndTransactions,
        banks,
        beneficiary,
        benefitPay,
        calendarManagement,
        campaign,
        card,
        cardTypes,
        chatBot,
        checkbookTypes,
        countries,
        credentialsGeneration,
        currencies,
        customers,
        developerApp,
        developers,
        electronicStatement,
        employeesDetails,
        inbox,
        info,
        locations,
        manageDPA,
        messages,
        nextBestOffer,
        payment,
        payroll,
        performanceMonitor,
        pfmRules,
        products,
        reports,
        reporting,
        rules,
        securitySettings,
        sendMoney,
        sysadmin,
        transfer,
      ];

  /// Returns a copy with select different values.
  UserPermissions copyWith({
    BasePermissionData? accountTypes,
    BasePermissionData? acl,
    BasePermissionData? appointmentScheduling,
    BasePermissionData? authorization,
    BasePermissionData? balancesAndTransactions,
    BasePermissionData? banks,
    BeneficiaryPermissionData? beneficiary,
    BasePermissionData? benefitPay,
    BasePermissionData? calendarManagement,
    BasePermissionData? campaign,
    BasePermissionData? card,
    BasePermissionData? cardTypes,
    BasePermissionData? chatBot,
    BasePermissionData? checkbookTypes,
    BasePermissionData? countries,
    CredentialsGenerationPermissionData? credentialsGeneration,
    BasePermissionData? currencies,
    CustomersPermissionData? customers,
    BasePermissionData? developerApp,
    BasePermissionData? developers,
    BasePermissionData? electronicStatement,
    BasePermissionData? employeesDetails,
    BasePermissionData? inbox,
    InformationPermissionData? info,
    BasePermissionData? locations,
    BasePermissionData? manageDPA,
    BasePermissionData? messages,
    BasePermissionData? nextBestOffer,
    PaymentPermissionData? payment,
    BasePermissionData? payroll,
    PerformanceMonitorPermissionData? performanceMonitor,
    BasePermissionData? pfmRules,
    BasePermissionData? products,
    ReportsPermissionsData? reports,
    BasePermissionData? reporting,
    BasePermissionData? rules,
    BasePermissionData? securitySettings,
    SendMoneyPermissionData? sendMoney,
    BasePermissionData? sysadmin,
    TransferPermissionData? transfer,
  }) =>
      UserPermissions(
        accountTypes: accountTypes ?? this.accountTypes,
        acl: acl ?? this.acl,
        appointmentScheduling:
            appointmentScheduling ?? this.appointmentScheduling,
        authorization: authorization ?? this.authorization,
        balancesAndTransactions:
            balancesAndTransactions ?? this.balancesAndTransactions,
        banks: banks ?? this.banks,
        beneficiary: beneficiary ?? this.beneficiary,
        benefitPay: benefitPay ?? this.benefitPay,
        calendarManagement: calendarManagement ?? this.calendarManagement,
        campaign: campaign ?? this.campaign,
        card: card ?? this.card,
        cardTypes: cardTypes ?? this.cardTypes,
        chatBot: chatBot ?? this.chatBot,
        checkbookTypes: checkbookTypes ?? this.checkbookTypes,
        countries: countries ?? this.countries,
        credentialsGeneration:
            credentialsGeneration ?? this.credentialsGeneration,
        currencies: currencies ?? this.currencies,
        customers: customers ?? this.customers,
        developerApp: developerApp ?? this.developerApp,
        developers: developers ?? this.developers,
        electronicStatement: electronicStatement ?? this.electronicStatement,
        employeesDetails: employeesDetails ?? this.employeesDetails,
        inbox: inbox ?? this.inbox,
        info: info ?? this.info,
        locations: locations ?? this.locations,
        manageDPA: manageDPA ?? this.manageDPA,
        messages: messages ?? this.messages,
        nextBestOffer: nextBestOffer ?? this.nextBestOffer,
        payment: payment ?? this.payment,
        payroll: payroll ?? this.payroll,
        performanceMonitor: performanceMonitor ?? this.performanceMonitor,
        pfmRules: pfmRules ?? this.pfmRules,
        products: products ?? this.products,
        reports: reports ?? this.reports,
        reporting: reporting ?? this.reporting,
        rules: rules ?? this.rules,
        securitySettings: securitySettings ?? this.securitySettings,
        sendMoney: sendMoney ?? this.sendMoney,
        sysadmin: sysadmin ?? this.sysadmin,
        transfer: transfer ?? this.transfer,
      );

  @override
  String toString() => '\n'
      'accountTypes: $accountTypes\n,'
      'acl: $acl\n,'
      'appointmentScheduling: $appointmentScheduling\n,'
      'authorization: $authorization\n,'
      'balancesAndTransactions: $balancesAndTransactions\n,'
      'banks: $banks\n,'
      'beneficiary: $beneficiary\n,'
      'benefitPay: $benefitPay\n,'
      'calendarManagement: $calendarManagement\n,'
      'campaign: $campaign\n,'
      'card: $card\n,'
      'cardTypes: $cardTypes\n,'
      'chatBot: $chatBot\n,'
      'checkbookTypes: $checkbookTypes\n,'
      'countries: $countries\n,'
      'credentialsGeneration: $credentialsGeneration\n,'
      'currencies: $currencies\n,'
      'customers: $customers\n,'
      'developerApp: $developerApp\n,'
      'developers: $developers\n,'
      'electronicStatement: $electronicStatement\n,'
      'employeesDetails: $employeesDetails\n,'
      'inbox: $inbox\n,'
      'info: $info\n,'
      'locations: $locations\n,'
      'manageDPA: $manageDPA\n,'
      'messages: $messages\n,'
      'nextBestOffer: $nextBestOffer\n,'
      'payment: $payment\n,'
      'payroll: $payroll\n,'
      'performanceMonitor: $performanceMonitor\n,'
      'pfmRules: $pfmRules\n,'
      'products: $products\n,'
      'reports: $reports\n,'
      'reporting: $reporting\n,'
      'rules: $rules\n,'
      'securitySettings: $securitySettings\n,'
      'sendMoney: $sendMoney\n,'
      'sysadmin: $sysadmin\n,'
      'transfer: $transfer\n';
}
