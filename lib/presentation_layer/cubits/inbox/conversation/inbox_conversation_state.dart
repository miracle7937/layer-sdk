// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:collection';

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

  /// Setting up the attachments
  loadingFiles,

  /// Is sending a chat message
  postingMessage,

  /// Is sending attachments
  postingInboxFiles,

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

  /// The list of messages to be rendered in the view
  final UnmodifiableListView<InboxChatMessage> messages;

  /// A list of previously sent files
  final UnmodifiableListView<InboxFile> uploadedFiles;

  /// A list of files that still need to be uploaded
  final UnmodifiableListView<InboxFile> filesToUpload;

  /// A text message
  final String messageText;

  /// The maximum amount of characters that can be sent in the message
  final int maxCharactersPerMessage;

  /// The maximum size of a file to be selected
  final int maxFileSizeLimit;

  /// Creates a new instance of [InboxConversationState]
  InboxConversationState({
    required this.report,
    this.errorStatus = InboxConversationErrorStatus.none,
    this.busyAction = InboxConversationBusyAction.idle,
    this.busy = false,
    this.errorMessage = '',
    this.messageText = '',
    this.maxCharactersPerMessage = 800,
    this.maxFileSizeLimit = 20480,
    Iterable<InboxChatMessage> messages = const [],
    Iterable<InboxFile> uploadedFiles = const [],
    Iterable<InboxFile> filesToUpload = const [],
  })  : messages = UnmodifiableListView(messages),
        uploadedFiles = UnmodifiableListView(uploadedFiles),
        filesToUpload = UnmodifiableListView(filesToUpload);

  @override
  List<Object?> get props {
    return [
      errorStatus,
      busyAction,
      busy,
      errorMessage,
      report,
      messages,
      uploadedFiles,
      filesToUpload,
      messageText,
      maxCharactersPerMessage,
      maxFileSizeLimit,
    ];
  }

  /// Creates a copy of [InboxConversationState]
  InboxConversationState copyWith({
    InboxConversationErrorStatus? errorStatus,
    InboxConversationBusyAction? busyAction,
    bool? busy,
    String? errorMessage,
    InboxReport? report,
    String? messageText,
    int? maxCharactersPerMessage,
    int? maxFileSizeLimit,
    Iterable<InboxChatMessage>? messages,
    Iterable<InboxFile>? uploadedFiles,
    Iterable<InboxFile>? filesToUpload,
  }) {
    return InboxConversationState(
      errorStatus: errorStatus ?? this.errorStatus,
      busyAction: busyAction ?? this.busyAction,
      busy: busy ?? this.busy,
      errorMessage: errorMessage ?? this.errorMessage,
      report: report ?? this.report,
      messages: messages ?? this.messages,
      uploadedFiles: uploadedFiles ?? this.uploadedFiles,
      filesToUpload: filesToUpload ?? this.filesToUpload,
      messageText: messageText ?? this.messageText,
      maxCharactersPerMessage:
          maxCharactersPerMessage ?? this.maxCharactersPerMessage,
      maxFileSizeLimit: maxFileSizeLimit ?? this.maxFileSizeLimit,
    );
  }
}
