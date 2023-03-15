import 'package:equatable/equatable.dart';

/// TODO: cubit_issue | I don't think this is the right way to handle the check
/// for what action is the cubit performing. We don't have a parameter for
/// setting this as none or idle.
///
/// Which loading action the cubit is doing
enum LinkBusyAction {
  /// Loading image
  loadingImage,

  /// Loading pdf
  loadingPDF,
}

/// The available error status
enum LinkErrorStatus {
  /// No errors
  none,

  /// Invalid URL
  invalidURL,

  /// Error launching the app to open the link
  launchError,

  /// Generic error
  generic,

  /// IO error - from the filesystem, for instance.
  io,

  /// Network error
  network,
}

/// The state for a link cubit
class LinkState extends Equatable {
  /// If the cubit is busy.
  final bool busy;

  /// Which busy action is the cubit doing
  final LinkBusyAction busyAction;

  /// The current number of bytes downloaded.
  final int downloadedBytes;

  /// The total number of bytes to be downloaded.
  ///
  /// Will be zero if not downloading anything.
  final int totalBytes;

  /// The current error status.
  final LinkErrorStatus errorStatus;

  /// Creates a new [LinkState].
  const LinkState({
    this.busy = false,
    this.downloadedBytes = 0,
    this.totalBytes = 0,
    this.busyAction = LinkBusyAction.loadingImage,
    this.errorStatus = LinkErrorStatus.none,
  });

  @override
  List<Object?> get props => [
        busy,
        busyAction,
        downloadedBytes,
        totalBytes,
        errorStatus,
      ];

  /// Creates a [LinkState] based on this one.
  LinkState copyWith({
    bool? busy,
    LinkBusyAction? busyAction,
    int? downloadedBytes,
    int? totalBytes,
    LinkErrorStatus? errorStatus,
  }) =>
      LinkState(
        busy: busy ?? this.busy,
        busyAction: busyAction ?? this.busyAction,
        downloadedBytes: downloadedBytes ?? this.downloadedBytes,
        totalBytes: totalBytes ?? this.totalBytes,
        errorStatus: errorStatus ?? this.errorStatus,
      );
}
