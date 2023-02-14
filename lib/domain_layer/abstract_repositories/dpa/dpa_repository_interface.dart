import '../../../data_layer/network.dart';
import '../../models.dart';

/// Handles all DPA data.
abstract class DPARepositoryInterface {
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
  });

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
  });

  /// Returns the current task of the process matching provided id.
  Future<DPATask?> getTask({
    required String processInstanceId,
    bool forceRefresh = false,
  });

  /// Returns the user task for the provided process key
  Future<List<DPATask>?> getUserTaskDetails({
    required String processKey,
    String? variable,
    String? variableValue,
    bool forceRefresh = false,
  });

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
  });

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
  });

  /// Claims a task for the current user.
  ///
  /// Returns true if succeeded.
  Future<bool> claimTask({
    required String taskId,
  });

  /// Pass the task to finish it.
  ///
  /// Returns `true` if successful.
  Future<bool> finishTask({
    required DPATask task,
  });

  /// Starts a new DPA process. using the given key, and the optional
  /// variables.
  ///
  /// Returns a [DPAProcess] with the first step of this process.
  Future<DPAProcess> startProcess({
    required String key,
    List<DPAVariable> variables,
  });

  /// Resumes an ongoing DPA process using the given id.
  ///
  /// Returns a [DPAProcess] with the current step of the process.
  Future<DPAProcess> resumeProcess({
    required String id,
  });

  /// Returns to the previous step of  the given [DPAProcess].
  ///
  /// Returns another [DPAProcess] detailing the step the process is now.
  Future<DPAProcess> stepBack({
    required DPAProcess process,
  });

  /// Advances the given [DPAProcess] to the next step, or, in case it's already
  /// on the final step, finish it.
  ///
  /// Returns another [DPAProcess] detailing the step the process is now.
  Future<DPAProcess> stepOrFinishProcess({
    required DPAProcess process,
  });

  /// Cancels the given [DPAProcess].
  ///
  /// Returns `true` if succeeded.
  Future<bool> cancelProcess({
    required String processInstanceId,
  });

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
  });

  /// Downloads a base64 encoded file from the server.
  ///
  /// Returns null if the download fails.
  Future<String?> downloadFile({
    required DPAProcess process,
    required DPAVariable variable,
    NetProgressCallback? onProgress,
  });

  /// Deletes an uploaded file/image on the server.
  ///
  /// Returns an updated [DPAVariable], or throws a [NetException] if could
  /// not delete the file.
  Future<DPAVariable> deleteFile({
    required DPAProcess process,
    required DPAVariable variable,
    NetProgressCallback? onProgress,
  });

  /// Parses a JSON into a [DPATask].
  ///
  /// Returns the [DPATask].
  DPATask parseJSONIntoDPATask({
    required Map<String, dynamic> json,
  });
}
