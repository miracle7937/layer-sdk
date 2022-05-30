import 'package:bloc/bloc.dart';

import 'package:logging/logging.dart';

import '../../../../data_layer/data_layer.dart';
import '../../../../migration/data_layer/network.dart';
import '../../../business_layer.dart';

/// A cubit that manages a DPA process.
class DPAProcessCubit extends Cubit<DPAProcessState> {
  final _log = Logger('DPAProcessCubit');

  final DPARepository _repository;

  /// Creates a new cubit using the supplied [DPARepository].
  DPAProcessCubit({
    required DPARepository repository,
  })  : _repository = repository,
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
        actions: state.actions.union({
          DPAProcessBusyAction.starting,
        }),
        errorStatus: DPAProcessErrorStatus.none,
      ),
    );

    try {
      final process = instanceId != null
          ? await _resumeProcess(
              instanceId: instanceId,
            )
          : await _repository.startProcess(
              id: definitionId,
              variables: variables,
            );

      if (process != null) {
        emit(
          state.copyWith(
            process: process.isPopUp() ? null : process,
            popUp: process.isPopUp() ? process : null,
            clearPopUp: !process.isPopUp(),
            actions: state.actions.difference({
              DPAProcessBusyAction.starting,
            }),
            runStatus: process.finished
                ? DPAProcessRunStatus.finished
                : DPAProcessRunStatus.running,
            clearProcessingFiles: true,
          ),
        );
      } else {
        emit(
          state.copyWith(
            actions: state.actions.difference({
              DPAProcessBusyAction.starting,
            }),
            errorStatus: DPAProcessErrorStatus.network,
          ),
        );
      }
    } on NetException {
      emit(
        state.copyWith(
          actions: state.actions.difference({
            DPAProcessBusyAction.starting,
          }),
          errorStatus: DPAProcessErrorStatus.network,
        ),
      );
    }
  }

  Future<DPAProcess?> _resumeProcess({
    required String instanceId,
  }) async {
    final task = await _repository.getTask(
      processInstanceId: instanceId,
    );

    if (task != null) {
      final process = await _repository.resumeProcess(
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
        actions: state.actions.union({
          DPAProcessBusyAction.steppingBack,
        }),
        errorStatus: DPAProcessErrorStatus.none,
      ),
    );

    try {
      final process = await _repository.stepBack(
        process: state.activeProcess,
      );

      emit(
        state.copyWith(
          process: process.isPopUp() ? null : process,
          popUp: process.isPopUp() ? process : null,
          clearPopUp: !process.isPopUp(),
          actions: state.actions.difference({
            DPAProcessBusyAction.steppingBack,
          }),
          clearProcessingFiles: true,
        ),
      );
    } on NetException {
      emit(
        state.copyWith(
          actions: state.actions.difference({
            DPAProcessBusyAction.steppingBack,
          }),
          errorStatus: DPAProcessErrorStatus.network,
        ),
      );
    }
  }

  /// Proceeds to next step, or finishes the process if at the last one.
  Future<void> stepOrFinish({
    bool chosenValue = false,
  }) async {
    assert(state.runStatus == DPAProcessRunStatus.running);

    _log.info(
      'Stepping process with id ${state.activeProcess.task?.id}',
    );

    emit(
      state.copyWith(
        actions: state.actions.union({
          DPAProcessBusyAction.steppingForward,
        }),
        errorStatus: DPAProcessErrorStatus.none,
        chosenValue: chosenValue,
      ),
    );

    try {
      var process = state.activeProcess.validate();

      if (process.canProceed) {
        process = await _repository.stepOrFinishProcess(
          process: state.activeProcess,
          chosenValue: chosenValue,
        );
      }

      emit(
        state.copyWith(
          process: process.isPopUp() ? null : process,
          popUp: process.isPopUp() ? process : null,
          clearPopUp: !process.isPopUp(),
          actions: state.actions.difference({
            DPAProcessBusyAction.steppingForward,
          }),
          runStatus: process.finished ? DPAProcessRunStatus.finished : null,
          clearProcessingFiles: true,
        ),
      );
    } on NetException {
      emit(
        state.copyWith(
          actions: state.actions.difference({
            DPAProcessBusyAction.steppingForward,
          }),
          errorStatus: DPAProcessErrorStatus.network,
        ),
      );
    }
  }

  /// Cancels the ongoing process.
  Future<void> cancelProcess() async {
    assert(state.runStatus == DPAProcessRunStatus.running);

    _log.info('Cancelling process with id ${state.activeProcess.task?.id}');

    emit(
      state.copyWith(
        actions: state.actions.union({
          DPAProcessBusyAction.cancelling,
        }),
        errorStatus: DPAProcessErrorStatus.none,
      ),
    );

    try {
      final result = await _repository.cancelProcess(
        process: state.activeProcess,
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
            actions: state.actions.difference({
              DPAProcessBusyAction.cancelling,
            }),
            runStatus: DPAProcessRunStatus.finished,
            clearProcessingFiles: true,
          ),
        );
      }
    } on NetException {
      emit(
        state.copyWith(
          actions: state.actions.difference({
            DPAProcessBusyAction.cancelling,
          }),
          errorStatus: DPAProcessErrorStatus.network,
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
        actions: state.actions.union({
          DPAProcessBusyAction.updatingValue,
        }),
        errorStatus: DPAProcessErrorStatus.none,
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
        actions: state.actions.difference({
          DPAProcessBusyAction.updatingValue,
        }),
        errorStatus: DPAProcessErrorStatus.none,
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
        processingFiles: state.processingFiles.union({
          DPAProcessingFileData(
            action: DPAProcessingFileAction.uploading,
            variableKey: variable.key,
          ),
        }),
        errorStatus: DPAProcessErrorStatus.none,
      ),
    );

    try {
      final updatedVariable = await _repository.uploadImage(
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
          process: updatedProcess.isPopUp() ? null : updatedProcess,
          popUp: updatedProcess.isPopUp() ? updatedProcess : null,
          processingFiles: state.processingFiles
              .where((d) => d.variableKey != variable.key)
              .toSet(),
        ),
      );
    } on NetException {
      emit(
        state.copyWith(
          processingFiles: state.processingFiles
              .where((d) => d.variableKey != variable.key)
              .toSet(),
          errorStatus: DPAProcessErrorStatus.network,
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

    return _repository.downloadFile(
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
        processingFiles: state.processingFiles.union({
          DPAProcessingFileData(
            action: DPAProcessingFileAction.deleting,
            variableKey: variable.key,
          ),
        }),
        errorStatus: DPAProcessErrorStatus.none,
      ),
    );

    try {
      final updatedVariable = await _repository.deleteFile(
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
          process: updatedProcess.isPopUp() ? null : updatedProcess,
          popUp: updatedProcess.isPopUp() ? updatedProcess : null,
          processingFiles: state.processingFiles
              .where((d) => d.variableKey != variable.key)
              .toSet(),
        ),
      );
    } on NetException catch (e) {
      emit(
        state.copyWith(
          processingFiles: state.processingFiles
              .where((d) => d.variableKey != variable.key)
              .toSet(),
          errorStatus: DPAProcessErrorStatus.network,
          errorMessage: e.message,
        ),
      );
    }
  }

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

extension on DPAProcess {
  bool isPopUp() => stepProperties?.format == DPAStepFormat.popUp;
}
