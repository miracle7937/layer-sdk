import 'package:bloc_test/bloc_test.dart';
import 'package:equatable/equatable.dart';
import 'package:layer_sdk/_migration/business_layer/business_layer.dart';
import 'package:layer_sdk/_migration/data_layer/data_layer.dart';
import 'package:layer_sdk/data_layer/network.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockDPARepository extends Mock implements DPARepository {}

final MockDPARepository _repo = MockDPARepository();

final _successId = '1';
final _successKey = 'success';
final _failureId = '2';
final _successProcessInstanceId = '_successProcessInstanceId';
final _taskEmptyProcessInstanceId = '_taskEmptyProcessInstanceId';
final _taskFailureProcessInstanceId = '_taskFailureProcessInstanceId';
final _resumeFailureProcessInstanceId = '_variablesFailureProcessInstanceId';

final _mockedVariable = DPAVariable(
  id: _successId,
  key: _successKey,
  property: DPAVariableProperty(),
);

final _mockedProcessIds = List.generate(5, (index) => index.toString());

final _mockedSuccessProcess = DPAProcess(
  task: DPATask(
    id: _successId,
    name: 'Success',
    previousTasksIds: _mockedProcessIds,
    status: DPAStatus.active,
  ),
  variables: [_mockedVariable],
);

final _mockedFinishedProcess = _mockedSuccessProcess.copyWith(
  finished: true,
);

final _mockedFailureProcess = _mockedSuccessProcess.copyWith(
  finished: true,
  task: DPATask(
    id: _failureId,
    name: 'failure',
    previousTasksIds: _mockedProcessIds,
    status: DPAStatus.active,
  ),
);

void main() {
  EquatableConfig.stringify = true;

  blocTest<DPAProcessCubit, DPAProcessState>(
    'Starts with empty state',
    build: () => DPAProcessCubit(
      repository: _repo,
    ),
    verify: (c) => expect(c.state, DPAProcessState()),
  );

  group('Start process tests', _startTests);
  group('Resume process tests', _resumeTests);
  group('Step back tests', _stepBackTests);
  group('Step or finish tests', _stepOrFinishTests);
  group('Cancel process tests', _cancelProcess);
  group('Update value tests', _updateValue);
  group('Upload images tests', _uploadImagesTests);
  group('Delete file tests', _deleteFileTests);
}

void _startTests() {
  setUp(() {
    when(
      () => _repo.startProcess(
        id: _successId,
        variables: any(named: 'variables'),
      ),
    ).thenAnswer(
      (_) async => _mockedSuccessProcess,
    );

    when(
      () => _repo.startProcess(
        id: _failureId,
        variables: any(named: 'variables'),
      ),
    ).thenAnswer(
      (_) async => throw NetException(message: 'Some error'),
    );
  });

  blocTest<DPAProcessCubit, DPAProcessState>(
    'Start starts a new process successfully',
    build: () => DPAProcessCubit(
      repository: _repo,
    ),
    act: (c) => c.start(
      definitionId: _successId,
      variables: [],
    ),
    expect: () => [
      DPAProcessState(
        actions: {DPAProcessBusyAction.starting},
        errorStatus: DPAProcessErrorStatus.none,
      ),
      DPAProcessState(
        process: _mockedSuccessProcess,
        runStatus: DPAProcessRunStatus.running,
        errorStatus: DPAProcessErrorStatus.none,
      ),
    ],
    verify: (c) => verify(
      () => _repo.startProcess(
        id: _successId,
        variables: any(named: 'variables'),
      ),
    ).called(1),
  );

  blocTest<DPAProcessCubit, DPAProcessState>(
    'Start emits error on network failure',
    build: () => DPAProcessCubit(
      repository: _repo,
    ),
    act: (c) => c.start(
      definitionId: _failureId,
      variables: [],
    ),
    expect: () => [
      DPAProcessState(
        actions: {DPAProcessBusyAction.starting},
        errorStatus: DPAProcessErrorStatus.none,
      ),
      DPAProcessState(
        errorStatus: DPAProcessErrorStatus.network,
      ),
    ],
    verify: (c) => verify(
      () => _repo.startProcess(
        id: _failureId,
        variables: any(named: 'variables'),
      ),
    ).called(1),
  );
}

void _resumeTests() {
  setUp(() {
    when(
      () => _repo.getTask(processInstanceId: _successProcessInstanceId),
    ).thenAnswer((_) async => _mockedSuccessProcess.task);

    when(
      () => _repo.getTask(processInstanceId: _taskEmptyProcessInstanceId),
    ).thenAnswer((_) async => null);

    when(
      () => _repo.getTask(processInstanceId: _taskFailureProcessInstanceId),
    ).thenThrow(NetException(message: 'Some error'));

    when(
      () => _repo.getTask(processInstanceId: _resumeFailureProcessInstanceId),
    ).thenAnswer((_) async => _mockedFailureProcess.task);

    when(
      () => _repo.resumeProcess(id: _successId),
    ).thenAnswer((_) async => _mockedSuccessProcess);

    when(
      () => _repo.resumeProcess(id: _failureId),
    ).thenThrow(NetException(message: 'Some error'));
  });

  blocTest<DPAProcessCubit, DPAProcessState>(
    'Start resumes a new process successfully',
    build: () => DPAProcessCubit(
      repository: _repo,
    ),
    act: (c) => c.start(
      definitionId: _successId,
      instanceId: _successProcessInstanceId,
      variables: [],
    ),
    expect: () => [
      DPAProcessState(
        actions: {DPAProcessBusyAction.starting},
        errorStatus: DPAProcessErrorStatus.none,
      ),
      DPAProcessState(
        process: _mockedSuccessProcess,
        runStatus: DPAProcessRunStatus.running,
        errorStatus: DPAProcessErrorStatus.none,
      ),
    ],
    verify: (c) {
      verify(
        () => _repo.getTask(
          processInstanceId: _successProcessInstanceId,
        ),
      ).called(1);

      verify(
        () => _repo.resumeProcess(
          id: _successId,
        ),
      ).called(1);
    },
  );

  blocTest<DPAProcessCubit, DPAProcessState>(
    'Start emits a network error when no task is returned',
    build: () => DPAProcessCubit(
      repository: _repo,
    ),
    act: (c) => c.start(
      definitionId: _successId,
      instanceId: _taskEmptyProcessInstanceId,
      variables: [],
    ),
    expect: () => [
      DPAProcessState(
        actions: {DPAProcessBusyAction.starting},
        errorStatus: DPAProcessErrorStatus.none,
      ),
      DPAProcessState(
        errorStatus: DPAProcessErrorStatus.network,
      ),
    ],
    verify: (c) {
      verify(
        () => _repo.getTask(
          processInstanceId: _taskEmptyProcessInstanceId,
        ),
      ).called(1);

      return verifyNever(
        () => _repo.resumeProcess(
          id: _successId,
        ),
      );
    },
  );

  blocTest<DPAProcessCubit, DPAProcessState>(
    'Start emits a network error when getTask fails',
    build: () => DPAProcessCubit(
      repository: _repo,
    ),
    act: (c) => c.start(
      definitionId: _successId,
      instanceId: _taskFailureProcessInstanceId,
      variables: [],
    ),
    expect: () => [
      DPAProcessState(
        actions: {DPAProcessBusyAction.starting},
        errorStatus: DPAProcessErrorStatus.none,
      ),
      DPAProcessState(
        errorStatus: DPAProcessErrorStatus.network,
      ),
    ],
    verify: (c) {
      verify(
        () => _repo.getTask(
          processInstanceId: _taskFailureProcessInstanceId,
        ),
      ).called(1);

      return verifyNever(
        () => _repo.resumeProcess(
          id: _successId,
        ),
      );
    },
  );

  blocTest<DPAProcessCubit, DPAProcessState>(
    'Start emits a network error when resume fails',
    build: () => DPAProcessCubit(
      repository: _repo,
    ),
    act: (c) => c.start(
      definitionId: _successId,
      instanceId: _resumeFailureProcessInstanceId,
      variables: [],
    ),
    expect: () => [
      DPAProcessState(
        actions: {DPAProcessBusyAction.starting},
        errorStatus: DPAProcessErrorStatus.none,
      ),
      DPAProcessState(
        errorStatus: DPAProcessErrorStatus.network,
      ),
    ],
    verify: (c) {
      verify(
        () => _repo.getTask(
          processInstanceId: _resumeFailureProcessInstanceId,
        ),
      ).called(1);

      return verify(
        () => _repo.resumeProcess(
          id: _failureId,
        ),
      ).called(1);
    },
  );
}

void _stepBackTests() {
  setUp(() {
    when(
      () => _repo.stepBack(process: _mockedSuccessProcess),
    ).thenAnswer(
      (_) async => _mockedSuccessProcess,
    );

    when(
      () => _repo.stepBack(process: _mockedFailureProcess),
    ).thenAnswer(
      (_) async => throw NetException(message: 'Some error'),
    );
  });

  blocTest<DPAProcessCubit, DPAProcessState>(
    'Step back emits correct action after successfully stepping back',
    build: () => DPAProcessCubit(
      repository: _repo,
    ),
    act: (c) => c.stepBack(),
    seed: () => DPAProcessState(
      process: _mockedSuccessProcess,
      runStatus: DPAProcessRunStatus.running,
    ),
    expect: () => [
      DPAProcessState(
        process: _mockedSuccessProcess,
        actions: {DPAProcessBusyAction.steppingBack},
        runStatus: DPAProcessRunStatus.running,
        errorStatus: DPAProcessErrorStatus.none,
      ),
      DPAProcessState(
        process: _mockedSuccessProcess,
        runStatus: DPAProcessRunStatus.running,
        errorStatus: DPAProcessErrorStatus.none,
      ),
    ],
    verify: (c) => verify(
      () => _repo.stepBack(
        process: _mockedSuccessProcess,
      ),
    ).called(1),
  );

  blocTest<DPAProcessCubit, DPAProcessState>(
    'Step back emits error on network failure',
    build: () => DPAProcessCubit(
      repository: _repo,
    ),
    act: (c) => c.stepBack(),
    seed: () => DPAProcessState(
      process: _mockedFailureProcess,
      runStatus: DPAProcessRunStatus.running,
    ),
    expect: () => [
      DPAProcessState(
        process: _mockedFailureProcess,
        actions: {DPAProcessBusyAction.steppingBack},
        runStatus: DPAProcessRunStatus.running,
        errorStatus: DPAProcessErrorStatus.none,
      ),
      DPAProcessState(
        process: _mockedFailureProcess,
        runStatus: DPAProcessRunStatus.running,
        errorStatus: DPAProcessErrorStatus.network,
      ),
    ],
    verify: (c) => verify(
      () => _repo.stepBack(
        process: _mockedFailureProcess,
      ),
    ).called(1),
  );
}

void _stepOrFinishTests() {
  setUp(() {
    when(
      () => _repo.stepOrFinishProcess(process: _mockedSuccessProcess),
    ).thenAnswer(
      (_) async => _mockedSuccessProcess,
    );

    when(
      () => _repo.stepOrFinishProcess(process: _mockedFinishedProcess),
    ).thenAnswer(
      (_) async => _mockedFinishedProcess,
    );

    when(
      () => _repo.stepOrFinishProcess(process: _mockedFailureProcess),
    ).thenAnswer(
      (_) async => throw NetException(message: 'Some error'),
    );
  });

  blocTest<DPAProcessCubit, DPAProcessState>(
    'Emits correct action after successfully stepping forward',
    build: () => DPAProcessCubit(
      repository: _repo,
    ),
    act: (c) => c.stepOrFinish(),
    seed: () => DPAProcessState(
      process: _mockedSuccessProcess,
      runStatus: DPAProcessRunStatus.running,
    ),
    expect: () => [
      DPAProcessState(
        process: _mockedSuccessProcess,
        actions: {DPAProcessBusyAction.steppingForward},
        runStatus: DPAProcessRunStatus.running,
        errorStatus: DPAProcessErrorStatus.none,
      ),
      DPAProcessState(
        process: _mockedSuccessProcess,
        runStatus: DPAProcessRunStatus.running,
        errorStatus: DPAProcessErrorStatus.none,
      ),
    ],
    verify: (c) => verify(
      () => _repo.stepOrFinishProcess(
        process: _mockedSuccessProcess,
      ),
    ).called(1),
  );

  blocTest<DPAProcessCubit, DPAProcessState>(
    'Emits correct action after successfully finishing',
    build: () => DPAProcessCubit(
      repository: _repo,
    ),
    act: (c) => c.stepOrFinish(),
    seed: () => DPAProcessState(
      process: _mockedFinishedProcess,
      runStatus: DPAProcessRunStatus.running,
    ),
    expect: () => [
      DPAProcessState(
        process: _mockedFinishedProcess,
        actions: {DPAProcessBusyAction.steppingForward},
        runStatus: DPAProcessRunStatus.running,
        errorStatus: DPAProcessErrorStatus.none,
      ),
      DPAProcessState(
        process: _mockedFinishedProcess,
        runStatus: DPAProcessRunStatus.finished,
        errorStatus: DPAProcessErrorStatus.none,
      ),
    ],
    verify: (c) => verify(
      () => _repo.stepOrFinishProcess(
        process: _mockedFinishedProcess,
      ),
    ).called(1),
  );

  blocTest<DPAProcessCubit, DPAProcessState>(
    'Emits correct error on network failure',
    build: () => DPAProcessCubit(
      repository: _repo,
    ),
    act: (c) => c.stepOrFinish(),
    seed: () => DPAProcessState(
      process: _mockedFailureProcess,
      runStatus: DPAProcessRunStatus.running,
    ),
    expect: () => [
      DPAProcessState(
        process: _mockedFailureProcess,
        actions: {DPAProcessBusyAction.steppingForward},
        runStatus: DPAProcessRunStatus.running,
        errorStatus: DPAProcessErrorStatus.none,
      ),
      DPAProcessState(
        process: _mockedFailureProcess,
        runStatus: DPAProcessRunStatus.running,
        errorStatus: DPAProcessErrorStatus.network,
      ),
    ],
    verify: (c) => verify(
      () => _repo.stepOrFinishProcess(
        process: _mockedFailureProcess,
      ),
    ).called(1),
  );
}

void _cancelProcess() {
  setUp(() {
    when(
      () => _repo.cancelProcess(process: _mockedFinishedProcess),
    ).thenAnswer(
      (_) async => true,
    );

    when(
      () => _repo.cancelProcess(process: _mockedFailureProcess),
    ).thenAnswer(
      (_) async => throw NetException(message: 'Some error'),
    );
  });

  blocTest<DPAProcessCubit, DPAProcessState>(
    'Emits correct action after successfully cancelling',
    build: () => DPAProcessCubit(
      repository: _repo,
    ),
    act: (c) => c.cancelProcess(),
    seed: () => DPAProcessState(
      process: _mockedFinishedProcess,
      runStatus: DPAProcessRunStatus.running,
    ),
    expect: () => [
      DPAProcessState(
        process: _mockedFinishedProcess,
        actions: {DPAProcessBusyAction.cancelling},
        runStatus: DPAProcessRunStatus.running,
        errorStatus: DPAProcessErrorStatus.none,
      ),
      DPAProcessState(
        process: _mockedFinishedProcess.copyWith(
          status: DPAStatus.cancelled,
        ),
        runStatus: DPAProcessRunStatus.finished,
        errorStatus: DPAProcessErrorStatus.none,
      ),
    ],
    verify: (c) => verify(
      () => _repo.cancelProcess(
        process: _mockedFinishedProcess,
      ),
    ).called(1),
  );

  blocTest<DPAProcessCubit, DPAProcessState>(
    'Emits correct error on network failure',
    build: () => DPAProcessCubit(
      repository: _repo,
    ),
    act: (c) => c.cancelProcess(),
    seed: () => DPAProcessState(
      process: _mockedFailureProcess,
      runStatus: DPAProcessRunStatus.running,
    ),
    expect: () => [
      DPAProcessState(
        process: _mockedFailureProcess,
        actions: {DPAProcessBusyAction.cancelling},
        runStatus: DPAProcessRunStatus.running,
        errorStatus: DPAProcessErrorStatus.none,
      ),
      DPAProcessState(
        process: _mockedFailureProcess,
        runStatus: DPAProcessRunStatus.running,
        errorStatus: DPAProcessErrorStatus.network,
      ),
    ],
    verify: (c) => verify(
      () => _repo.cancelProcess(
        process: _mockedFailureProcess,
      ),
    ).called(1),
  );
}

void _updateValue() {
  final expectedUpdatedVariable = _mockedVariable.copyWith(
    value: _failureId,
  );

  blocTest<DPAProcessCubit, DPAProcessState>(
    'Emits new state with the new variable value',
    build: () => DPAProcessCubit(
      repository: _repo,
    ),
    act: (c) => c.updateValue(
      variable: _mockedVariable,
      newValue: _failureId,
    ),
    seed: () => DPAProcessState(
      process: _mockedSuccessProcess,
      runStatus: DPAProcessRunStatus.running,
    ),
    expect: () => [
      DPAProcessState(
        process: _mockedSuccessProcess,
        actions: {DPAProcessBusyAction.updatingValue},
        runStatus: DPAProcessRunStatus.running,
        errorStatus: DPAProcessErrorStatus.none,
      ),
      DPAProcessState(
        process: _mockedSuccessProcess.copyWith(
          variables: [
            expectedUpdatedVariable,
          ],
        ),
        runStatus: DPAProcessRunStatus.running,
        errorStatus: DPAProcessErrorStatus.none,
      ),
    ],
  );
}

void _uploadImagesTests() {
  final _imageName = 'TEST.JPG';
  final _imageSize = 300;
  final _imageBase64Data = 'Data for the image';

  final _updatedVariable = _mockedVariable.copyWith(
    value: DPAFileData(
      name: _imageName,
      size: _imageSize,
    ),
  );

  final _existingUploadData = DPAProcessingFileData(
    action: DPAProcessingFileAction.uploading,
    variableKey: 'other',
    count: 10,
    total: 100,
  );

  setUp(() {
    when(
      () => _repo.uploadImage(
        process: _mockedSuccessProcess,
        variable: _mockedVariable,
        imageName: _imageName,
        imageFileSizeBytes: _imageSize,
        imageBase64Data: _imageBase64Data,
        onProgress: any(named: 'onProgress'),
      ),
    ).thenAnswer(
      (_) async => _updatedVariable,
    );

    when(
      () => _repo.uploadImage(
        process: _mockedFailureProcess,
        variable: _mockedVariable,
        imageName: _imageName,
        imageFileSizeBytes: _imageSize,
        imageBase64Data: _imageBase64Data,
        onProgress: any(named: 'onProgress'),
      ),
    ).thenAnswer(
      (_) async => throw NetException(message: 'Some error'),
    );
  });

  blocTest<DPAProcessCubit, DPAProcessState>(
    'Emits updated upload data when upload completes',
    build: () => DPAProcessCubit(
      repository: _repo,
    ),
    act: (c) => c.uploadImage(
      variable: _mockedVariable,
      filename: _imageName,
      fileSizeBytes: _imageSize,
      fileBase64Data: _imageBase64Data,
    ),
    seed: () => DPAProcessState(
      process: _mockedSuccessProcess,
      processingFiles: {
        _existingUploadData,
      },
      runStatus: DPAProcessRunStatus.running,
    ),
    expect: () => [
      DPAProcessState(
        process: _mockedSuccessProcess,
        processingFiles: {
          _existingUploadData,
          DPAProcessingFileData(
            action: DPAProcessingFileAction.uploading,
            variableKey: _mockedVariable.key,
          ),
        },
        runStatus: DPAProcessRunStatus.running,
        errorStatus: DPAProcessErrorStatus.none,
      ),
      DPAProcessState(
        process: _mockedSuccessProcess.copyWith(
          variables: [
            _updatedVariable,
          ],
        ),
        processingFiles: {
          _existingUploadData,
        },
        runStatus: DPAProcessRunStatus.running,
        errorStatus: DPAProcessErrorStatus.none,
      ),
    ],
    verify: (c) => verify(
      () => _repo.uploadImage(
        process: _mockedSuccessProcess,
        variable: _mockedVariable,
        imageName: _imageName,
        imageFileSizeBytes: _imageSize,
        imageBase64Data: _imageBase64Data,
        onProgress: any(named: 'onProgress'),
      ),
    ).called(1),
  );

  blocTest<DPAProcessCubit, DPAProcessState>(
    'Emits correct error on network failure',
    build: () => DPAProcessCubit(
      repository: _repo,
    ),
    act: (c) => c.uploadImage(
      variable: _mockedVariable,
      filename: _imageName,
      fileSizeBytes: _imageSize,
      fileBase64Data: _imageBase64Data,
    ),
    seed: () => DPAProcessState(
      process: _mockedFailureProcess,
      runStatus: DPAProcessRunStatus.running,
    ),
    expect: () => [
      DPAProcessState(
        process: _mockedFailureProcess,
        processingFiles: {
          DPAProcessingFileData(
            action: DPAProcessingFileAction.uploading,
            variableKey: _mockedVariable.key,
          ),
        },
        runStatus: DPAProcessRunStatus.running,
        errorStatus: DPAProcessErrorStatus.none,
      ),
      DPAProcessState(
        process: _mockedFailureProcess,
        runStatus: DPAProcessRunStatus.running,
        errorStatus: DPAProcessErrorStatus.network,
      ),
    ],
    verify: (c) => verify(
      () => _repo.uploadImage(
        process: _mockedFailureProcess,
        variable: _mockedVariable,
        imageName: _imageName,
        imageFileSizeBytes: _imageSize,
        imageBase64Data: _imageBase64Data,
        onProgress: any(named: 'onProgress'),
      ),
    ).called(1),
  );
}

void _deleteFileTests() {
  final _deleteFileName = 'DOCUMENT.PDF';
  final _deleteFileSize = 4500;

  final _variableToDelete = _mockedVariable.copyWith(
    value: DPAFileData(
      name: _deleteFileName,
      size: _deleteFileSize,
    ),
  );

  final _failureId = 'Error ID';
  final _failureKey = 'ErrorKey';
  final _errorMessage = 'File does not exist';

  final _errorVariable = DPAVariable(
    id: _failureId,
    key: _failureKey,
    property: DPAVariableProperty(),
  );

  final _variableToThrow = _errorVariable.copyWith(
    value: DPAFileData(
      name: _deleteFileName,
      size: _deleteFileSize,
    ),
  );

  final _initialSuccessProcess = _mockedSuccessProcess.copyWith(
    variables: [_variableToDelete],
  );

  final _initialErrorProcess = _mockedSuccessProcess.copyWith(
    variables: [_variableToThrow],
  );

  setUp(() {
    when(
      () => _repo.deleteFile(
        process: _initialSuccessProcess,
        variable: _variableToDelete,
        onProgress: any(named: 'onProgress'),
      ),
    ).thenAnswer(
      (_) async => _mockedVariable,
    );

    when(
      () => _repo.deleteFile(
        process: _initialErrorProcess,
        variable: _variableToThrow,
        onProgress: any(named: 'onProgress'),
      ),
    ).thenAnswer(
      (_) async => throw NetException(message: _errorMessage),
    );
  });

  blocTest<DPAProcessCubit, DPAProcessState>(
    'Emits updated variable when file is deleted',
    build: () => DPAProcessCubit(
      repository: _repo,
    ),
    act: (c) => c.deleteFile(
      variable: _variableToDelete,
    ),
    seed: () => DPAProcessState(
      process: _initialSuccessProcess,
      runStatus: DPAProcessRunStatus.running,
    ),
    expect: () => [
      DPAProcessState(
        process: _initialSuccessProcess,
        processingFiles: {
          DPAProcessingFileData(
            action: DPAProcessingFileAction.deleting,
            variableKey: _mockedVariable.key,
          ),
        },
        runStatus: DPAProcessRunStatus.running,
        errorStatus: DPAProcessErrorStatus.none,
      ),
      DPAProcessState(
        process: _mockedSuccessProcess,
        runStatus: DPAProcessRunStatus.running,
        errorStatus: DPAProcessErrorStatus.none,
      ),
    ],
    verify: (c) => verify(
      () => _repo.deleteFile(
        process: _initialSuccessProcess,
        variable: _variableToDelete,
        onProgress: any(named: 'onProgress'),
      ),
    ).called(1),
  ); // Emits updated variable when file is deleted

  blocTest<DPAProcessCubit, DPAProcessState>(
    'Emits correct error on delete exception',
    build: () => DPAProcessCubit(
      repository: _repo,
    ),
    act: (c) => c.deleteFile(
      variable: _variableToThrow,
    ),
    seed: () => DPAProcessState(
      process: _initialErrorProcess,
      runStatus: DPAProcessRunStatus.running,
    ),
    expect: () => [
      DPAProcessState(
        process: _initialErrorProcess,
        processingFiles: {
          DPAProcessingFileData(
            action: DPAProcessingFileAction.deleting,
            variableKey: _variableToThrow.key,
          ),
        },
        runStatus: DPAProcessRunStatus.running,
        errorStatus: DPAProcessErrorStatus.none,
      ),
      DPAProcessState(
        process: _initialErrorProcess,
        runStatus: DPAProcessRunStatus.running,
        errorStatus: DPAProcessErrorStatus.network,
        errorMessage: _errorMessage,
      ),
    ],
    verify: (c) => verify(
      () => _repo.deleteFile(
        process: _initialErrorProcess,
        variable: _variableToThrow,
        onProgress: any(named: 'onProgress'),
      ),
    ).called(1),
  ); // Emits correct error on delete exception
}
