import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';

import '../../../data_layer/data_layer.dart';

/// The available error status
enum DeviceSessionErrorStatus {
  /// No errors
  none,

  /// Generic error
  generic,

  /// Network error
  network,
}

/// Keeps all data for one device session
class SessionData extends Equatable {
  /// The [DeviceSession] associated with this data.
  final DeviceSession session;

  /// This is a more granular busy indicator, only for this session
  ///
  /// Allows the UI to only indicate the busy on one session, without blocking
  /// the others.
  final bool busy;

  /// This is a more granular error status, only for this session
  ///
  /// Allows the UI to only indicate the error on one session, without blocking
  /// the others.
  final DeviceSessionErrorStatus errorStatus;

  /// Creates a new SessionData
  SessionData({
    required this.session,
    this.busy = false,
    this.errorStatus = DeviceSessionErrorStatus.none,
  });

  @override
  List<Object?> get props => [
        session,
        busy,
        errorStatus,
      ];

  /// Creates a new session data based on this one.
  SessionData copyWith({
    DeviceSession? session,
    bool? busy,
    DeviceSessionErrorStatus? errorStatus = DeviceSessionErrorStatus.none,
  }) =>
      SessionData(
        session: session ?? this.session,
        busy: busy ?? this.busy,
        errorStatus: errorStatus ?? this.errorStatus,
      );
}

/// The state of the device session cubit
class DeviceSessionState extends Equatable {
  /// The customer id of the owner of these device sessions.
  final String customerId;

  /// The type of the owner of these device sessions.
  final CustomerType customerType;

  /// A list of [SessionData] that each can have their own busy state.
  final UnmodifiableListView<SessionData> sessions;

  /// True if the cubit is processing something.
  final bool busy;

  /// The current error status.
  final DeviceSessionErrorStatus errorStatus;

  /// True when at least one of the sessions is busy
  ///
  /// Allows the UI to not show the busy for the entire list, but also
  /// disable any buttons or actions while we have pending actions going on.
  final bool hasBusySession;

  /// True when at least one of the sessions has an error
  final bool hasErrorSession;

  /// Creates a new state.
  DeviceSessionState({
    required this.customerId,
    required this.customerType,
    List<SessionData> sessions = const <SessionData>[],
    this.busy = false,
    this.errorStatus = DeviceSessionErrorStatus.none,
  })  : sessions = UnmodifiableListView(sessions),
        hasBusySession = sessions.firstWhereOrNull((e) => e.busy) != null,
        hasErrorSession = sessions.firstWhereOrNull(
              (e) => e.errorStatus != DeviceSessionErrorStatus.none,
            ) !=
            null;

  @override
  List<Object?> get props => [
        customerId,
        customerType,
        sessions,
        busy,
        errorStatus,
        hasBusySession,
        hasErrorSession,
      ];

  /// Creates a new state based on this one.
  DeviceSessionState copyWith({
    String? customerId,
    CustomerType? customerType,
    List<SessionData>? sessions,
    bool? busy,
    DeviceSessionErrorStatus? errorStatus,
  }) =>
      DeviceSessionState(
        customerId: customerId ?? this.customerId,
        customerType: customerType ?? this.customerType,
        sessions: sessions ?? this.sessions,
        busy: busy ?? this.busy,
        errorStatus: errorStatus ?? this.errorStatus,
      );
}
