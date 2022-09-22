import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data_layer/network.dart';
import '../../../domain_layer/models/second_factor/second_factor_type.dart';
import '../../../domain_layer/use_cases.dart';
import 'mandate_cancel_state.dart';

/// Cubit used for canceling a Mandate
class MandateCancelCubit extends Cubit<MandateCancelState> {
  final CancelMandateUseCase _cancelUseCase;

  /// Creates a new [MandateCancelCubit]
  MandateCancelCubit({
    required CancelMandateUseCase cancelUseCase,
  })  : _cancelUseCase = cancelUseCase,
        super(MandateCancelState());

  /// Cancels a Mandate based on its id
  Future<SecondFactorType?> cancelMandate({
    required int mandateId,
    String? otpValue,
    SecondFactorType? type,
  }) async {
    emit(
      state.copyWith(
        busy: true,
        errorStatus: MandateCancelErrorStatus.none,
      ),
    );

    try {
      final result = await _cancelUseCase(
        mandateId: mandateId,
        otpValue: otpValue,
        otpType: type,
      );

      emit(
        state.copyWith(
          busy: false,
        ),
      );

      /// TODO: cubit_issue | This should be handled by the state.
      return result;
    } on Exception catch (e) {
      emit(
        state.copyWith(
          busy: false,
          errorStatus: e is NetException
              ? MandateCancelErrorStatus.network
              : MandateCancelErrorStatus.generic,
          errorMessage: e is NetException ? e.message : e.toString(),
        ),
      );
      rethrow;
    }
  }
}
