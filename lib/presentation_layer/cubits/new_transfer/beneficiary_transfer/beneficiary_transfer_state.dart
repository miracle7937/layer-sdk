import 'dart:collection';

import 'package:equatable/equatable.dart';

import '../../../../domain_layer/models.dart';

/// The available actions for the cubit.
enum BeneficiaryTransferAction {
  /// Loading the currencies.
  currencies,

  /// Loading the accounts.
  accounts,

  /// Loading the beneficiaries.
  beneficiaries,

  /// Loading the reasons.
  reasons,

  /// Transfer being evaluated.
  evaluate,

  /// Transfer is being submitted.
  submit,
}

/// The state for the [BeneficiaryTransferCubit].
class BeneficiaryTransferState extends Equatable {
  /// The transfer object.
  final BeneficiaryTransfer transfer;

  /// The actions that the cubit is performing.
  final UnmodifiableSetView<BeneficiaryTransferAction> actions;

  /// The actions that encountered errors.
  final UnmodifiableSetView<BeneficiaryTransferAction> errors;

  /// All the currencies.
  final UnmodifiableListView<Currency> currencies;

  /// List of the available currencies.
  final UnmodifiableSetView<Currency> availableCurrencies;

  /// List of source [Account]s.
  final UnmodifiableListView<Account> accounts;

  /// List of destination [Beneficiary].
  final UnmodifiableListView<Beneficiary> beneficiaries;

  /// List of reasons.
  final UnmodifiableListView<Message> reasons;

  /// The transfer evaluation.
  final TransferEvaluation? evaluation;

  /// The transfer object returned by the transfer submission.
  final Transfer? transferResult;

  /// Creates a new [BeneficiaryTransferState].
  BeneficiaryTransferState({
    required this.transfer,
    Set<BeneficiaryTransferAction> actions =
        const <BeneficiaryTransferAction>{},
    Set<BeneficiaryTransferAction> errors = const <BeneficiaryTransferAction>{},
    Iterable<Currency> currencies = const <Currency>{},
    Set<Currency> availableCurrencies = const <Currency>{},
    Iterable<Account> accounts = const <Account>[],
    Iterable<Beneficiary> beneficiaries = const <Beneficiary>[],
    Iterable<Message> reasons = const <Message>[],
    this.evaluation,
    this.transferResult,
  })  : actions = UnmodifiableSetView(actions),
        errors = UnmodifiableSetView(errors),
        currencies = UnmodifiableListView(currencies),
        availableCurrencies = UnmodifiableSetView(availableCurrencies),
        accounts = UnmodifiableListView(accounts),
        beneficiaries = UnmodifiableListView(beneficiaries),
        reasons = UnmodifiableListView(reasons);

  /// Whether if the cubit is loading something.
  bool get busy => actions.isNotEmpty;

  /// Creates a copy of the current state with the passed values.
  BeneficiaryTransferState copyWith({
    BeneficiaryTransfer? transfer,
    Set<BeneficiaryTransferAction>? actions,
    Set<BeneficiaryTransferAction>? errors,
    Iterable<Currency>? currencies,
    Set<Currency>? availableCurrencies,
    Iterable<Account>? accounts,
    Iterable<Beneficiary>? beneficiaries,
    Iterable<Message>? reasons,
    TransferEvaluation? evaluation,
    Transfer? transferResult,
  }) =>
      BeneficiaryTransferState(
        transfer: transfer ?? this.transfer,
        actions: actions ?? this.actions,
        errors: errors ?? this.errors,
        currencies: currencies ?? this.currencies,
        availableCurrencies: availableCurrencies ?? this.availableCurrencies,
        accounts: accounts ?? this.accounts,
        beneficiaries: beneficiaries ?? this.beneficiaries,
        reasons: reasons ?? this.reasons,
        evaluation: evaluation ?? this.evaluation,
        transferResult: transferResult ?? this.transferResult,
      );

  @override
  List<Object?> get props => [
        transfer,
        actions,
        errors,
        currencies,
        availableCurrencies,
        accounts,
        beneficiaries,
        reasons,
        evaluation,
        transferResult,
      ];
}
