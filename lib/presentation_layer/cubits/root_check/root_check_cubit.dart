import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data_layer/repositories.dart';
import '../../cubits.dart';

/// A cubit that checks whether the user device is rooted.
class RootCheckCubit extends Cubit<RootCheckState> {
  /// The settings repository.
  final GlobalSettingRepository _globalSettingRepository;

  /// The wrapper for checksuper library.
  final CheckSuperWrapper _checkSuperWrapper;

  /// Creates a new [RootCheckCubit].
  ///
  /// The [checkSuperWrapper] parameter should only be supplied in unit tests.
  RootCheckCubit({
    required GlobalSettingRepository globalSettingRepository,
    CheckSuperWrapper checkSuperWrapper = const CheckSuperWrapper(),
  })  : _globalSettingRepository = globalSettingRepository,
        _checkSuperWrapper = checkSuperWrapper,
        super(RootCheckState());

  /// Checks the device root status.
  ///
  /// Emits a busy state while checking.
  ///
  /// If the device is rooted it fetches the value of the
  /// `unsecure_device_support` global setting to check whether the rooted
  /// device should be allowed to access the app.
  Future<void> checkStatus() async {
    emit(state.copyWith(busy: true));
    try {
      final isRooted = await _checkSuperWrapper.isDeviceRooted();

      if (isRooted) {
        final settings = await _globalSettingRepository.list(
          codes: ['unsecure_device_support'],
        );

        emit(state.copyWith(
          busy: false,
          status: settings.isEmpty || !settings.first.value
              ? RootCheckStatus.rootedDisallowed
              : RootCheckStatus.rootedAllowed,
        ));
      } else {
        emit(state.copyWith(
          busy: false,
          status: RootCheckStatus.nonRooted,
        ));
      }
    } on Exception {
      emit(state.copyWith(
        busy: false,
        status: RootCheckStatus.failed,
      ));
    }
  }
}
