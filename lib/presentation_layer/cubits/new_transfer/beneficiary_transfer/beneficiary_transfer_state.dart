import 'dart:collection';

import '../../../../domain_layer/models.dart';
import '../../../cubits.dart';
import '../../../utils.dart';

/// The available busy actions that the cubit can perform.
enum BeneficiaryTransferAction {
  /// Loading the beneficiary settings.
  beneficiarySettings,

  /// Loading the currencies.
  currencies,

  /// Loading the countries.
  countries,

  /// Loading the accounts.
  accounts,

  /// Loading the beneficiaries.
  beneficiaries,

  /// Loading the reasons.
  reasons,

  /// Loading the banks for the new beneficiary.
  banks,

  /// Transfer being evaluated.
  evaluate,

  /// Transfer is being submitted.
  submit,

  /// The second factor is being verified.
  verifySecondFactor,

  /// The second factor is being resent.
  resendSecondFactor,

  /// The shortcut is being created.
  shortcut,
}

/// The available events that the cubit can emit.
enum BeneficiaryTransferEvent {
  /// Event for showing the confirmation view.
  showConfirmationView,

  /// Event for inputing the OTP code.
  inputOTPCode,

  /// Event for showing the transfer result view.
  showResultView,
}

/// The available validation errors.
enum BeneficiaryTransferValidationError {
  /// Invalid IBAN.
  invalidIBAN,
}

/// The state for the [BeneficiaryTransferCubit].
class BeneficiaryTransferState extends BaseState<BeneficiaryTransferAction,
    BeneficiaryTransferEvent, BeneficiaryTransferValidationError> {
  /// The transfer object.
  final BeneficiaryTransfer transfer;

  /// The beneficiary settings.
  final UnmodifiableListView<GlobalSetting> beneficiarySettings;

  /// All the countries.
  final UnmodifiableListView<Country> countries;

  /// All the currencies.
  final UnmodifiableListView<Currency> currencies;

  /// List of source [Account]s.
  final UnmodifiableListView<Account> accounts;

  /// List of destination [Beneficiary].
  final UnmodifiableListView<Beneficiary> beneficiaries;

  /// List of reasons.
  final UnmodifiableListView<Message> reasons;

  /// List of banks for the new beneficiary.
  final UnmodifiableListView<Bank> banks;

  /// Has all the data needed to handle the list of activities.
  final Pagination banksPagination;

  /// The transfer evaluation.
  final TransferEvaluation? evaluation;

  /// The transfer object returned by the transfer submission.
  final Transfer? transferResult;

  /// The bank query for filtering the banks.
  final String? bankQuery;

  /// If is edit mode or not
  ///
  /// Defaults to `false`
  final bool editMode;

  /// Creates a new [BeneficiaryTransferState].
  BeneficiaryTransferState({
    required this.transfer,
    super.actions = const <BeneficiaryTransferAction>{},
    super.errors = const <CubitError>{},
    super.events = const <BeneficiaryTransferEvent>{},
    Iterable<GlobalSetting> beneficiarySettings = const <GlobalSetting>{},
    Iterable<Country> countries = const <Country>{},
    Iterable<Currency> currencies = const <Currency>{},
    Iterable<Account> accounts = const <Account>[],
    Iterable<Beneficiary> beneficiaries = const <Beneficiary>[],
    Iterable<Message> reasons = const <Message>[],
    Iterable<Bank> banks = const <Bank>[],
    this.banksPagination = const Pagination(),
    this.evaluation,
    this.transferResult,
    this.bankQuery,
    required this.editMode,
  })  : beneficiarySettings = UnmodifiableListView(beneficiarySettings),
        countries = UnmodifiableListView(countries),
        currencies = UnmodifiableListView(currencies),
        accounts = UnmodifiableListView(accounts),
        beneficiaries = UnmodifiableListView(beneficiaries),
        reasons = UnmodifiableListView(reasons),
        banks = UnmodifiableListView(banks);

  /// Whether if the cubit is loading something.
  bool get busy => super.actions.isNotEmpty;

  /// Whether if the cubit is initializing.
  bool get initializing => super
      .actions
      .where(
        (action) => [
          BeneficiaryTransferAction.beneficiarySettings,
          BeneficiaryTransferAction.accounts,
          BeneficiaryTransferAction.beneficiaries,
          BeneficiaryTransferAction.currencies,
          BeneficiaryTransferAction.countries,
          BeneficiaryTransferAction.reasons,
        ].contains(action),
      )
      .isNotEmpty;

  @override
  BeneficiaryTransferState copyWith({
    BeneficiaryTransfer? transfer,
    Set<BeneficiaryTransferAction>? actions,
    Set<CubitError>? errors,
    Set<BeneficiaryTransferEvent>? events,
    Iterable<GlobalSetting>? beneficiarySettings,
    Iterable<Country>? countries,
    Iterable<Currency>? currencies,
    Iterable<Account>? accounts,
    Iterable<Beneficiary>? beneficiaries,
    Iterable<Message>? reasons,
    Iterable<Bank>? banks,
    Pagination? banksPagination,
    TransferEvaluation? evaluation,
    Transfer? transferResult,
    String? bankQuery,
    bool? editMode,
  }) =>
      BeneficiaryTransferState(
        transfer: transfer ?? this.transfer,
        actions: actions ?? super.actions,
        errors: errors ?? super.errors,
        events: events ?? super.events,
        beneficiarySettings: beneficiarySettings ?? this.beneficiarySettings,
        countries: countries ?? this.countries,
        currencies: currencies ?? this.currencies,
        accounts: accounts ?? this.accounts,
        beneficiaries: beneficiaries ?? this.beneficiaries,
        reasons: reasons ?? this.reasons,
        banks: banks ?? this.banks,
        banksPagination: banksPagination ?? this.banksPagination,
        evaluation: evaluation ?? this.evaluation,
        transferResult: transferResult ?? this.transferResult,
        bankQuery: bankQuery ?? this.bankQuery,
        editMode: editMode ?? this.editMode,
      );

  @override
  List<Object?> get props => [
        transfer,
        busy,
        errors,
        events,
        beneficiarySettings,
        countries,
        currencies,
        accounts,
        beneficiaries,
        reasons,
        banks,
        banksPagination,
        evaluation,
        transferResult,
        bankQuery,
        editMode,
      ];
}
