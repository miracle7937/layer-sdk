import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';

import '../../../domain_layer/models.dart';
import '../../cubits.dart';

/// The available actions the cubit may perform
enum DPAProcessBusyAction {
  /// Starting new process.
  starting,

  /// Cancelling the process.
  cancelling,

  /// Returning to a previous step.
  steppingBack,

  /// Proceeding to the next step in the process.
  steppingForward,

  /// Skipping the current step in the process.
  skipping,

  /// Updating a variable value.
  updatingValue,

  /// Busy resending a code.
  resendingCode,

  /// Busy requesting to change Email.
  requestingEmailChange,

  /// Busy requesting to change phone number.
  requestingPhoneChange,

  /// Busy requesting a manual verification.
  requestingManualVerification,
}

/// Denotes the status of the process in the cubit.
enum DPAProcessRunStatus {
  /// No process started.
  readyToStart,

  /// Process is ongoing.
  running,

  /// Process has finished.
  ///
  /// This can be due to it running its course, or due to user cancelling
  /// the process.
  finished,
}

/// The available error status
enum DPAProcessErrorStatus {
  /// No errors
  none,

  /// Generic error.
  generic,

  /// Network error
  network,
}

/// The state that holds the DPA process definitions.
class DPAProcessState
    extends BaseState<DPAProcessBusyAction, void, DPAProcessErrorStatus> {
  /// The current process.
  ///
  /// A [DPAProcess] has the general details of the process, but also the
  /// specific details of the task at hand (the variables with the current info
  /// to ask from the user, for instance). When stepping to a new page of the
  /// DPA, we'll emit a new [DPAProcess] with the new task and its variables.
  ///
  /// But when the process moves to show a pop-up, this process does not change,
  /// and the new process (with the pop-up task) is passed on [popUp]. This is
  /// done so that UI can still show the previous process/task with the pop-up
  /// process/task on top.
  ///
  /// Keep in mind that when trying to update a variable, only the topmost
  /// process will be updated. So if [popUp] is not null, only its variables
  /// will be updated. If [popUp] is null, then this [process] will be updated.
  final DPAProcess process;

  /// The current pop-up process to be displayed on top of the [process].
  ///
  /// Null if no pop-ups are being shown.
  ///
  /// When not null, updating variables will update this process only.
  final DPAProcess? popUp;

  /// If this cubit is busy uploading/downloading/deleting some file for a
  /// variable.
  ///
  /// This is calculated by using [processingFiles].
  ///
  /// This is done separated from [busy] as you can process more than one
  /// variable and the UI should work differently for each.
  final bool busyProcessingFile;

  /// Holds the data of the variables that are processing files.
  final UnmodifiableSetView<DPAProcessingFileData> processingFiles;

  /// Holds the information of the current status of the process in the cubit:
  /// if one is running, if it has finished, etc.
  final DPAProcessRunStatus runStatus;

  /// Whether or not a value was chosen during this state change.
  final bool chosenValue;

  /// Creates a new [DPAProcessState].
  DPAProcessState({
    DPAProcess? process,
    this.popUp,
    super.actions = const <DPAProcessBusyAction>{},
    super.errors = const <CubitError>{},
    Set<DPAProcessingFileData> processingFiles = const {},
    this.runStatus = DPAProcessRunStatus.readyToStart,
    String errorMessage = '',
    this.chosenValue = false,
  })  : process = process ?? DPAProcess(),
        processingFiles = UnmodifiableSetView(processingFiles),
        busyProcessingFile = processingFiles.isNotEmpty;

  /// Return the [DPAProcessingFileData] for the given variable key.
  ///
  /// If no processing of files is being done for the key, returns `null`.
  DPAProcessingFileData? processingFileDataFromKey(String key) =>
      processingFiles.firstWhereOrNull(
        (d) => d.variableKey == key,
      );

  @override
  List<Object?> get props => [
        process,
        popUp,
        busyProcessingFile,
        processingFiles,
        actions,
        errors,
        runStatus,
        chosenValue,
      ];

  /// Returns the process that is being updated right now.
  ///
  /// If a pop-up is being shown, that will be the active process, if not,
  /// it will be the default process.
  DPAProcess get activeProcess => popUp ?? process;

  /// Returns `true` if it's showing a pop-up.
  bool get hasPopup => popUp != null;

  /// Returns `true` if all fields are validated.
  bool get areVariablesValidated {
    var isValid = true;
    for (var element in process.validate().variables) {
      isValid = isValid && !(element.hasValidationError);
    }
    return isValid;
  }

  /// Creates a [DPAProcessState] based on this one.
  ///
  /// To remove the pop-up, pass `true` to [clearPopUp].
  ///
  /// To clear all sets that deal with the uploading/downloading/deleting files
  /// for variables, pass `true` to [clearProcessingFiles].
  DPAProcessState copyWith({
    DPAProcess? process,
    DPAProcess? popUp,
    bool clearPopUp = false,
    Set<DPAProcessingFileData>? processingFiles,
    bool clearProcessingFiles = false,
    Set<DPAProcessBusyAction>? actions,
    DPAProcessRunStatus? runStatus,
    String? errorMessage,
    bool chosenValue = false,
    Set<CubitError>? errors,
  }) {
    return DPAProcessState(
      process: process ?? this.process,
      popUp: clearPopUp ? null : (popUp ?? this.popUp),
      processingFiles:
          clearProcessingFiles ? {} : (processingFiles ?? this.processingFiles),
      runStatus: runStatus ?? this.runStatus,
      chosenValue: chosenValue,
      errors: errors ?? super.errors,
      actions: actions ?? super.actions,
    );
  }
}

/// All the actions that can be performed on a file.
enum DPAProcessingFileAction {
  /// Upload a file.
  uploading,

  /// Download a file.
  downloading,

  /// Delete a file.
  deleting,
}

/// Holds the data for uploading/downloading/deleting files for a variable.
class DPAProcessingFileData extends Equatable {
  /// The file name.
  final String fileName;

  /// The key for the variable that is processing the file.
  final String variableKey;

  /// The action that is being performed on the file.
  final DPAProcessingFileAction action;

  /// The number of bytes uploaded/downloaded so far.
  ///
  /// Not used when deleting a file.
  final int count;

  /// The total byte count of the file being uploaded/downloaded.
  ///
  /// Not used when deleting a file.
  final int total;

  /// Creates a new [DPAProcessingFileData].
  const DPAProcessingFileData({
    required this.fileName,
    required this.variableKey,
    required this.action,
    this.count = 0,
    this.total = 100,
  });

  @override
  List<Object?> get props => [
        fileName,
        variableKey,
        action,
        count,
        total,
      ];

  /// Creates a [DPAProcessingFileData] based on this one.
  DPAProcessingFileData copyWith({
    String? fileName,
    String? variableKey,
    DPAProcessingFileAction? action,
    int? count,
    int? total,
  }) =>
      DPAProcessingFileData(
        fileName: fileName ?? this.fileName,
        variableKey: variableKey ?? this.variableKey,
        action: action ?? this.action,
        count: count ?? this.count,
        total: total ?? this.total,
      );
}
