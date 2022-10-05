import '../../../domain_layer/models.dart';
import '../../dtos.dart';
import '../../mappings.dart';
import '../../network.dart';

/// Provides data related to Activities
class ActivityProvider {
  /// The NetClient to use for the network requests
  final NetClient netClient;

  /// Creates a new [ActivityProvider] instance
  ActivityProvider(
    this.netClient,
  );

  /// Returns a list of activites.
  Future<List<ActivityDTO>> list({
    DateTime? fromTS,
    DateTime? toTS,
    int? limit,
    int? offset,
    int? alertID,
    int? transferId,
    int? paymentId,
    String? typeItemID,
    String? searchStr,
    String? itemType,
    String? sortBy,
    bool? requestAlert,
    bool? hideRequests,
    bool includeDetails = true,
    bool removeDuplicates = true,
    bool searchRequestsAndTransfer = true,
    bool searchAlerts = true,
    bool searchUserTasks = true,
    bool? itemIsNull = false,
    ActivityType? type,
    List<ActivityType>? types,
    List<TransferType>? transferTypes,
    List<ActivityTag>? activityTags,
  }) async {
    final params = <String, dynamic>{
      'include_details': includeDetails.toString(),
      'search_object': searchRequestsAndTransfer.toString(),
      'search_alert': searchAlerts.toString(),
      'search_user_task': searchUserTasks.toString()
    };

    if (fromTS != null) {
      params['ts_from'] = fromTS.millisecondsSinceEpoch.toString();
    }

    if (toTS != null) {
      params['ts_to'] = toTS.millisecondsSinceEpoch.toString();
    }

    if (limit != null) {
      params['limit'] = limit.toString();
    }

    if (offset != null) {
      params['offset'] = offset.toString();
    }

    if (typeItemID != null) {
      params['type_item_id'] = typeItemID;
    }

    if (types != null && types.isNotEmpty) {
      params['type'] = types.map((t) => t.toJSONString).join(',');
    } else if (type != null) {
      params['type'] = type.toJSONString;
    }

    if (alertID != null) {
      params['alert_id'] = alertID.toString();
    }

    if (searchStr?.isNotEmpty ?? false) {
      params['q'] = searchStr!;
    }

    if (removeDuplicates) {
      params['remove_duplicates'] = removeDuplicates.toString();
    }

    if (requestAlert != null) {
      params['request_alert'] = requestAlert;
    }

    if (hideRequests != null) {
      params['hide_requests'] = hideRequests;
    }

    if (transferTypes != null && transferTypes.isNotEmpty) {
      params['item.trf_type'] = transferTypes.map((t) => t.name).join(',');
    }

    if (transferId != null) {
      params["item.transfer_id"] = transferId;
    }

    if (paymentId != null) {
      params["item.payment_id"] = paymentId;
    }

    if (itemType != null) {
      params["item.type"] = itemType;
    }

    if (sortBy != null) {
      params["sortby"] = sortBy;
    }

    if (activityTags?.isNotEmpty ?? false) {
      final tags = activityTags!.map((tag) => tag.toJSONString).join(',');
      params['tag'] = tags;
    }

    if (itemIsNull ?? false) {
      params['item_is_null'] = itemIsNull;
    }

    final response = await netClient.request(
      netClient.netEndpoints.activity,
      method: NetRequestMethods.get,
      queryParameters: params,
    );

    return ActivityDTO.fromJsonList(
      List<Map<String, dynamic>>.from(response.data),
    );
  }

  /// Delete a certain activity based on the id
  Future<void> delete(String activityId) async {
    await netClient.request(
      "${netClient.netEndpoints.request}/$activityId",
      method: NetRequestMethods.delete,
    );
  }

  /// Cancel the [Activity] by `id`
  Future<void> cancel(String id, {String? otpValue}) async {
    final param = <String, dynamic>{};

    if (otpValue != null) {
      param['otp_value'] = otpValue;
    }

    await netClient.request(
      '${netClient.netEndpoints.request}/$id/cancel',
      queryParameters: param,
      method: NetRequestMethods.post,
    );
  }

  /// Cancel the recurring transfer [Activity] by `id`
  Future<void> cancelRecurringTransfer(String id, {String? otpValue}) async {
    final param = <String, dynamic>{};

    if (otpValue != null) {
      param['second_factor_verification'] = true;
      param['otp_value'] = otpValue;
    }

    await netClient.request(
      '${netClient.netEndpoints.transferV2}/$id',
      queryParameters: param,
      method: NetRequestMethods.delete,
    );
  }

  /// Read the current [Alert] by `id`
  Future<void> readAlert(int id) async {
    await netClient.request(
      netClient.netEndpoints.alert,
      method: NetRequestMethods.patch,
      data: [
        {'alert_id': id, 'read': true}
      ],
    );
  }

  /// Read the current [Request] by `id`
  Future<void> readRequest(String id) async {
    await netClient.request(
      '${netClient.netEndpoints.request}/$id/read',
      method: NetRequestMethods.patch,
    );
  }

  /// Delete the current [Alert] by `id`
  Future<void> deleteAlert(int id) async {
    await netClient.request(
      '${netClient.netEndpoints.alert}/$id',
      method: NetRequestMethods.delete,
    );
  }

  /// Delete the current [Request] by `id`
  Future<void> deleteRequest(String id) async {
    await netClient.request(
      '${netClient.netEndpoints.request}/$id',
      method: NetRequestMethods.delete,
    );
  }

  /// Read all the [Alert]'s
  Future<void> readAllAlerts() async {
    await netClient.request(
      '${netClient.netEndpoints.alert}/read_all',
      method: NetRequestMethods.post,
      data: [],
    );
  }

  /// Read all the [Request]'s
  Future<void> readAllRequests() async {
    await netClient.request(
      '${netClient.netEndpoints.request}/read',
      method: NetRequestMethods.patch,
      data: {},
    );
  }

  /// Delete all the [Alert]'s
  Future<void> deleteAllAlerts() async {
    await netClient.request(
      netClient.netEndpoints.alert,
      method: NetRequestMethods.delete,
    );
  }

  /// Delete all the [Request]'s
  Future<void> deleteAllRequests() async {
    await netClient.request(
      netClient.netEndpoints.request,
      method: NetRequestMethods.delete,
    );
  }
}
