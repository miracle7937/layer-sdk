import 'package:bloc/bloc.dart';
import 'package:collection/collection.dart';
import 'package:logging/logging.dart';

import '../../../data_layer/network.dart';
import '../../../domain_layer/models.dart';
import '../../../domain_layer/use_cases.dart';
import '../../cubits.dart';
import '../../extensions.dart';

/// A cubit that manages a DPA process.
class DPAProcessCubit extends Cubit<DPAProcessState> {
  final _log = Logger('DPAProcessCubit');

  final StartDPAProcessUseCase _startDPAProcessUseCase;
  final ResumeDPAProcessUsecase _resumeDPAProcessUsecase;
  final LoadTaskByIdUseCase _loadTaskByIdUseCase;
  final DPAStepBackUseCase _stepBackUseCase;
  final DPAStepOrFinishProcessUseCase _stepOrFinishProcessUseCase;
  final CancelDPAProcessUseCase _cancelDPAProcessUseCase;
  final UploadDPAImageUseCase _uploadDPAImageUseCase;
  final DownloadDPAFileUseCase _downloadDPAFileUseCase;
  final DeleteDPAFileUseCase _deleteDPAFileUseCase;
  final DPAResendCodeUseCase _resendCodeUseCase;
  final DPAChangePhoneNumberUseCase _changePhoneNumberUseCase;
  final DPAChangeEmailAddressUseCase _changeEmailAddressUseCase;
  final DPARequestManualVerificationUseCase _manualVerificationUseCase;
  final DPASkipStepUseCase _skipStepUseCase;
  final ParseJSONIntoDPATaskToContinueDPAProcessUseCase
      _parseJSONIntoDPATaskToContinueDPAProcessUseCase;
  final ParseJSONIntoStepPropertiesUseCase _parseJSONIntoStepPropertiesUseCase;

  /// Creates a new cubit using the necessary use cases.
  DPAProcessCubit({
    required StartDPAProcessUseCase startDPAProcessUseCase,
    required ResumeDPAProcessUsecase resumeDPAProcessUsecase,
    required LoadTaskByIdUseCase loadTaskByIdUseCase,
    required DPAStepBackUseCase stepBackUseCase,
    required DPAStepOrFinishProcessUseCase stepOrFinishProcessUseCase,
    required CancelDPAProcessUseCase cancelDPAProcessUseCase,
    required UploadDPAImageUseCase uploadDPAImageUseCase,
    required DownloadDPAFileUseCase downloadDPAFileUseCase,
    required DeleteDPAFileUseCase deleteDPAFileUseCase,
    required DPAResendCodeUseCase resendCodeUseCase,
    required DPAChangePhoneNumberUseCase changePhoneNumberUseCase,
    required DPAChangeEmailAddressUseCase changeEmailAddressUseCase,
    required DPARequestManualVerificationUseCase manualVerificationUseCase,
    required DPASkipStepUseCase skipStepUseCase,
    required ParseJSONIntoDPATaskToContinueDPAProcessUseCase
        parseJSONIntoDPATaskToContinueDPAProcessUseCase,
    required ParseJSONIntoStepPropertiesUseCase
        parseJSONIntoStepPropertiesUseCase,
  })  : _startDPAProcessUseCase = startDPAProcessUseCase,
        _resumeDPAProcessUsecase = resumeDPAProcessUsecase,
        _loadTaskByIdUseCase = loadTaskByIdUseCase,
        _stepBackUseCase = stepBackUseCase,
        _stepOrFinishProcessUseCase = stepOrFinishProcessUseCase,
        _cancelDPAProcessUseCase = cancelDPAProcessUseCase,
        _uploadDPAImageUseCase = uploadDPAImageUseCase,
        _downloadDPAFileUseCase = downloadDPAFileUseCase,
        _deleteDPAFileUseCase = deleteDPAFileUseCase,
        _resendCodeUseCase = resendCodeUseCase,
        _changePhoneNumberUseCase = changePhoneNumberUseCase,
        _changeEmailAddressUseCase = changeEmailAddressUseCase,
        _manualVerificationUseCase = manualVerificationUseCase,
        _skipStepUseCase = skipStepUseCase,
        _parseJSONIntoDPATaskToContinueDPAProcessUseCase =
            parseJSONIntoDPATaskToContinueDPAProcessUseCase,
        _parseJSONIntoStepPropertiesUseCase =
            parseJSONIntoStepPropertiesUseCase,
        super(DPAProcessState());

  /// Starts a DPA process, either by starting a new one (if [instanceId] is
  /// `null`) or by resuming and ongoing process (if it is provided).
  Future<void> start({
    required String definitionId,
    String? instanceId,
    required List<DPAVariable> variables,
  }) async {
    assert(state.runStatus == DPAProcessRunStatus.readyToStart);

    _log.info('Starting process with id $definitionId');

    emit(
      state.copyWith(
        actions: state.addAction(
          DPAProcessBusyAction.starting,
        ),
        errors: state.removeErrorForAction(
          DPAProcessBusyAction.starting,
        ),
      ),
    );

    final isResuming = instanceId != null;

    try {
      final process = isResuming
          ? await _resumeProcess(
              instanceId: instanceId,
            )
          : await _startDPAProcessUseCase(
              key: definitionId,
              variables: variables,
            );

      emit(
        state.copyWith(
          actions: state.removeAction(
            DPAProcessBusyAction.starting,
          ),
        ),
      );

      if (process != null) {
        final secondsToAutoStepOrFinish = process.stepProperties?.delay ??
            process.stepProperties?.autoFinishIn;

        emit(
          state.copyWith(
            process: process.isPopUp() ? null : process,
            popUp: process.isPopUp() ? process : null,
            clearPopUp: !process.isPopUp(),
            runStatus: process.finished
                ? DPAProcessRunStatus.finished
                : DPAProcessRunStatus.running,
            clearProcessingFiles: true,
          ),
        );

        final shouldBlock = process.stepProperties?.block.shouldBlock(
              process.stepProperties?.screenType,
            ) ??
            false;

        if (shouldBlock) {
          stepOrFinish();
        }

        if (secondsToAutoStepOrFinish != null) {
          await Future.delayed(Duration(seconds: secondsToAutoStepOrFinish));
          stepOrFinish();
        }
      }
    } on NetException catch (e) {
      emit(
        state.copyWith(
          actions: state.removeAction(
            DPAProcessBusyAction.starting,
          ),
          errors: state.addErrorFromException(
            action: DPAProcessBusyAction.starting,
            exception: e,
          ),
        ),
      );
    }
  }

  /// Continues a process with a new task
  Future<void> continueProcessWithTask({
    required DPATask task,
    required DPAProcessStepProperties processProperties,
  }) async {
    final process = DPAProcess(
      task: task,
      processName: task.processDefinitionName,
      variables: task.variables,
      stepProperties: processProperties,
    );

    emit(
      state.copyWith(
        process: process.isPopUp() ? null : process,
        popUp: process.isPopUp() ? process : null,
        clearPopUp: !process.isPopUp(),
        actions: state.removeAction(
          DPAProcessBusyAction.steppingForward,
        ),
        runStatus: DPAProcessRunStatus.running,
        clearProcessingFiles: true,
      ),
    );
  }

  Future<DPAProcess?> _resumeProcess({
    required String instanceId,
  }) async {
    final task = await _loadTaskByIdUseCase(
      processInstanceId: instanceId,
    );

    if (task != null) {
      final process = await _resumeDPAProcessUsecase(
        id: task.id,
      );

      return process.copyWith(
        task: task,
        processName: task.processDefinitionName,
      );
    }

    return null;
  }

  /// Returns to the previous step.
  Future<void> stepBack() async {
    assert(state.runStatus == DPAProcessRunStatus.running);

    // If we're on the first task, instead of stepping back, we just cancel
    // the whole DPA process.
    if (state.activeProcess.task?.previousTasksIds.isEmpty ?? false) {
      cancelProcess();
      return;
    }

    _log.info(
      'Stepping back on process with id ${state.activeProcess.task?.id}',
    );

    emit(
      state.copyWith(
        actions: state.addAction(
          DPAProcessBusyAction.steppingBack,
        ),
        errors: state.removeErrorForAction(
          DPAProcessBusyAction.steppingBack,
        ),
      ),
    );

    try {
      final process = await _stepBackUseCase(
        process: state.activeProcess,
      );

      emit(
        state.copyWith(
          process: process.isPopUp() ? null : process,
          popUp: process.isPopUp() ? process : null,
          clearPopUp: !process.isPopUp(),
          actions: state.removeAction(
            DPAProcessBusyAction.steppingBack,
          ),
          clearProcessingFiles: true,
        ),
      );
    } on NetException catch (e) {
      emit(
        state.copyWith(
          actions: state.removeAction(
            DPAProcessBusyAction.steppingBack,
          ),
          errors: state.addErrorFromException(
            action: DPAProcessBusyAction.steppingBack,
            exception: e,
          ),
        ),
      );
    }
  }

  /// Proceeds to next step, or finishes the process if at the last one.
  Future<void> stepOrFinish({
    List<DPAVariable>? extraVariables,
  }) async {
    assert(state.runStatus == DPAProcessRunStatus.running);

    _log.info(
      'Stepping process with id ${state.activeProcess.task?.id}',
    );

    emit(
      state.copyWith(
        actions: state.addAction(
          DPAProcessBusyAction.steppingForward,
        ),
        errors: state.removeErrorForAction(
          DPAProcessBusyAction.steppingForward,
        ),
      ),
    );

    try {
      var process = state.activeProcess.validate();

      if (process.canProceed) {
        process = await _stepOrFinishProcessUseCase(
          process: process,
          extraVariables: extraVariables,
        );
      }

      final secondsToAutoStepOrFinish =
          process.stepProperties?.delay ?? process.stepProperties?.autoFinishIn;

      try {
        final continueOldProcessVariable =
            process.returnVariables.singleWhereOrNull(
          (variable) => variable['name'] == 'continue_old_process',
        );

        if (continueOldProcessVariable != null) {
          final taskVariable = process.returnVariables.singleWhereOrNull(
            (variable) => variable['name'] == 'task',
          );

          if (taskVariable?['value'] != null) {
            final task = _parseJSONIntoDPATaskToContinueDPAProcessUseCase(
              json: taskVariable!['value'],
            );

            final processProperties =
                taskVariable['value']['taskVariables']['properties'] ?? {};

            final properties = _parseJSONIntoStepPropertiesUseCase(
              json: processProperties,
            );

            continueProcessWithTask(
              task: task,
              processProperties: properties,
            );
            return;
          }
        }
      } on Exception catch (error, stackTrace) {
        _log.severe(
          'Error while parsing the task to continue the onboarding',
          error,
          stackTrace,
        );
      }

      emit(
        state.copyWith(
          process: process.isPopUp() ? null : process,
          popUp: process.isPopUp() ? process : null,
          clearPopUp: !process.isPopUp(),
          actions: state.removeAction(
            DPAProcessBusyAction.steppingForward,
          ),
          runStatus: process.finished ? DPAProcessRunStatus.finished : null,
          clearProcessingFiles: true,
        ),
      );

      if (secondsToAutoStepOrFinish != null) {
        await Future.delayed(Duration(seconds: secondsToAutoStepOrFinish));

        if (state.actions.contains(DPAProcessBusyAction.steppingForward) ||
            state.runStatus != DPAProcessRunStatus.running) {
          return;
        }

        stepOrFinish();
      }
    } on NetException catch (e) {
      emit(
        state.copyWith(
          actions: state.removeAction(
            DPAProcessBusyAction.steppingForward,
          ),
          errors: state.addErrorFromException(
            action: DPAProcessBusyAction.steppingForward,
            exception: e,
          ),
        ),
      );
    }
  }

  /// Skips this step and goes to next step, or finishes the process
  /// if at the last one.
  Future<void> skipOrFinish({List<DPAVariable>? extraVariables}) async {
    assert(state.runStatus == DPAProcessRunStatus.running);

    emit(
      state.copyWith(
        actions: state.addAction(
          DPAProcessBusyAction.skipping,
        ),
        errors: state.removeErrorForAction(
          DPAProcessBusyAction.skipping,
        ),
      ),
    );

    try {
      var process = state.activeProcess;

      process = await _skipStepUseCase(
        process: process,
        extraVariables: extraVariables ?? [],
      );

      final secondsToAutoStepOrFinish =
          process.stepProperties?.delay ?? process.stepProperties?.autoFinishIn;

      emit(
        state.copyWith(
          process: process.isPopUp() ? null : process,
          popUp: process.isPopUp() ? process : null,
          clearPopUp: !process.isPopUp(),
          actions: state.removeAction(
            DPAProcessBusyAction.skipping,
          ),
          runStatus: process.finished ? DPAProcessRunStatus.finished : null,
          clearProcessingFiles: true,
        ),
      );

      if (secondsToAutoStepOrFinish != null) {
        await Future.delayed(Duration(seconds: secondsToAutoStepOrFinish));
        stepOrFinish(extraVariables: extraVariables);
      }
    } on NetException catch (e) {
      emit(
        state.copyWith(
          actions: state.removeAction(
            DPAProcessBusyAction.skipping,
          ),
          errors: state.addErrorFromException(
            action: DPAProcessBusyAction.skipping,
            exception: e,
          ),
        ),
      );
    }
  }

  /// Cancels the ongoing process.
  Future<void> cancelProcess() async {
    assert(state.runStatus == DPAProcessRunStatus.running);
    assert(state.activeProcess.task?.processInstanceId != null);

    _log.info('Cancelling process with id ${state.activeProcess.task?.id}');

    emit(
      state.copyWith(
        actions: state.addAction(
          DPAProcessBusyAction.cancelling,
        ),
        errors: state.removeErrorForAction(
          DPAProcessBusyAction.cancelling,
        ),
      ),
    );

    try {
      final processId = state.activeProcess.task!.processInstanceId!;

      final result = await _cancelDPAProcessUseCase(
        processInstanceId: processId,
      );

      // Only emit the new state if we get confirmation.
      if (result) {
        final cancelledProcess = state.activeProcess.copyWith(
          status: DPAStatus.cancelled,
        );

        emit(
          DPAProcessState().copyWith(
            process: state.activeProcess.isPopUp() ? null : cancelledProcess,
            popUp: state.activeProcess.isPopUp() ? cancelledProcess : null,
            actions: state.removeAction(
              DPAProcessBusyAction.cancelling,
            ),
            runStatus: DPAProcessRunStatus.finished,
            clearProcessingFiles: true,
          ),
        );
      }
    } on NetException catch (e) {
      emit(
        state.copyWith(
          actions: state.removeAction(
            DPAProcessBusyAction.cancelling,
          ),
          errors: state.addErrorFromException(
            action: DPAProcessBusyAction.cancelling,
            exception: e,
          ),
        ),
      );
    }
  }

  /// Updates the value of a variable
  Future<void> updateValue({
    required DPAVariable variable,
    required dynamic newValue,
  }) async {
    assert(state.runStatus == DPAProcessRunStatus.running);

    emit(
      state.copyWith(
        actions: state.addAction(
          DPAProcessBusyAction.updatingValue,
        ),
        errors: state.removeErrorForAction(
          DPAProcessBusyAction.updatingValue,
        ),
      ),
    );

    _log.info(
      'Updating ${state.hasPopup ? 'pop-up' : 'process'}'
      ' variable ${variable.id}'
      ' with ${newValue == null ? 'null' : 'value "$newValue"'}',
    );

    final updatedProcess = state.activeProcess.copyWith(
      variables: state.activeProcess.variables.map(
        (e) => e.id == variable.id
            ? e.validateAndCopyWith(
                value: newValue,
                clearValue: newValue == null,
              )
            : e,
      ),
    );

    emit(
      state.copyWith(
        process: updatedProcess.isPopUp() ? null : updatedProcess,
        popUp: updatedProcess.isPopUp() ? updatedProcess : null,
        actions: state.removeAction(
          DPAProcessBusyAction.updatingValue,
        ),
      ),
    );
  }

  /// Uploads an image as a value for a variable.
  ///
  /// During uploading, the [DPAProcessState.busy] property remains the same as
  /// before, and instead the variable is added to the
  /// [DPAProcessState.processingFiles] set, which can be used by the UI to
  /// only create a busy state on the variable that is doing the upload.
  ///
  /// Also, the [DPAProcessState.busyProcessingFile] property will be updated.
  Future<void> uploadImage({
    required DPAVariable variable,
    required String filename,
    required int fileSizeBytes,
    required String fileBase64Data,
  }) async {
    assert(
      variable.key.isNotEmpty,
      'Variable must have a "key" set to upload a file.',
    );

    assert(
      state.processingFileDataFromKey(variable.key) == null,
      'Variable is already processing a file.',
    );

    emit(
      state.copyWith(
        processingFiles: state.processingFiles.union(
          {
            DPAProcessingFileData(
              fileName: filename,
              action: DPAProcessingFileAction.uploading,
              variableKey: variable.key,
            ),
          },
        ),
        actions: state.addAction(
          DPAProcessBusyAction.updatingValue,
        ),
        errors: state.removeErrorForAction(
          DPAProcessBusyAction.updatingValue,
        ),
      ),
    );

    try {
      final updatedVariable = await _uploadDPAImageUseCase(
        process: state.activeProcess,
        variable: variable,
        imageName: filename,
        imageFileSizeBytes: fileSizeBytes,
        imageBase64Data: fileBase64Data,
        onProgress: (count, total) => _updateFileProgress(
          variable: variable,
          count: count,
          total: total,
        ),
      );

      final updatedProcess = updatedVariable == variable
          ? state.activeProcess
          : state.activeProcess.copyWith(
              variables: state.activeProcess.variables.map(
                (e) => e.key == variable.key ? updatedVariable : e,
              ),
            );

      emit(
        state.copyWith(
          actions: state.removeAction(
            DPAProcessBusyAction.updatingValue,
          ),
          process: updatedProcess.isPopUp() ? null : updatedProcess,
          popUp: updatedProcess.isPopUp() ? updatedProcess : null,
          processingFiles: state.processingFiles
              .where((d) => d.variableKey != variable.key)
              .toSet(),
        ),
      );
    } on Exception catch (e, st) {
      logException(e, st);
      emit(
        state.copyWith(
          processingFiles: state.processingFiles
              .where((d) => d.variableKey != variable.key)
              .toSet(),
          actions: state.removeAction(
            DPAProcessBusyAction.updatingValue,
          ),
          errors: state.addErrorFromException(
            exception: e,
            action: DPAProcessBusyAction.updatingValue,
          ),
        ),
      );
    }
  }

  /// Downloads a base64 encoded file from the server.
  /// This method won't update this cubit's state as this is an one time event.
  Future<String?> downloadFile({
    required DPAVariable variable,
    NetProgressCallback? onProgress,
  }) async {
    final process = state.activeProcess;

    return _downloadDPAFileUseCase(
      process: process,
      variable: variable,
      onProgress: onProgress,
    );
  }

  /// Deletes an image/file from a variable.
  ///
  /// During deleting, the [DPAProcessState.busy] property remains the same as
  /// before, and instead the variable is added to the
  /// [DPAProcessState.processingFiles] set, which can be used by the UI to
  /// only create a busy state on the variable that is being deleted.
  ///
  /// Also, the [DPAProcessState.busyProcessingFile] property will be updated.
  Future<void> deleteFile({
    required DPAVariable variable,
  }) async {
    assert(
      variable.key.isNotEmpty,
      'Variable must have a "key" set to delete a file.',
    );

    assert(
      state.processingFileDataFromKey(variable.key) == null,
      'Variable is already processing a file.',
    );

    emit(
      state.copyWith(
        processingFiles: state.processingFiles.union(
          {
            DPAProcessingFileData(
              fileName: (variable.value as DPAFileData?)?.name ?? '',
              action: DPAProcessingFileAction.deleting,
              variableKey: variable.key,
            ),
          },
        ),
        actions: state.addAction(
          DPAProcessBusyAction.updatingValue,
        ),
        errors: state.removeErrorForAction(
          DPAProcessBusyAction.updatingValue,
        ),
      ),
    );

    try {
      final updatedVariable = await _deleteDPAFileUseCase(
        process: state.activeProcess,
        variable: variable,
        onProgress: (count, total) => _updateFileProgress(
          variable: variable,
          count: count,
          total: total,
        ),
      );

      final updatedProcess = state.activeProcess.copyWith(
        variables: state.activeProcess.variables.map(
          (e) => e.key == variable.key ? updatedVariable : e,
        ),
      );

      emit(
        state.copyWith(
          actions: state.removeAction(
            DPAProcessBusyAction.updatingValue,
          ),
          process: updatedProcess.isPopUp() ? null : updatedProcess,
          popUp: updatedProcess.isPopUp() ? updatedProcess : null,
          processingFiles: state.processingFiles
              .where((d) => d.variableKey != variable.key)
              .toSet(),
        ),
      );
    } on NetException catch (e, st) {
      logException(e, st);
      emit(
        state.copyWith(
          processingFiles: state.processingFiles
              .where((d) => d.variableKey != variable.key)
              .toSet(),
          actions: state.removeAction(
            DPAProcessBusyAction.updatingValue,
          ),
          errors: state.addErrorFromException(
            exception: e,
            action: DPAProcessBusyAction.updatingValue,
          ),
        ),
      );
    }
  }

  /// Requests a new code by stepping in the process with the
  /// necessary [DPAVariable].
  Future<void> resendCode() async {
    assert(state.runStatus == DPAProcessRunStatus.running);

    emit(
      state.copyWith(
        actions: state.addAction(
          DPAProcessBusyAction.resendingCode,
        ),
        errors: state.removeErrorForAction(
          DPAProcessBusyAction.resendingCode,
        ),
      ),
    );

    try {
      var process = state.activeProcess;

      process = await _resendCodeUseCase(
        process: process,
      );

      emit(
        state.copyWith(
          process: process.isPopUp() ? null : process,
          popUp: process.isPopUp() ? process : null,
          clearPopUp: !process.isPopUp(),
          actions: state.removeAction(
            DPAProcessBusyAction.resendingCode,
          ),
          runStatus: process.finished ? DPAProcessRunStatus.finished : null,
          clearProcessingFiles: true,
        ),
      );
    } on NetException catch (e, st) {
      logException(e, st);
      emit(
        state.copyWith(
          actions: state.removeAction(
            DPAProcessBusyAction.resendingCode,
          ),
          errors: state.addErrorFromException(
            exception: e,
            action: DPAProcessBusyAction.resendingCode,
          ),
        ),
      );
    }
  }

  /// Requests a phone number change by stepping in the process with the
  /// necessary [DPAVariable].
  Future<void> requestPhoneNumberChange() async {
    assert(state.runStatus == DPAProcessRunStatus.running);

    emit(
      state.copyWith(
        actions: state.addAction(
          DPAProcessBusyAction.requestingPhoneChange,
        ),
        errors: state.removeErrorForAction(
          DPAProcessBusyAction.requestingPhoneChange,
        ),
      ),
    );

    try {
      var process = state.activeProcess;

      process = await _changePhoneNumberUseCase(
        process: process,
      );

      emit(
        state.copyWith(
          process: process.isPopUp() ? null : process,
          popUp: process.isPopUp() ? process : null,
          clearPopUp: !process.isPopUp(),
          actions: state.removeAction(
            DPAProcessBusyAction.requestingPhoneChange,
          ),
          runStatus: process.finished ? DPAProcessRunStatus.finished : null,
          clearProcessingFiles: true,
        ),
      );
    } on NetException catch (e, st) {
      logException(e, st);
      emit(
        state.copyWith(
          actions: state.removeAction(
            DPAProcessBusyAction.requestingPhoneChange,
          ),
          errors: state.addErrorFromException(
            exception: e,
            action: DPAProcessBusyAction.requestingPhoneChange,
          ),
        ),
      );
    }
  }

  /// Requests a email address change by stepping in the process with the
  /// necessary [DPAVariable].
  Future<void> requestEmailAddressChange() async {
    assert(state.runStatus == DPAProcessRunStatus.running);

    emit(
      state.copyWith(
        actions: state.addAction(
          DPAProcessBusyAction.requestingEmailChange,
        ),
        errors: state.removeErrorForAction(
          DPAProcessBusyAction.requestingEmailChange,
        ),
      ),
    );

    try {
      var process = state.activeProcess;

      process = await _changeEmailAddressUseCase(
        process: process,
      );

      emit(
        state.copyWith(
          process: process.isPopUp() ? null : process,
          popUp: process.isPopUp() ? process : null,
          clearPopUp: !process.isPopUp(),
          actions: state.removeAction(
            DPAProcessBusyAction.requestingEmailChange,
          ),
          runStatus: process.finished ? DPAProcessRunStatus.finished : null,
          clearProcessingFiles: true,
        ),
      );
    } on NetException catch (e, st) {
      logException(e, st);
      emit(
        state.copyWith(
          actions: state.removeAction(
            DPAProcessBusyAction.requestingEmailChange,
          ),
          errors: state.addErrorFromException(
            exception: e,
            action: DPAProcessBusyAction.requestingEmailChange,
          ),
        ),
      );
    }
  }

  /// Requests a manual verification by stepping in the process with the
  /// necessary [DPAVariable].
  Future<void> requestManualVerification() async {
    assert(state.runStatus == DPAProcessRunStatus.running);

    emit(
      state.copyWith(
        actions: state.addAction(
          DPAProcessBusyAction.requestingManualVerification,
        ),
        errors: state.removeErrorForAction(
          DPAProcessBusyAction.requestingManualVerification,
        ),
      ),
    );

    try {
      var process = state.activeProcess;

      process = await _manualVerificationUseCase(
        process: process,
      );

      emit(
        state.copyWith(
          process: process.isPopUp() ? null : process,
          popUp: process.isPopUp() ? process : null,
          clearPopUp: !process.isPopUp(),
          actions: state.removeAction(
            DPAProcessBusyAction.requestingManualVerification,
          ),
          runStatus: process.finished ? DPAProcessRunStatus.finished : null,
          clearProcessingFiles: true,
        ),
      );
    } on NetException catch (e, st) {
      logException(e, st);
      emit(
        state.copyWith(
          actions: state.removeAction(
            DPAProcessBusyAction.requestingManualVerification,
          ),
          errors: state.addErrorFromException(
            action: DPAProcessBusyAction.requestingManualVerification,
            exception: e,
          ),
        ),
      );
    }
  }

  /// Emits the updated file progress when uploading a file.
  void _updateFileProgress({
    required DPAVariable variable,
    int? count,
    int? total,
  }) =>
      emit(
        state.copyWith(
          processingFiles: state.processingFiles
              .map(
                (data) => data.variableKey == variable.key
                    ? data.copyWith(
                        count: count,
                        total: total,
                      )
                    : data,
              )
              .toSet(),
        ),
      );
}

/// Extensions on [DPAProcess]
extension on DPAProcess {
  /// Retruns whether if the taks is a popUp or not.
  bool isPopUp() => stepProperties?.format == DPAStepFormat.popUp;
}
