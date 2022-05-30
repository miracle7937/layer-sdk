import 'package:bloc/bloc.dart';
import '../../../../data_layer/data_layer.dart';

import '../../cubits.dart';

/// Cubit responsible for 2FA
class SecondFactorCubit extends Cubit<SecondFactorState> {
  final SecondFactorRepository _repository;

  /// Creates a new [SecondFactorCubit] instance.
  SecondFactorCubit({
    required SecondFactorRepository repository,
    required int deviceId,
  })  : _repository = repository,
        super(SecondFactorState(deviceId: deviceId));

  /// Verifies the OTP value for the current 2fa ID.
  Future<void> verifyOTP({
    required String value,
  }) async {
    assert(state.otpId != null);

    emit(
      state.copyWith(
        busy: true,
        error: SecondFactorErrors.none,
      ),
    );

    try {
      final result = await _repository.verifyConsoleUserOTP(
        deviceId: state.deviceId,
        otpId: state.otpId!,
        value: value,
      );

      emit(
        state.copyWith(
          busy: false,
          error: !result ? SecondFactorErrors.wrongOTP : null,
          validated: result,
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          busy: false,
          error: e is NetException
              ? SecondFactorErrors.network
              : SecondFactorErrors.generic,
        ),
      );

      rethrow;
    }
  }

  /// Requests a new OTP id from the server.
  Future<void> requestOTP() async {
    emit(
      state.copyWith(
        busyResendingOTP: true,
        error: SecondFactorErrors.none,
      ),
    );

    try {
      final otpId = await _repository.verifyConsoleUserDeviceLogin(
        deviceId: state.deviceId,
      );

      if (otpId == null) {
        emit(
          state.copyWith(
            busyResendingOTP: false,
            error: SecondFactorErrors.resendOTPFailed,
          ),
        );
        return;
      }

      emit(
        state.copyWith(
          busyResendingOTP: false,
          otpId: otpId,
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          busyResendingOTP: false,
          error: e is NetException
              ? SecondFactorErrors.network
              : SecondFactorErrors.generic,
        ),
      );

      rethrow;
    }
  }
}
