import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data_layer/network.dart';
import '../../../domain_layer/use_cases.dart';
import 'mandate_cancel_state.dart';

/// Cubit used for canceling a Mandate
class MandateCancelCubit extends Cubit<MandateCancelState> {
  final CancelMandateUseCase _cancelUseCase;

  /// Creates a new [MandateCancelCubit]
  MandateCancelCubit({required CancelMandateUseCase cancelUseCase})
      : _cancelUseCase = cancelUseCase,
        super(MandateCancelState());

  /// Cancels a Mandate based on its id
  Future<void> cancelMandate({required int mandateId}) async {
    emit(
      state.copyWith(
        busy: true,
        errorMessage: '',
        errorStatus: MandateCancelErrorStatus.none,
      ),
    );

    try {
      /// TODO - check what is the result when canceling a Mandate
      /// Server was throwing a 500 so couldn't get the result from this call
      await _cancelUseCase(mandateId: mandateId);

      emit(
        state.copyWith(
          busy: false,
          errorMessage: '',
          errorStatus: MandateCancelErrorStatus.none,
        ),
      );
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

  /// TODO - implement OTP call
}
