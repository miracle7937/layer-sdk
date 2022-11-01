// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:collection';

import 'package:equatable/equatable.dart';

import '../../../../domain_layer/models.dart';

///  The available error status
enum InboxCreateErrorStatus {
  ///  No errors
  none,

  ///  Generic error
  generic,

  ///  Network error
  network,
}

/// Which action
enum InboxCreateBusyAction {
  /// If is loading categories
  loadingCategories,

  /// Posting a new Report
  creatingReport,

  /// Not busy
  idle,
}

/// Class that holds the state of [InboxCreateCubit]
class InboxCreateState extends Equatable {
  /// The cubit error status
  final InboxCreateErrorStatus errorStatus;

  /// The action being performed
  final InboxCreateBusyAction busyAction;

  /// if the cubit is doing anything
  final bool busy;

  /// The error message if any error occour
  final String errorMessage;

  /// Description text for a inbox
  final String? description;

  /// A list of [Message] containing all categories
  final UnmodifiableListView<Message> categories;

  /// The selected report category
  final Message? selectedCategory;

  /// A list of all [InboxFiles]
  final UnmodifiableListView<InboxFile> inboxFiles;

  final InboxReportMessage? inboxMessage;

  /// Creates a new instance of [InboxCreateState]
  InboxCreateState({
    Iterable<Message> categories = const [],
    Iterable<InboxFile> inboxFiles = const [],
    this.inboxMessage,
    this.errorStatus = InboxCreateErrorStatus.none,
    this.busyAction = InboxCreateBusyAction.idle,
    this.busy = false,
    this.errorMessage = '',
    this.description,
    this.selectedCategory,
  })  : categories = UnmodifiableListView(categories),
        inboxFiles = UnmodifiableListView(inboxFiles);

  @override
  List<Object?> get props {
    return [
      errorStatus,
      busyAction,
      busy,
      errorMessage,
      inboxMessage,
      description,
      categories,
      selectedCategory,
      inboxFiles,
    ];
  }

  /// Creates a copy of [InboxCreateState]
  InboxCreateState copyWith({
    InboxCreateErrorStatus? errorStatus,
    InboxCreateBusyAction? busyAction,
    bool? busy,
    String? errorMessage,
    String? description,
    Iterable<Message>? categories,
    Iterable<InboxFile>? inboxFiles,
    Message? selectedCategory,
    InboxReportMessage? inboxMessage,
  }) {
    return InboxCreateState(
      errorStatus: errorStatus ?? this.errorStatus,
      busyAction: busyAction ?? this.busyAction,
      busy: busy ?? this.busy,
      errorMessage: errorMessage ?? this.errorMessage,
      description: description ?? this.description,
      categories: categories ?? this.categories,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      inboxFiles: inboxFiles ?? this.inboxFiles,
      inboxMessage: inboxMessage ?? this.inboxMessage,
    );
  }
}
