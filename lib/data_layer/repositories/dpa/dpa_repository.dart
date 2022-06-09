import 'package:collection/collection.dart';
import 'package:logging/logging.dart';

import '../../../domain_layer/abstract_repositories.dart';
import '../../../domain_layer/models.dart';
import '../../dtos.dart';
import '../../mappings.dart';
import '../../network.dart';
import '../../providers.dart';

/// Handles all DPA data.
class DPARepository implements DPARepositoryInterface {
  final _log = Logger('DPARepository');

  final DPAProvider _provider;
  final CustomerProvider _customerProvider;

  /// Creates a new [DPARepository] with the supplied [DPAProvider] and
  /// [CustomerProvider].
  ///
  /// The [CustomerProvider] is used to get information about the customers.
  DPARepository(
    DPAProvider provider,
    CustomerProvider customerProvider,
  )   : _provider = provider,
        _customerProvider = customerProvider;

  DPAMappingCustomData get _createCustomData => DPAMappingCustomData(
        token: _provider.netClient.currentToken() ?? '',
        fileBaseURL: _provider.fileURLPrefix,
      );

  DPAMappingCustomData get _customerCustomData => DPAMappingCustomData(
        token: _provider.netClient.currentToken() ?? '',
        fileBaseURL: _provider.customerDocumentsURLPrefix,
      );

  /// Lists the process definitions that can be started by the logged in user.
  ///
  /// When [filterSuspended] is `true`, the list will not include any
  /// process marked as suspended. Defaults to `true`.
  ///
  /// When [onlyLatestVersions] is `true`, we will remove all processes that
  /// have the same key, leaving only the one with the highest version number.
  /// Defaults to `true`.
  Future<List<DPAProcessDefinition>> listProcessDefinitions({
    bool filterSuspended = true,
    bool onlyLatestVersions = true,
    bool forceRefresh = false,
  }) async {
    _log.finest('Fetching DPA processes. Filter suspended? $filterSuspended.'
        ' Only latest versions? $onlyLatestVersions');

    final processDTOs = onlyLatestVersions
        ? await _provider.listLatestProcesses(
            forceRefresh: forceRefresh,
          )
        : await _provider.listProcesses(
            forceRefresh: forceRefresh,
          );

    var processes = processDTOs.map((e) => e.toDPAProcessDefinition()).toList();

    if (filterSuspended) {
      processes = processes.where((e) => !(e.suspended ?? false)).toList();
    }

    if (onlyLatestVersions) {
      processes = processes
          .where(
            (a) =>
                a.version != null &&
                processes.firstWhereOrNull(
                      (b) =>
                          a.key == b.key &&
                          b.version != null &&
                          a.version! < b.version!,
                    ) ==
                    null,
          )
          .toList();
    }

    return processes;
  }

  /// Lists all the tasks not assigned to anyone.
  ///
  /// If the [customerId] is passed, this will return only the tasks related
  /// to the customer id.
  ///
  /// [fetchCustomersData] fetches the data for each task customer if true,
  /// which is the default.
  ///
  /// If [forceRefresh] is set to true, the cache will be skipped only
  /// when fetching the list.
  Future<List<DPATask>> listUnassignedTasks({
    bool fetchCustomersData = true,
    bool forceRefresh = false,
    String? customerId,
  }) async {
    _log.finest('Fetching unassigned tasks.');

    final deviceDTOs = await _provider.unassignedTasks(
      forceRefresh: forceRefresh,
      customerId: customerId,
    );

    return _mapToTask(
      dtos: deviceDTOs,
      fetchCustomersData: fetchCustomersData,
      forceRefresh: forceRefresh,
    );
  }

  /// Returns the current task of the process matching provided id.
  Future<DPATask?> getTask({
    required String processInstanceId,
    bool forceRefresh = false,
  }) async {
    _log.finest('Fetching task by process instance id');

    final dto = await _provider.getTask(
      processInstanceId: processInstanceId,
      forceRefresh: forceRefresh,
    );

    return dto?.toDPATask(_createCustomData);
  }

  /// Lists all tasks assigned to the user.
  ///
  /// If the [customerId] is passed, this will return only the tasks related
  /// to the customer id.
  ///
  /// An optional [status] can be passed to filter the tasks.
  ///
  /// [fetchCustomersData] fetches the data for each task customer if true,
  /// which is the default.
  ///
  /// If [forceRefresh] is set to true, the cache will be skipped only
  /// when fetching the list.
  Future<List<DPATask>> listUserTasks({
    String? customerId,
    DPAStatus? status,
    bool fetchCustomersData = true,
    bool forceRefresh = false,
  }) async {
    _log.finest('Fetching user tasks');

    final deviceDTOs = await _provider.userTasks(
      forceRefresh: forceRefresh,
      customerId: customerId,
      status: status?.toDPAStatusDTO(),
    );

    return _mapToTask(
      dtos: deviceDTOs,
      fetchCustomersData: fetchCustomersData,
      forceRefresh: forceRefresh,
    );
  }

  /// Lists all previous tasks.
  ///
  /// [fetchCustomersData] fetches the data for each task customer if true,
  /// which is the default.
  ///
  /// If force refresh is set to true, the cache will be skipped only
  /// when fetching the list.
  Future<List<DPATask>> listHistory({
    bool fetchCustomersData = true,
    bool forceRefresh = false,
  }) async {
    _log.finest('Fetching history tasks');

    final deviceDTOs = await _provider.historyTasks(
      forceRefresh: forceRefresh,
    );

    return _mapToTask(
      dtos: deviceDTOs,
      fetchCustomersData: fetchCustomersData,
      forceRefresh: forceRefresh,
    );
  }

  /// Called by the list methods to map the task dto list to a task list, and
  /// to optionally populate the information we need from the customers that
  /// does not come from the backend by default.
  Future<List<DPATask>> _mapToTask({
    required Iterable<DPATaskDTO> dtos,
    required bool fetchCustomersData,
    required bool forceRefresh,
  }) async {
    if (!fetchCustomersData) {
      return dtos.map((e) => e.toDPATask(_createCustomData)).toList();
    }

    final ids = <String>[];

    for (var e in dtos) {
      if (e.processOwner != null &&
          e.processOwner != 'non_customer' &&
          !ids.contains(e.processOwner)) {
        ids.add(e.processOwner!);
      }
    }

    _log.finest('Fetching data for customers: $ids');

    final customers = (await _customerProvider.customers(
      customerIds: ids,
      forceRefresh: forceRefresh,
    ))
        .map((e) => e.toCustomer(_customerCustomData))
        .toList();

    _log.finest('Done fetching customer data. '
        '${customers.length} customers loaded.');

    return dtos
        .map(
          (e) => e.toDPATask(_createCustomData).copyWith(
                customer: customers.firstWhereOrNull(
                  (c) => c.id == e.processOwner,
                ),
              ),
        )
        .toList();
  }

  /// Claims a task for the current user.
  ///
  /// Returns true if succeeded.
  Future<bool> claimTask({
    required String taskId,
  }) {
    _log.finest('Claiming task $taskId.');

    return _provider.claim(taskId: taskId);
  }

  /// Pass the task to finish it.
  ///
  /// Returns `true` if successful.
  Future<bool> finishTask({
    required DPATask task,
  }) {
    _log.finest('Finishing task id ${task.id}');

    return _provider.finishTask(
      taskDTO: task.toDPATaskDTO(),
    );
  }

  /// Starts a new DPA process. using the given id, and the optional
  /// variables.
  ///
  /// Returns a [DPAProcess] with the first step of this process.
  Future<DPAProcess> startProcess({
    required String id,
    List<DPAVariable> variables = const [],
  }) async {
    _log.finest('Starting process id $id');

    final dto = await _provider.startProcess(
      id: id,
      variables: variables.toDPAVariableDTOList(),
    );

    return dto.toDPAProcess(_createCustomData);
  }

  /// Resumes an ongoing DPA process using the given id.
  ///
  /// Returns a [DPAProcess] with the current step of the process.
  Future<DPAProcess> resumeProcess({
    required String id,
  }) async {
    _log.finest('Resuming process with id $id');

    final dto = await _provider.resumeProcess(
      id: id,
    );

    return dto.toDPAProcess(_createCustomData);
  }

  /// Returns to the previous step of  the given [DPAProcess].
  ///
  /// Returns another [DPAProcess] detailing the step the process is now.
  Future<DPAProcess> stepBack({
    required DPAProcess process,
  }) async {
    _log.finest('Stepping back process with task id ${process.task?.id}');

    final dto = await _provider.stepBack(
      process: process.toDPAProcessDTO(),
    );

    return dto.toDPAProcess(
      _createCustomData,
      currentProcess: process,
    );
  }

  /// Advances the given [DPAProcess] to the next step, or, in case it's already
  /// on the final step, finish it.
  ///
  /// Returns another [DPAProcess] detailing the step the process is now.
  Future<DPAProcess> stepOrFinishProcess({
    required DPAProcess process,
    bool chosenValue = false,
  }) async {
    _log.finest('Stepping/Finishing process with task id ${process.task?.id}');

    final dto = await _provider.stepOrFinishProcess(
      process: process.toDPAProcessDTO(),
      chosenValue: chosenValue,
    );

    return dto.toDPAProcess(
      _createCustomData,
      currentProcess: process,
    );
  }

  /// Cancels the given [DPAProcess].
  ///
  /// Returns `true` if succeeded.
  Future<bool> cancelProcess({
    required DPAProcess process,
  }) {
    _log.finest('Cancelling process with task id ${process.task?.id}');

    return _provider.deleteProcess(
      process: process.toDPAProcessDTO(),
    );
  }

  /// Upload an image (a document, or a user signature, for instance) for the
  /// DPA process variable.
  ///
  /// The variable needs to have a key set and required a file to complete.
  ///
  /// Returns the variable updated with a [DPAFileData].
  /// This helps in doing the validation of the DPA variables, and is not
  /// uploaded to the server for variables.
  ///
  /// The optional [onProgress] can be used to track the upload progress.
  Future<DPAVariable> uploadImage({
    required DPAProcess process,
    required DPAVariable variable,
    required String imageName,
    required int imageFileSizeBytes,
    required String imageBase64Data,
    NetProgressCallback? onProgress,
  }) async {
    assert(variable.type.shouldUploadFile);
    assert(variable.key.isNotEmpty);

    _log.finest(
      'Uploading image for variable ${variable.id}'
      ' with key ${variable.key}'
      ' on process with task id ${process.task?.id}',
    );

    try {
      final processDTO = process.toDPAProcessDTO();

      final result = await _provider.uploadImage(
        process: processDTO,
        key: variable.key,
        imageName: imageName,
        imageBase64Data: imageBase64Data,
        onProgress: onProgress,
      );

      if (!result) return variable;

      _log.finest(
        'Finished uploading for variable ${variable.id}'
        ' with key ${variable.key}'
        ': ${_provider.imageDownloadURL(
          process: processDTO,
          key: variable.key,
        )}',
      );

      return variable.validateAndCopyWith(
        value: DPAFileData(
          name: imageName,
          size: imageFileSizeBytes,
        ),
      );
    } on Exception catch (e) {
      _log.severe('Error uploading image: $e');

      return variable;
    }
  }

  /// Downloads a base64 encoded file from the server.
  ///
  /// Returns null if the download fails.
  Future<String?> downloadFile({
    required DPAProcess process,
    required DPAVariable variable,
    NetProgressCallback? onProgress,
  }) async {
    assert(variable.key.isNotEmpty);

    try {
      final dto = process.toDPAProcessDTO();

      return _provider.downloadFile(
        process: dto,
        key: variable.key,
        progressCallback: onProgress,
      );
    } on Exception catch (e) {
      _log.severe('Error downloading file: $e');

      return null;
    }
  }

  /// Deletes an uploaded file/image on the server.
  ///
  /// Returns an updated [DPAVariable], or throws a [NetException] if could
  /// not delete the file.
  Future<DPAVariable> deleteFile({
    required DPAProcess process,
    required DPAVariable variable,
    NetProgressCallback? onProgress,
  }) async {
    assert(variable.key.isNotEmpty);

    try {
      final dto = process.toDPAProcessDTO();

      await _provider.deleteFile(
        process: dto,
        key: variable.key,
        progressCallback: onProgress,
      );

      return variable.copyWith(clearValue: true);
    } on NetException {
      rethrow;
    }
  }
}
