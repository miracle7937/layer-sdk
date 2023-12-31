import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:local_auth/local_auth.dart';

import '../../../data_layer/network.dart';
import '../../../domain_layer/use_cases.dart';
import '../../cubits.dart';
import '../../extensions.dart';

/// Cubit that handles the biometrics.
class BiometricsCubit extends Cubit<BiometricsState> {
  /// The local auth package object.
  final _localAuth = LocalAuthentication();

  final GetBiometricsEnabledUseCase _getBiometricsEnabledUseCase;

  /// Creates a new [BiometricsCubit].
  BiometricsCubit({
    required GetBiometricsEnabledUseCase getBiometricsEnabledUseCase,
  })  : _getBiometricsEnabledUseCase = getBiometricsEnabledUseCase,
        super(BiometricsState());

  /// Initializes the biometrics.
  ///
  /// Calculates if the biometrics can be used or not.
  Future<void> initialize() async {
    if (state.busy) {
      return;
    }

    emit(
      state.copyWith(
        busy: true,
      ),
    );

    try {
      final biometricsEnabledOnConsole = await _getBiometricsEnabledUseCase();
      final canCheckBiometrics = await _localAuth.canCheckBiometrics;

      emit(
        state.copyWith(
          busy: false,
          canUseBiometrics: biometricsEnabledOnConsole && canCheckBiometrics,
        ),
      );
    } on Exception catch (e, st) {
      logException(e, st);
      emit(
        state.copyWith(
          busy: false,
          error: e is NetException
              ? BiometricsError.network
              : e.toString() == 'wipe_on_biometric_change'
                  ? BiometricsError.biometricsChanged
                  : BiometricsError.generic,
        ),
      );
    }
  }

  /// Performs an insecure biometrics authentication.
  ///
  /// Should not be used for actual authentication, since it does not involves
  /// reading data from a biometrics secured storage and can be bypassed by an
  /// attacker.
  Future<void> authenticateInsecure({
    required String localizedReason,
    bool stickyAuth = false,
  }) async {
    if (state.busy) {
      return;
    }

    emit(
      state.copyWith(
        busy: true,
      ),
    );

    try {
      final authenticated = await _localAuth.authenticate(
        localizedReason: localizedReason,
        options: AuthenticationOptions(
          stickyAuth: stickyAuth,
        ),
      );

      emit(
        state.copyWith(
          busy: false,
          authenticated: authenticated,
        ),
      );
    } on PlatformException catch (e, st) {
      logException(e, st);
      emit(
        state.copyWith(
          busy: false,
          error: BiometricsError.generic,
        ),
      );
    }
  }
}
