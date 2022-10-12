import 'package:dio/dio.dart';

import '../../../../data_layer/network.dart';
import '../../dtos.dart';
import '../../environment.dart';

/// Provides DPA data.
class DPAProvider {
  /// The NetClient to use for the network requests
  final NetClient netClient;

  /// Creates a new [DPAProvider] with the given netClient.
  DPAProvider({
    required this.netClient,
  });

  /// Returns a list of the processes that can be started by the user.
  Future<List<DPAProcessDefinitionDTO>> listProcesses({
    bool forceRefresh = false,
  }) async {
    final response = await netClient.request(
      netClient.netEndpoints.listProcessesWithVersions,
      method: NetRequestMethods.get,
      forceRefresh: forceRefresh,
    );

    return List<Map<String, dynamic>>.from(response.data)
        .map(
          (item) => DPAProcessDefinitionDTO.fromJson(item['definition']),
        )
        .toList();
  }

  /// Returns an array, if the array is not empty, then the
  /// user has a visa verification application already sent
  /// to the bank
  Future<bool> userHasVerificationSent({
    String? processKey,
    String? variable,
    String? variableValue,
    bool forceRefresh = false,
  }) async {
    final response = await netClient.request(
      netClient.netEndpoints.userTaskDetails,
      method: NetRequestMethods.get,
      queryParameters: {
        if (processKey != null) 'process_key': processKey,
        if (variable != null) 'variable': variable,
        if (variableValue != null) 'variable_value': variableValue,
      },
      forceRefresh: forceRefresh,
    );

    if (response.data! is List) return false;

    return (response.data as List).isNotEmpty;
  }

  /// Returns the list of processes in their latests versions
  /// that can be started by the user.
  Future<List<DPAProcessDefinitionDTO>> listLatestProcesses({
    bool forceRefresh = false,
  }) async {
    final response = await netClient.request(
      netClient.netEndpoints.listProcesses,
      method: NetRequestMethods.get,
      forceRefresh: forceRefresh,
    );

    return List<Map<String, dynamic>>.from(response.data)
        .map(DPAProcessDefinitionDTO.fromJson)
        .toList();
  }

  /// Returns a list of unassigned tasks.
  ///
  /// If forceRefresh is true, skips the cache to fetch the results again.
  Future<List<DPATaskDTO>> unassignedTasks({
    bool forceRefresh = false,
    String? customerId,
  }) async {
    final response = await netClient.request(
      netClient.netEndpoints.tasksUnassigned,
      method: NetRequestMethods.get,
      forceRefresh: forceRefresh,
      queryParameters: {
        if (customerId != null) 'customer_id': customerId,
      },
    );

    return DPATaskDTO.fromJsonList(
      List<Map<String, dynamic>>.from(response.data),
    );
  }

  /// Returns the current task of the process matching provided id.
  Future<DPATaskDTO?> getTask({
    required String processInstanceId,
    bool forceRefresh = false,
  }) async {
    final response = await netClient.request(
      '${netClient.netEndpoints.task}/$processInstanceId',
      forceRefresh: forceRefresh,
    );

    if (response.data is List && response.data.isNotEmpty) {
      return DPATaskDTO.fromJson(response.data.first);
    }

    return null;
  }

  /// Returns a list of tasks associated with the logged-in user.
  ///
  /// If forceRefresh is true, skips the cache to fetch the results again.
  Future<List<DPATaskDTO>> userTasks({
    bool forceRefresh = false,
    String? customerId,
    DPAStatusDTO? status,
  }) async {
    final response = await netClient.request(
      netClient.netEndpoints.tasksUser,
      method: NetRequestMethods.get,
      forceRefresh: forceRefresh,
      queryParameters: {
        if (status != null) 'status': status.value,
        if (customerId != null) 'customer_id': customerId,
      },
    );

    if (response.data is List) {
      return DPATaskDTO.fromJsonList(
        List<Map<String, dynamic>>.from(response.data),
      );
    }

    return [DPATaskDTO.fromJson(response.data)];
  }

  /// Returns a list with previous tasks associated with the logged-in user.
  ///
  /// If forceRefresh is true, skips the cache to fetch the results again.
  Future<List<DPATaskDTO>> historyTasks({
    bool forceRefresh = false,
  }) async {
    final response = await netClient.request(
      netClient.netEndpoints.tasksHistory,
      method: NetRequestMethods.get,
      forceRefresh: forceRefresh,
    );

    return DPATaskDTO.fromJsonList(
      List<Map<String, dynamic>>.from(response.data),
    );
  }

  /// Claims a task to the logged in user.
  Future<bool> claim({
    required String taskId,
  }) async {
    final response = await netClient.request(
      '${netClient.netEndpoints.tasksClaim}/$taskId',
      method: NetRequestMethods.patch,
      forceRefresh: true,
      throwAllErrors: false,
    );

    return response.success;
  }

  /// Finishes a task by passing the variables to the server.
  Future<bool> finishTask({
    required DPATaskDTO taskDTO,
  }) async {
    final id = taskDTO.id;
    final executionId = taskDTO.processInstanceId ?? taskDTO.executionId;

    assert(id != null);
    assert(executionId != null);

    final response = await netClient.request(
      '${netClient.netEndpoints.taskFinish}/$id/$executionId',
      method: NetRequestMethods.post,
      forceRefresh: true,
      throwAllErrors: false,
      data: {
        'variables': DPAVariableDTO.toJsonListFromMap(taskDTO.taskVariables),
      },
    );

    return response.success;
  }

  /// Starts a new DPA process using the given key, and the optional
  /// variables.
  ///
  /// Returns a [DPAProcessDTO] with the first step of this process.
  Future<DPAProcessDTO> startProcess({
    required String key,
    required List<DPAVariableDTO> variables,
  }) async {
    final response = await netClient.request(
      '${netClient.netEndpoints.taskStart}/key/$key',
      method: NetRequestMethods.post,
      forceRefresh: true,
      data: {
        'variables': DPAVariableDTO.toJsonList(
          variables,
          removeReadOnly: true,
        ),
      },
    );

    return DPAProcessDTO.fromJson(response.data);
  }

  /// Resumes an ongoing process.
  Future<DPAProcessDTO> resumeProcess({
    required String id,
  }) async {
    final response = await netClient.request(
      '${netClient.netEndpoints.taskResume}/$id',
      forceRefresh: true,
    );

    return DPAProcessDTO.fromJson(response.data);
  }

  /// Returns to the previous step of the process.
  Future<DPAProcessDTO> stepBack({
    required DPAProcessDTO process,
  }) async {
    final id = process.task?.processInstanceId;

    assert(id != null);

    final response = await netClient.request(
      '${netClient.netEndpoints.taskPrevious}/$id',
      method: NetRequestMethods.post,
      forceRefresh: true,
      data: {
        "activityInstanceId": process.task?.activityInstanceId,
        "activityId": process.task?.previousTasks?.last,
      },
    );

    return DPAProcessDTO.fromJson(response.data);
  }

  /// Advances to the next step on a new process, or finish it if on the last
  /// step.
  Future<DPAProcessDTO> stepOrFinishProcess({
    required DPAProcessDTO process,
  }) async {
    final id = process.task?.id;
    final executionId =
        process.task?.processInstanceId ?? process.task?.executionId;

    assert(id != null);
    assert(executionId != null);

    final response = await netClient.request(
      '${netClient.netEndpoints.taskFinish}/$id/$executionId',
      method: NetRequestMethods.post,
      forceRefresh: true,
      data: {
        'variables': DPAVariableDTO.toJsonListFromMap(
          process.variables,
        ),
      },
    );

    return DPAProcessDTO.fromJson(response.data);
  }

  /// Deletes an ongoing process.
  ///
  /// Returns `true` if succeeded.
  Future<bool> deleteProcess({
    required DPAProcessDTO process,
  }) async {
    final processInstanceId = process.task?.processInstanceId;

    assert(processInstanceId != null);

    final response = await netClient.request(
      '${netClient.netEndpoints.dpaDelete}/$processInstanceId',
      method: NetRequestMethods.delete,
      forceRefresh: true,
      throwAllErrors: false,
    );

    return response.success;
  }

  /// Uploads an image. Also used to upload user signatures.
  Future<bool> uploadImage({
    required DPAProcessDTO process,
    required String key,
    required String imageName,
    required String imageBase64Data,
    NetProgressCallback? onProgress,
  }) async {
    final processInstanceId = process.task?.processInstanceId;

    assert(processInstanceId != null);
    assert(key.isNotEmpty);

    final response = await netClient.request(
      '${netClient.netEndpoints.dpaUploadFile}/$processInstanceId/'
      '$key/$imageName',
      method: NetRequestMethods.post,
      data: {
        'image': imageBase64Data,
      },
      decodeResponse: false,
      forceRefresh: true,
      onSendProgress: onProgress,
    );

    return response.success;
  }

  /// Downloads a base64 encoded file from the server.
  Future<String> downloadFile({
    required DPAProcessDTO process,
    required String key,
    NetProgressCallback? progressCallback,
  }) async {
    final processInstanceId = process.task?.processInstanceId;

    assert(processInstanceId != null);
    assert(key.isNotEmpty);

    final response = await netClient.request(
      imageDownloadURL(
        process: process,
        key: key,
      ),
      method: NetRequestMethods.get,
      decodeResponse: false,
      responseType: ResponseType.plain,
      onReceiveProgress: progressCallback,
    );

    return response.data;
  }

  /// Deletes an uploaded file/image.
  ///
  /// Throws a [NetException] if fails.
  Future<void> deleteFile({
    required DPAProcessDTO process,
    required String key,
    NetProgressCallback? progressCallback,
  }) async {
    final processInstanceId = process.task?.processInstanceId;

    assert(processInstanceId != null);
    assert(key.isNotEmpty);

    final response = await netClient.request(
      '${netClient.netEndpoints.dpaDeleteFile}/$processInstanceId/$key',
      method: NetRequestMethods.delete,
      forceRefresh: true,
      throwAllErrors: false,
      onSendProgress: progressCallback,
    );

    if (response.success) return;

    throw NetException(
      statusCode: response.statusCode,
      message: response.statusMessage,
    );
  }

  /// Returns the prefix URL to access files on the server.
  String get fileURLPrefix => '${EnvironmentConfiguration.current.baseUrl}'
      '${netClient.netEndpoints.infobankingLink}';

  /// Returns the prefix URL to access the customer documents files
  /// on the server.
  String get customerDocumentsURLPrefix =>
      '${EnvironmentConfiguration.current.baseUrl}'
      '${netClient.netEndpoints.automationLink}';

  /// Returns the URL to download an upload image.
  String imageDownloadURL({
    required DPAProcessDTO process,
    required String key,
  }) =>
      '${EnvironmentConfiguration.current.baseUrl}'
      '${netClient.netEndpoints.dpaDownloadFile}'
      '/${process.task?.processInstanceId}'
      '/$key';
}
