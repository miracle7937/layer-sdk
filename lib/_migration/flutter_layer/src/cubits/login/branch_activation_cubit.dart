import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../data_layer/network.dart';
import '../../../../data_layer/data_layer.dart';
import '../../../flutter_layer.dart';
import 'activation_code_utils.dart';
import 'branch_activation_state.dart';

/// A cubit that handles requesting device permissions.
class BranchActivationCubit extends Cubit<BranchActivationState> {
  final AuthenticationRepository _authenticationRepository;
  final UserRepository _userRepository;
  final OTPRepository _otpRepository;
  final int _activationCodeLength;

  /// Whether if the otp second factor is needed or not.
  final bool useOTP;

  /// The delay in milliseconds for the polling of the activation code.
  /// Default is 3000 milliseconds.
  final int delay;

  /// Flag that indicates if the polling loop should be broken.
  bool _shouldPoll = false;

  /// Flag that indicates if the polling loop is already running.
  bool _isPolling = false;

  /// Creates a new [BranchActivationCubit].
  BranchActivationCubit({
    required AuthenticationRepository authenticationRepository,
    required UserRepository userRepository,
    required OTPRepository otpRepository,
    int activationCodeLength = 6,
    this.useOTP = true,
    this.delay = 3000,

    /// This parameter should only be used for testing purposses
    String? testActivationCode,
  })  : _authenticationRepository = authenticationRepository,
        _userRepository = userRepository,
        _otpRepository = otpRepository,
        _activationCodeLength = activationCodeLength,
        super(
          BranchActivationState(
            activationCode: testActivationCode ??
                ActivationCodeUtils()
                    .generateActivationCode(activationCodeLength),
          ),
        );

  /// Periodically checks if the activation code was submitted by the branch.
  Future<void> checkBranchActivationCode({
    bool resetCode = false,
  }) async {
    if (_isPolling) {
      return;
    }

    _isPolling = true;
    _shouldPoll = true;

    if (resetCode) {
      emit(
        state.copyWith(
          activationCode: ActivationCodeUtils()
              .generateActivationCode(_activationCodeLength),
        ),
      );
    }

    emit(
      state.copyWith(
        error: BranchActivationError.none,
        action: BranchActivationAction.activationCode,
      ),
    );

    while (_shouldPoll) {
      try {
        final activationResponse =
            await _authenticationRepository.checkBranchActivationCode(
          code: state.activationCode,
          useOtp: useOTP,
        );

        if (activationResponse != null) {
          final secondFactorNeeded =
              activationResponse.secondFactorVerification != null;

          emit(
            state.copyWith(
              activationResponse: activationResponse,
            ),
          );

          if (!secondFactorNeeded) {
            getUserDetails();
          }

          _shouldPoll = false;
        }
      } on Exception catch (e) {
        var shouldThrow = true;
        if (e is NetException) {
          shouldThrow = e.statusCode != 404;
        }

        if (shouldThrow) {
          emit(
            state.copyWith(
              error: e is NetException
                  ? BranchActivationError.network
                  : BranchActivationError.generic,
              errorMessage: e is NetException ? e.message : null,
            ),
          );

          _shouldPoll = false;
        }
      }

      if (!_shouldPoll) {
        _isPolling = false;
      } else {
        await Future.delayed(Duration(milliseconds: delay));
      }
    }
  }

  /// Verifies the otp for the current branch activation request.
  Future<void> verifyOTP(
    String otpValue,
  ) async {
    emit(
      state.copyWith(
        error: BranchActivationError.none,
        action: BranchActivationAction.otpCheck,
      ),
    );

    try {
      final activationResponse =
          await _authenticationRepository.checkBranchActivationCode(
        code: state.activationCode,
        otpValue: otpValue,
        useOtp: useOTP,
      );

      if (activationResponse != null) {
        emit(
          state.copyWith(
            activationResponse: activationResponse,
          ),
        );

        getUserDetails();
      }
    } on Exception catch (e) {
      emit(
        state.copyWith(
          error: e is NetException
              ? BranchActivationError.network
              : BranchActivationError.generic,
          errorMessage: e is NetException ? e.message : null,
        ),
      );
    }
  }

  /// Resends the OTP code.
  Future<void> resendOTP() async {
    emit(
      state.copyWith(
        busy: true,
        error: BranchActivationError.none,
        action: BranchActivationAction.otpCheck,
      ),
    );

    try {
      if (state.activationResponse?.secondFactorVerification?.id == null) {
        emit(
          state.copyWith(
            busy: false,
            error: BranchActivationError.generic,
          ),
        );

        return;
      }

      await _otpRepository.resendCustomerOTP(
        otpId: state.activationResponse!.secondFactorVerification!.id!,
      );

      emit(
        state.copyWith(
          busy: false,
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          busy: false,
          error: e is NetException
              ? BranchActivationError.network
              : BranchActivationError.generic,
          errorMessage: e is NetException ? e.message : null,
        ),
      );
    }
  }

  /// Gets the user details using the registration response token.
  Future<void> getUserDetails() async {
    emit(
      state.copyWith(
        busy: true,
        error: BranchActivationError.none,
        action: BranchActivationAction.userRetrieval,
      ),
    );

    try {
      if (state.activationResponse?.token == null) {
        emit(
          state.copyWith(
            busy: false,
            error: BranchActivationError.generic,
          ),
        );

        return;
      }

      final user = await _userRepository.getUserFromToken(
        token: state.activationResponse!.token!,
      );

      emit(
        state.copyWith(
          busy: false,
          user: user,
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          busy: false,
          error: e is NetException
              ? BranchActivationError.network
              : BranchActivationError.generic,
          errorMessage: e is NetException ? e.message : null,
        ),
      );
    }
  }

  /// Sets the access pin.
  Future<void> setAccessPin(
    String pin,
  ) async {
    emit(
      state.copyWith(
        busy: true,
        error: BranchActivationError.none,
        action: BranchActivationAction.setAccessPin,
      ),
    );

    try {
      if (state.activationResponse?.token == null) {
        emit(
          state.copyWith(
            busy: false,
            error: BranchActivationError.generic,
          ),
        );

        return;
      }

      final user = await _userRepository.setAccessPin(
        pin: pin,
        token: state.activationResponse!.token!,
      );

      emit(
        state.copyWith(
          busy: false,
          user: user,
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          busy: false,
          error: e is NetException
              ? BranchActivationError.network
              : BranchActivationError.generic,
          errorMessage: e is NetException ? e.message : null,
        ),
      );
    }
  }

  @override
  Future<void> close() {
    _shouldPoll = false;
    return super.close();
  }
}
