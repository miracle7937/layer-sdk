import 'dart:collection';

import 'package:equatable/equatable.dart';

import '../../../domain_layer/models.dart';

/// Represents the state of [MessageCubit]
class MessageState extends Equatable {
  /// True if the cubit is processing something
  final bool busy;

  /// List of [Message]s
  final UnmodifiableListView<Message> messages;

  /// Error message for the last occurred error
  final MessageStateErrors error;

  /// Creates a new instance of [MessageState]
  MessageState({
    Iterable<Message> messages = const [],
    this.busy = false,
    this.error = MessageStateErrors.none,
  }) : messages = UnmodifiableListView(messages);

  @override
  List<Object?> get props => [
        messages,
        busy,
        error,
      ];

  /// Creates a new instance of [MessageState] based on the current instance
  MessageState copyWith({
    bool? busy,
    Iterable<Message>? messages,
    MessageStateErrors? error,
  }) {
    return MessageState(
      busy: busy ?? this.busy,
      messages: messages ?? this.messages,
      error: error ?? this.error,
    );
  }
}

/// Enum for all possible errors for [MessageCubit]
enum MessageStateErrors {
  /// No errors
  none,

  /// Generic error
  generic,
}
