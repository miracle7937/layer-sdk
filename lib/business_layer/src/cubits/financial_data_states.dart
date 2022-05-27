import 'package:equatable/equatable.dart';

import '../../../data_layer/data_layer.dart';

/// Enum for all possible errors for [FinancialDataCubit]
enum FinancialDataStateErrors {
  /// No errors
  none,

  /// Generic error
  generic,
}

/// Represents the state of [FinancialDataCubit]
class FinancialDataState extends Equatable {
  /// [Customer] id which will be used by this cubit
  final String customerId;

  /// Financial Data received
  final FinancialData financialData;

  /// True if the cubit is processing something
  final bool busy;

  /// Error message for the last occurred error
  final FinancialDataStateErrors error;

  /// Creates a new instance of [FinancialDataState]
  FinancialDataState({
    required this.customerId,
    FinancialData? financialData,
    this.busy = false,
    this.error = FinancialDataStateErrors.none,
  }) : financialData = financialData ?? FinancialData();

  @override
  List<Object?> get props => [
        customerId,
        financialData,
        busy,
        error,
      ];

  /// Creates a new [FinancialDataState] based on the current one.
  FinancialDataState copyWith({
    String? customerId,
    FinancialData? financialData,
    bool? busy,
    FinancialDataStateErrors? error,
  }) =>
      FinancialDataState(
        customerId: customerId ?? this.customerId,
        financialData: financialData ?? this.financialData,
        busy: busy ?? this.busy,
        error: error ?? this.error,
      );
}
