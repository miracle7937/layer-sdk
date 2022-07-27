import 'dart:collection';

import 'package:equatable/equatable.dart';
import '../../../../domain_layer/models.dart';

/// Model used for the errors.
class BeneficiaryTransferError extends Equatable {
  /// The action.
  final BeneficiaryTransferAction action;

  /// The error.
  final BeneficiaryTransferErrorStatus errorStatus;

  /// Creates a new [BeneficiaryTransferError].
  const BeneficiaryTransferError({
    required this.action,
    required this.errorStatus,
  });

  @override
  List<Object?> get props => [
        action,
        errorStatus,
      ];
}

/// The available actions for the cubit.
enum BeneficiaryTransferAction {
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
}

/// The available error status.
enum BeneficiaryTransferErrorStatus {
  /// Generic.
  generic,

  /// Network.
  network,

  /// Insuficient balance.
  insufficientBalance,
}

/// The state for the [BeneficiaryTransferCubit].
class BeneficiaryTransferState extends Equatable {
  /// The transfer object.
  final BeneficiaryTransfer transfer;

  /// The actions that the cubit is performing.
  final UnmodifiableSetView<BeneficiaryTransferAction> actions;

  /// The errors.
  final UnmodifiableSetView<BeneficiaryTransferError> errors;

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

  /// The transfer evaluation.
  final TransferEvaluation? evaluation;

  /// The transfer object returned by the transfer submission.
  final Transfer? transferResult;

  /// Creates a new [BeneficiaryTransferState].
  BeneficiaryTransferState({
    required this.transfer,
    Set<BeneficiaryTransferAction> actions =
        const <BeneficiaryTransferAction>{},
    Set<BeneficiaryTransferError> errors = const <BeneficiaryTransferError>{},
    Iterable<Country> countries = const <Country>{},
    Iterable<Currency> currencies = const <Currency>{},
    Iterable<Account> accounts = const <Account>[],
    Iterable<Beneficiary> beneficiaries = const <Beneficiary>[],
    Iterable<Message> reasons = const <Message>[],
    Iterable<Bank> banks = const <Bank>[],
    this.evaluation,
    this.transferResult,
  })  : actions = UnmodifiableSetView(actions),
        errors = UnmodifiableSetView(errors),
        countries = UnmodifiableListView(countries),
        currencies = UnmodifiableListView(currencies),
        accounts = UnmodifiableListView(accounts),
        beneficiaries = UnmodifiableListView(beneficiaries),
        reasons = UnmodifiableListView(reasons),
        banks = UnmodifiableListView(banks);

  /// Whether if the cubit is loading something.
  bool get busy => actions.isNotEmpty;

  /// Whether if the cubit is initializing.
  bool get initializing => actions
      .where(
        (action) => [
          BeneficiaryTransferAction.accounts,
          BeneficiaryTransferAction.beneficiaries,
          BeneficiaryTransferAction.currencies,
          BeneficiaryTransferAction.countries,
          BeneficiaryTransferAction.reasons,
        ].contains(action),
      )
      .isNotEmpty;

  /// Creates a copy of the current state with the passed values.
  BeneficiaryTransferState copyWith({
    BeneficiaryTransfer? transfer,
    Set<BeneficiaryTransferAction>? actions,
    Set<BeneficiaryTransferError>? errors,
    Iterable<Country>? countries,
    Iterable<Currency>? currencies,
    Iterable<Account>? accounts,
    Iterable<Beneficiary>? beneficiaries,
    Iterable<Message>? reasons,
    Iterable<Bank>? banks,
    TransferEvaluation? evaluation,
    Transfer? transferResult,
  }) =>
      BeneficiaryTransferState(
        transfer: transfer ?? this.transfer,
        actions: actions ?? this.actions,
        errors: errors ?? this.errors,
        countries: countries ?? this.countries,
        currencies: currencies ?? this.currencies,
        accounts: accounts ?? this.accounts,
        beneficiaries: beneficiaries ?? this.beneficiaries,
        reasons: reasons ?? this.reasons,
        banks: banks ?? this.banks,
        evaluation: evaluation ?? this.evaluation,
        transferResult: transferResult ?? this.transferResult,
      );

  @override
  List<Object?> get props => [
        transfer,
        actions,
        errors,
        countries,
        currencies,
        accounts,
        beneficiaries,
        reasons,
        banks,
        evaluation,
        transferResult,
      ];
}
