// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

import '../../../../domain_layer/models.dart';

///  The available error status
enum InboxConversationErrorStatus {
  ///  No errors
  none,

  ///  Generic error
  generic,

  ///  Network error
  network,
}

/// Which action
enum InboxConversationBusyAction {
  /// If is loading categories
  loadingMessages,

  /// Not busy
  idle,
}

/// Class that holds the state of [InboxConversationCubit]
class InboxConversationState extends Equatable {
  /// The cubit error status
  final InboxConversationErrorStatus errorStatus;

  /// The action being performed
  final InboxConversationBusyAction busyAction;

  /// if the cubit is doing anything
  final bool busy;

  /// The error message if any error occour
  final String errorMessage;

  /// The report returned from the server
  final InboxReport report;

  /// Creates a new instance of [InboxConversationState]
  InboxConversationState({
    required this.report,
    this.errorStatus = InboxConversationErrorStatus.none,
    this.busyAction = InboxConversationBusyAction.idle,
    this.busy = false,
    this.errorMessage = '',
  });

  @override
  List<Object?> get props {
    return [
      errorStatus,
      busyAction,
      busy,
      errorMessage,
      report,
    ];
  }

  /// Creates a copy of [InboxConversationState]
  InboxConversationState copyWith({
    InboxConversationErrorStatus? errorStatus,
    InboxConversationBusyAction? busyAction,
    bool? busy,
    String? errorMessage,
    InboxReport? report,
  }) {
    return InboxConversationState(
      errorStatus: errorStatus ?? this.errorStatus,
      busyAction: busyAction ?? this.busyAction,
      busy: busy ?? this.busy,
      errorMessage: errorMessage ?? this.errorMessage,
      report: report ?? this.report,
    );
  }
}
