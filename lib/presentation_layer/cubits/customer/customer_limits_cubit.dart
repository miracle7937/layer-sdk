import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data_layer/network.dart';
import '../../../domain_layer/use_cases.dart';
import '../../cubits.dart';

/// A cubit that loads the [CustomerLimit]s of a [Customer].
class CustomerLimitsCubit extends Cubit<CustomerLimitsState> {
  final LoadCustomerLimitsUseCase _loadCustomerLimitsUseCase;

  /// Creates a new [CustomerLimitsCubit] instance.
  CustomerLimitsCubit({
    required LoadCustomerLimitsUseCase loadCustomerLimitsUseCase,
  })  : _loadCustomerLimitsUseCase = loadCustomerLimitsUseCase,
        super(CustomerLimitsState());

  /// Loads the customer limits.
  Future<void> load() async {
    emit(
      state.copyWith(
        error: CustomerLimitsError.none,
        action: CustomerLimitsAction.loadingLimits,
      ),
    );

    try {
      final limit = await _loadCustomerLimitsUseCase();

      emit(
        state.copyWith(
          error: limit == null
              ? CustomerLimitsError.noLimitsSet
              : CustomerLimitsError.none,
          action: CustomerLimitsAction.none,
          limit: limit,
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          error: e is NetException
              ? CustomerLimitsError.network
              : CustomerLimitsError.generic,
          action: CustomerLimitsAction.none,
        ),
      );
    }
  }
}
