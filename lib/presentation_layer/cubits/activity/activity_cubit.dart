import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data_layer/network.dart';
import '../../../domain_layer/models.dart';
import '../../../domain_layer/use_cases.dart';
import '../../cubits.dart';
import '../../utils.dart';

/// A cubit that handles the [User] activities
class ActivityCubit extends Cubit<ActivityState> {
  final LoadActivitiesUseCase _loadActivitiesUseCase;
  final DeleteActivityUseCase _deleteActivityUseCase;
  final CancelActivityUseCase _cancelActivityUseCase;
  final CreateShortcutUseCase _createShortcutUseCase;
  final CancelRecurringTransferUseCase _cancelRecurringTransferUseCase;
  final CancelRecurringPaymentUseCase _cancelRecurrPaymentUseCase;

  /// Creates a new [ActivityCubit] instance
  ActivityCubit({
    required LoadActivitiesUseCase loadActivitiesUseCase,
    required DeleteActivityUseCase deleteActivityUseCase,
    required CancelActivityUseCase cancelActivityUseCase,
    required CreateShortcutUseCase createShortcutUseCase,
    required CancelRecurringTransferUseCase cancelRecurringTransferUseCase,
    required CancelRecurringPaymentUseCase cancelRecurrPaymentUseCase,
    int limit = 20,
  })  : _loadActivitiesUseCase = loadActivitiesUseCase,
        _deleteActivityUseCase = deleteActivityUseCase,
        _cancelActivityUseCase = cancelActivityUseCase,
        _createShortcutUseCase = createShortcutUseCase,
        _cancelRecurringTransferUseCase = cancelRecurringTransferUseCase,
        _cancelRecurrPaymentUseCase = cancelRecurrPaymentUseCase,
        super(ActivityState(
          pagination: Pagination(limit: limit),
        ));

  /// Loads all the activities
  ///
  /// Use the [loadMore] parameter for loading the next page of items.
  ///
  /// The [startDate], [endDate], [types], [activityTags] and [transferTypes]
  /// parameters can be used for filtering purposes.
  Future<void> load({
    bool loadMore = false,
    bool itemIsNull = false,
    DateTime? startDate,
    DateTime? endDate,
    List<ActivityType>? types,
    List<ActivityTag>? activityTags,
    List<TransferType>? transferTypes,
  }) async {
    emit(
      state.copyWith(
        errorStatus: ActivityErrorStatus.none,
        action: loadMore
            ? ActivityBusyAction.loadingMore
            : ActivityBusyAction.loading,
        errorMessage: '',
      ),
    );

    try {
      final newPage = state.pagination.paginate(loadMore: loadMore);

      final resultList = await _loadActivitiesUseCase(
        limit: newPage.limit,
        offset: newPage.offset,
        fromTS: startDate,
        toTS: endDate,
        itemIsNull: itemIsNull,
        types: types,
        activityTags: activityTags,
        transferTypes: transferTypes,
      );

      final activities = newPage.firstPage
          ? resultList
          : [
              ...state.activities,
              ...resultList,
            ];

      emit(
        state.copyWith(
          activities: activities,
          action: ActivityBusyAction.none,
          pagination: newPage.refreshCanLoadMore(
            loadedCount: resultList.length,
          ),
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          errorStatus: e is NetException
              ? ActivityErrorStatus.network
              : ActivityErrorStatus.generic,
          action: ActivityBusyAction.none,
          errorMessage: e is NetException ? e.message : null,
        ),
      );

      rethrow;
    }
  }

  /// TODO: cubit_issue | We don't handle busy states and errors on the delete
  /// and cancel methods?
  /// Delete a certain activity based on the id
  Future<void> delete(String activityId) => _deleteActivityUseCase(activityId);

  /// Cancel the [Activity] by `id`
  Future<void> cancel(String id, {String? otpValue}) => _cancelActivityUseCase(
        id: id,
        otpValue: otpValue,
      );

  /// Cancel the scheduled transfer by `id`
  Future<void> cancelRecurringTransfer(String id, {String? otpValue}) =>
      _cancelRecurringTransferUseCase(
        id,
        otpValue: otpValue,
      );

  /// TODO: cubit_issue | This method is returning the result from the
  /// cancel recurring payment use case instead of using the state. Migrate to
  /// cubit and state based.
  ///
  /// Cancel a recurring payment
  ///
  /// The [itemId] corresponds to the payment id.
  ///
  /// For verifying the otp, you can use the [otpValue] paramter. And set
  /// the [resendOTP] as `true` if you want the OTP to be resent.
  Future<Payment> cancelRecurringPayment(
    String itemId, {
    String? otpValue,
    bool resendOTP = false,
  }) async {
    emit(
      state.copyWith(
        errorStatus: ActivityErrorStatus.none,
        action: ActivityBusyAction.loading,
      ),
    );

    try {
      final result = await _cancelRecurrPaymentUseCase(
        id: itemId,
        otpValue: otpValue,
        resendOTP: resendOTP,
      );

      emit(
        state.copyWith(
          action: ActivityBusyAction.none,
        ),
      );

      return result;
    } on Exception catch (e) {
      emit(
        state.copyWith(
          errorStatus: e is NetException
              ? ActivityErrorStatus.network
              : ActivityErrorStatus.generic,
          action: ActivityBusyAction.none,
          errorMessage: e is NetException ? e.message : e.toString(),
        ),
      );

      rethrow;
    }
  }

  /// TODO: cubit_issue | We don't handle busy states and errors on the
  /// shortcut method
  /// Add the activity to shorcut
  Future<void> shortcut({required NewShortcut newShortcut}) =>
      _createShortcutUseCase(
        shortcut: newShortcut,
      );

  /// Save the shortcut name
  void onShortcutNameChanged(String shortcutName) => emit(
        state.copyWith(
          shortcutName: shortcutName,
        ),
      );
}
