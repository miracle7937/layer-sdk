import 'package:bloc/bloc.dart';

import '../../../domain_layer/models/customer/customer.dart';
import '../../../domain_layer/models/limits/limits.dart';
import '../../../domain_layer/use_cases.dart';
import 'limits_state.dart';

/// A cubit that keeps a limits.
class LimitsCubit extends Cubit<LimitsState> {
  final LoadLimitsUseCase _loadlimitsUseCase;
  final SaveLimitsUseCase _savelimitsUseCase;

  /// Creates [LimitsCubit].
  LimitsCubit({
    required LoadLimitsUseCase useCase,
    required SaveLimitsUseCase savelimitsUseCase,
    String? customerId,
    String? agentId,
    required CustomerType customerType,
  })  : _loadlimitsUseCase = useCase,
        _savelimitsUseCase = savelimitsUseCase,
        super(
          LimitsState(
            customerId: customerId,
            agentId: agentId,
            customerType: customerType,
          ),
        );

  /// Gets limits.
  Future<void> load({bool forceRefresh = false}) async {
    emit(
      state.copyWith(
        busyAction: LimitsBusyAction.load,
        error: LimitsStateError.none,
      ),
    );

    try {
      final limits = await _loadlimitsUseCase.call(
        customerId: state.customerId,
        agentId: state.agentId,
        forceRefresh: forceRefresh,
      );
      emit(state.copyWith(
        limits: limits,
        busyAction: LimitsBusyAction.none,
      ));
    } on Exception catch (_) {
      emit(
        state.copyWith(
          busyAction: LimitsBusyAction.none,
          error: LimitsStateError.generic,
        ),
      );
    }
  }

  /// Saves provided [limits] information.
  /// If [Customer] with [customerId] or [Agent] with [agentId]
  /// already [hadLimits].
  Future<void> save({
    bool forceRefresh = false,
    required CustomerType customerType,
    required Limits limits,
  }) async {
    emit(
      state.copyWith(
        busyAction: LimitsBusyAction.save,
        error: LimitsStateError.none,
      ),
    );
    try {
      await _savelimitsUseCase.call(
        customerId: state.customerId,
        agentId: state.agentId,
        limits: limits,
        customerType: customerType,
      );
      emit(state.copyWith(
        busyAction: LimitsBusyAction.none,
        limits: limits,
      ));
    } on Exception catch (_) {
      emit(
        state.copyWith(
          busyAction: LimitsBusyAction.none,
          error: LimitsStateError.generic,
        ),
      );
    }
  }
}
