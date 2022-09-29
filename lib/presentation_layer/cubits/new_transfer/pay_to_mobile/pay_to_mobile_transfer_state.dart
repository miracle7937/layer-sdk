import 'dart:collection';

import '../../../../domain_layer/models.dart';
import '../../../cubits.dart';

/// The available actions.
enum PayToMobileTransferAction {
  /// Loading the accounts.
  accounts,

  /// Loading the currencies.
  currencies,

  /// Loading the countries.
  countries,
}

/// The available events.
enum PayToMobileTransferEvent {
  /// Event for showing the confirmation view.
  showConfirmationView,
}

/// The available validation error codes.
enum PayToMobileTransferValidationErrorCode {
  /// Source account validation error.
  sourceAccountValidationError,

  /// New beneficiary amount validation error.
  amountValidationError,

  /// Shortcut name validation error.
  shortcutNameValidationError,

  /// Insufficient balance validation error.
  insufficientBalanceValidationError,
}

/// The state for the [PayToMobileTransferCubit].
class PayToMobileState extends BaseState<PayToMobileTransferAction,
    PayToMobileTransferEvent, PayToMobileTransferValidationErrorCode> {
  /// The new pay to mobile transfer object.
  final NewPayToMobileTransfer transfer;

  /// All the currencies.
  final UnmodifiableListView<Currency> currencies;

  /// All the countries.
  final UnmodifiableListView<Country> countries;

  /// List of source [Account]s.
  final UnmodifiableListView<Account> accounts;

  /// Creates a new [BeneficiaryTransferState].
  PayToMobileState({
    required this.transfer,
    super.actions = const <PayToMobileTransferAction>{},
    super.errors = const <CubitError>{},
    super.events = const <PayToMobileTransferEvent>{},
    Iterable<Account> accounts = const <Account>[],
    Iterable<Currency> currencies = const <Currency>[],
    Iterable<Country> countries = const <Country>[],
  })  : accounts = UnmodifiableListView(accounts),
        currencies = UnmodifiableListView(currencies),
        countries = UnmodifiableListView(countries);

  @override
  PayToMobileState copyWith({
    NewPayToMobileTransfer? transfer,
    Set<PayToMobileTransferAction>? actions,
    Set<CubitError>? errors,
    Set<PayToMobileTransferEvent>? events,
    Iterable<Account>? accounts,
    Iterable<Currency>? currencies,
    Iterable<Country>? countries,
  }) =>
      PayToMobileState(
        transfer: transfer ?? this.transfer,
        actions: actions ?? super.actions,
        errors: errors ?? super.errors,
        events: events ?? super.events,
        accounts: accounts ?? this.accounts,
        currencies: currencies ?? this.currencies,
        countries: countries ?? this.countries,
      );

  @override
  List<Object?> get props => [
        transfer,
        errors,
        actions,
        events,
        accounts,
        currencies,
        countries,
      ];
}
