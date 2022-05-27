import 'package:bloc/bloc.dart';
import 'package:logging/logging.dart';

import '../../../data_layer/data_layer.dart';
import '../../business_layer.dart';

/// A cubit that keeps a list of device sessions.
class DeviceSessionCubit extends Cubit<DeviceSessionState> {
  final _log = Logger('DeviceSessionCubit');

  final DeviceSessionRepository _repository;

  /// Creates a new cubit using the supplied [CustomerRepository] and
  /// customer id and type.
  DeviceSessionCubit({
    required DeviceSessionRepository repository,
    required String customerId,
    required CustomerType customerType,
  })  : _repository = repository,
        super(
          DeviceSessionState(
            customerId: customerId,
            customerType: customerType,
          ),
        );

  /// Loads the customer's list of device sessions.
  ///
  /// If [forceRefresh] is true, will skip the cache.
  Future<void> load({
    bool forceRefresh = false,
  }) async {
    _log.info('Load. Forcing refresh? $forceRefresh');

    emit(
      state.copyWith(
        busy: true,
        errorStatus: DeviceSessionErrorStatus.none,
      ),
    );

    try {
      final sessions = await _repository.list(
        customerId: state.customerId,
        forceRefresh: forceRefresh,
      );

      emit(
        state.copyWith(
          sessions: sessions.map((e) => SessionData(session: e)).toList(),
          busy: false,
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          busy: false,
          errorStatus: e is NetException
              ? DeviceSessionErrorStatus.network
              : DeviceSessionErrorStatus.generic,
        ),
      );

      rethrow;
    }
  }

  /// Terminates a session using the device id.
  ///
  /// This will not set the overall state to busy, but instead just the busy
  /// on the session. This way we can have multiple actions running on
  /// different sessions at the same time independently.
  ///
  /// The error status is similarly localized to the session.
  Future<void> terminateSession({
    required String deviceId,
  }) async {
    _log.info('Terminating session for $deviceId');

    // Emits a new state with the current session busy, and without errors.
    emit(
      state.copyWith(
        sessions: state.sessions
            .map(
              (e) => e.session.deviceId == deviceId
                  ? e.copyWith(
                      busy: true,
                      errorStatus: DeviceSessionErrorStatus.none,
                    )
                  : e,
            )
            .toList(),
      ),
    );

    try {
      final newSession = await _repository.terminateSession(
        customerType: state.customerType,
        deviceId: deviceId,
      );

      // Emits a new state with the returned session not busy anymore
      final sessions = state.sessions
          .map(
            (e) => e.session.deviceId == deviceId
                ? e.copyWith(
                    session: newSession,
                    busy: false,
                  )
                : e,
          )
          .toList();

      emit(
        state.copyWith(
          sessions: sessions,
        ),
      );
    } on Exception catch (e) {
      // In case of an exception, set the status for error.
      emit(
        state.copyWith(
          sessions: state.sessions
              .map(
                (s) => s.session.deviceId == deviceId
                    ? s.copyWith(
                        busy: false,
                        errorStatus: e is NetException
                            ? DeviceSessionErrorStatus.network
                            : DeviceSessionErrorStatus.generic,
                      )
                    : s,
              )
              .toList(),
        ),
      );

      rethrow;
    }
  }
}
