import 'package:bloc/bloc.dart';
import '../../../_migration/data_layer/src/models/customer/customer.dart';
import '../../../data_layer/network.dart';
import '../../../data_layer/repositories.dart';
import '../../../domain_layer/models.dart';
import 'device_session_state.dart';

/// A cubit that keeps a list of device sessions.
class DeviceSessionCubit extends Cubit<DeviceSessionState> {
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
    List<SessionType> deviceTypes = const [
      SessionType.android,
      SessionType.iOS
    ],
    SessionStatus status = SessionStatus.active,
    SessionStatus? secondStatus,
    String? sortby,
    bool? desc,
    bool forceRefresh = false,
  }) async {
    emit(
      state.copyWith(
        busy: true,
        errorStatus: DeviceSessionErrorStatus.none,
      ),
    );

    try {
      final sessions = await _repository.getDeviceSessions(
        customerId: state.customerId,
        forceRefresh: forceRefresh,
        deviceTypes: deviceTypes,
        status: status,
        secondStatus: secondStatus,
        sortby: sortby,
        desc: desc,
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
