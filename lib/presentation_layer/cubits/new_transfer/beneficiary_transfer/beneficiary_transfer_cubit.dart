import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../domain_layer/models.dart';
import '../../../../domain_layer/use_cases.dart';
import '../../../cubits.dart';

/// A Cubit that handles the state for the beneficiary transfer flow.
class BeneficiaryTransferCubit extends Cubit<BeneficiaryTransferState> {
  final GetSourceAccountsForBeneficiaryTransferUseCase
      _getSourceAccountsForBeneficiaryTransferUseCase;
  final GetDestinationBeneficiariesForBeneficiariesTransferUseCase
      _getDestinationBeneficiariesForBeneficiariesTransferUseCase;
  final LoadAllCurrenciesUseCase _loadAllCurrenciesUseCase;
  final LoadMessagesByModuleUseCase _loadMessagesByModuleUseCase;
  final EvaluateTransferUseCase _evaluateTransferUseCase;
  final _submitTransferUseCase;

  /// Creates a new [BeneficiaryTransferCubit].
  BeneficiaryTransferCubit({
    required BeneficiaryTransfer transfer,
    required GetSourceAccountsForBeneficiaryTransferUseCase
        getSourceAccountsForBeneficiaryTransferUseCase,
    required GetDestinationBeneficiariesForBeneficiariesTransferUseCase
        getDestinationBeneficiariesForBeneficiariesTransferUseCase,
    required LoadAllCurrenciesUseCase loadAllCurrenciesUseCase,
    required LoadMessagesByModuleUseCase loadMessagesByModuleUseCase,
    required EvaluateTransferUseCase evaluateTransferUseCase,
    required SubmitTransferUseCase submitTransferUseCase,
  })  : _getSourceAccountsForBeneficiaryTransferUseCase =
            getSourceAccountsForBeneficiaryTransferUseCase,
        _getDestinationBeneficiariesForBeneficiariesTransferUseCase =
            getDestinationBeneficiariesForBeneficiariesTransferUseCase,
        _loadAllCurrenciesUseCase = loadAllCurrenciesUseCase,
        _loadMessagesByModuleUseCase = loadMessagesByModuleUseCase,
        _evaluateTransferUseCase = evaluateTransferUseCase,
        _submitTransferUseCase = submitTransferUseCase,
        super(
          BeneficiaryTransferState(
            transfer: transfer,
          ),
        );

  /// Initializes the [BeneficiaryTransferCubit].
  Future<void> initialize() => Future.wait([
        _loadCurrencies(),
        _loadAccounts(),
        _loadBeneficiaries(),
        _loadReasons(),
      ]);

  /// Loads all the currencies.
  Future<void> _loadCurrencies() async {
    if (state.currencies.isEmpty ||
        state.errors.contains(BeneficiaryTransferAction.currencies)) {
      emit(
        state.copyWith(
          actions: state.actions.union(
            {BeneficiaryTransferAction.currencies},
          ),
          errors: state.errors.difference(
            {BeneficiaryTransferAction.currencies},
          ),
        ),
      );

      try {
        final currencies = await _loadAllCurrenciesUseCase();

        emit(
          state.copyWith(
            actions: state.actions.difference(
              {BeneficiaryTransferAction.currencies},
            ),
            currencies: currencies,
          ),
        );
      } on Exception {
        emit(
          state.copyWith(
            actions: state.actions.difference(
              {BeneficiaryTransferAction.currencies},
            ),
            errors: state.errors.union(
              {BeneficiaryTransferAction.currencies},
            ),
          ),
        );
      }
    }
  }

  /// Loads the accounts.
  Future<void> _loadAccounts() async {
    if (state.accounts.isEmpty ||
        state.errors.contains(BeneficiaryTransferAction.accounts)) {
      emit(
        state.copyWith(
          actions: state.actions.union(
            {BeneficiaryTransferAction.accounts},
          ),
          errors: state.errors.difference(
            {BeneficiaryTransferAction.accounts},
          ),
        ),
      );

      try {
        final accounts =
            await _getSourceAccountsForBeneficiaryTransferUseCase();

        if (accounts.isNotEmpty) {
          onChanged(
            source: accounts
                .sortedBy<num>((element) => element.availableBalance ?? 0.0)
                .reversed
                .first,
          );
        }

        emit(
          state.copyWith(
            actions: state.actions.difference(
              {BeneficiaryTransferAction.accounts},
            ),
            accounts: accounts,
          ),
        );
      } on Exception {
        emit(
          state.copyWith(
            actions: state.actions.difference(
              {BeneficiaryTransferAction.accounts},
            ),
            errors: state.errors.union(
              {BeneficiaryTransferAction.accounts},
            ),
          ),
        );
      }
    }
  }

  /// Loads the beneficiaries.
  Future<void> _loadBeneficiaries() async {
    if (state.beneficiaries.isEmpty ||
        state.errors.contains(BeneficiaryTransferAction.beneficiaries)) {
      emit(
        state.copyWith(
          actions: state.actions.union(
            {BeneficiaryTransferAction.beneficiaries},
          ),
          errors: state.errors.difference(
            {BeneficiaryTransferAction.beneficiaries},
          ),
        ),
      );

      try {
        final beneficiaries =
            await _getDestinationBeneficiariesForBeneficiariesTransferUseCase();

        emit(
          state.copyWith(
            actions: state.actions.difference(
              {BeneficiaryTransferAction.beneficiaries},
            ),
            beneficiaries: beneficiaries,
          ),
        );
      } on Exception {
        emit(
          state.copyWith(
            actions: state.actions.difference(
              {BeneficiaryTransferAction.beneficiaries},
            ),
            errors: state.errors.union(
              {BeneficiaryTransferAction.beneficiaries},
            ),
          ),
        );
      }
    }
  }

  /// Loads the reasons.
  Future<void> _loadReasons() async {
    if (state.reasons.isEmpty ||
        state.errors.contains(BeneficiaryTransferAction.reasons)) {
      emit(
        state.copyWith(
          actions: state.actions.union(
            {BeneficiaryTransferAction.reasons},
          ),
          errors: state.errors.difference(
            {BeneficiaryTransferAction.reasons},
          ),
        ),
      );

      try {
        final reasons = await _loadMessagesByModuleUseCase(
          module: state.transfer.type == TransferType.international
              ? 'transfer_reasons_international'
              : 'transfer_reasons',
        );

        emit(
          state.copyWith(
            actions: state.actions.difference(
              {BeneficiaryTransferAction.reasons},
            ),
            reasons: reasons,
          ),
        );
      } on Exception {
        emit(
          state.copyWith(
            actions: state.actions.difference(
              {BeneficiaryTransferAction.reasons},
            ),
            errors: state.errors.union(
              {BeneficiaryTransferAction.reasons},
            ),
          ),
        );
      }
    }
  }

  /// Updates the transfer object.
  Future<void> onChanged({
    TransferType? type,
    Account? source,
    Beneficiary? destination,
    double? amount,
    Currency? currency,
    Message? reason,
  }) async {
    _updateAvailableCurrencies();

    emit(
      state.copyWith(
        transfer: state.transfer.copyWith(
          type: type,
          source: source == null ? null : NewTransferSource(account: source),
          destination: destination == null
              ? null
              : NewTransferDestination(beneficiary: destination),
          amount: amount,
          currency: currency,
          reason: reason,
        ),
      ),
    );
  }

  /// Updates the available currencies.
  Future<void> _updateAvailableCurrencies() async {
    final sourceCurrency = state.currencies.firstWhereOrNull(
      (currency) => currency.code == state.transfer.source?.account?.currency,
    );

    final destinationCurrency = state.currencies.firstWhereOrNull(
      (currency) =>
          currency.code == state.transfer.destination?.beneficiary?.currency,
    );

    emit(
      state.copyWith(
        availableCurrencies: {
          if (sourceCurrency != null) sourceCurrency,
          if (destinationCurrency != null) destinationCurrency,
        },
      ),
    );
  }

  /// Evaluates the transfer.
  Future<void> evaluate({
    required NewTransfer transfer,
  }) async {
    emit(
      state.copyWith(
        actions: state.actions.union(
          {BeneficiaryTransferAction.evaluate},
        ),
        errors: state.errors.difference(
          {BeneficiaryTransferAction.evaluate},
        ),
      ),
    );

    try {
      final evaluation = await _evaluateTransferUseCase(
        transfer: state.transfer,
      );

      emit(
        state.copyWith(
          actions: state.actions.difference(
            {BeneficiaryTransferAction.evaluate},
          ),
          evaluation: evaluation,
        ),
      );
    } on Exception {
      emit(
        state.copyWith(
          actions: state.actions.difference(
            {BeneficiaryTransferAction.evaluate},
          ),
          errors: state.errors.union(
            {BeneficiaryTransferAction.evaluate},
          ),
        ),
      );
    }
  }

  /// Submits the transfer.
  Future<void> submit({
    required NewTransfer transfer,
  }) async {
    emit(
      state.copyWith(
        actions: state.actions.union(
          {BeneficiaryTransferAction.submit},
        ),
        errors: state.errors.difference(
          {BeneficiaryTransferAction.submit},
        ),
      ),
    );

    try {
      final transferResult = await _submitTransferUseCase(
        transfer: state.transfer,
      );

      emit(
        state.copyWith(
          actions: state.actions.difference(
            {BeneficiaryTransferAction.submit},
          ),
          transferResult: transferResult,
        ),
      );
    } on Exception {
      emit(
        state.copyWith(
          actions: state.actions.difference(
            {BeneficiaryTransferAction.submit},
          ),
          errors: state.errors.union(
            {BeneficiaryTransferAction.submit},
          ),
        ),
      );
    }
  }
}
