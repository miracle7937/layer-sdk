import 'package:bloc/bloc.dart';

import '../../../../../../data_layer/network.dart';
import '../../../data_layer/data_layer.dart';
import 'queue_request_states.dart';

/// Cubit responsible for retrieving the list of [QueueRequest]
class QueueRequestCubit extends Cubit<QueueRequestStates> {
  final QueueRequestRepository _repository;

  // TODO(VF): Move this property to this cubit's state.
  /// Maximum number of transactions to load at a time.
  final int limit;

  /// Creates a new instance of [CardTransactionsCubit]
  QueueRequestCubit({
    required QueueRequestRepository repository,
    this.limit = 50,
  })  : _repository = repository,
        super(QueueRequestStates());

  /// Loads the most recent requests
  Future<void> load({
    bool loadMore = false,
    bool forceRefresh = false,
  }) async {
    emit(
      state.copyWith(
        busy: true,
        busyOnFirstLoad: !loadMore,
        error: QueueRequestStatesErrors.none,
      ),
    );

    try {
      final offset = loadMore ? state.offset + limit : 0;

      final requests = await _repository.list(
        limit: limit,
        offset: offset,
        forceRefresh: forceRefresh,
      );

      final list = offset > 0
          ? [...state.requests.take(offset).toList(), ...requests]
          : requests;
      emit(
        state.copyWith(
          requests: list,
          busy: false,
          busyOnFirstLoad: false,
          canLoadMore: requests.length >= limit,
          offset: offset,
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          busy: false,
          busyOnFirstLoad: false,
          error: e is NetException
              ? QueueRequestStatesErrors.network
              : QueueRequestStatesErrors.generic,
        ),
      );

      rethrow;
    }
  }

  /// Accepts the provided QueueRequest item
  Future<void> acceptRequest(QueueRequest queueRequest) async {
    if (queueRequest.id == null) {
      throw ArgumentError('`queueRequest.id` is required');
    }

    emit(
      state.copyWith(
        busy: true,
        error: QueueRequestStatesErrors.none,
        action: QueueRequestStateActionResults.none,
      ),
    );

    try {
      final accepted = await _repository.accept(
        queueRequest.id!,
        isRequest: queueRequest.isRequest,
      );

      emit(
        state.copyWith(
          busy: false,
          requests: accepted
              ? _removeFromRequests(
                  queueRequest.id!,
                )
              : state.requests,
          error: accepted
              ? QueueRequestStatesErrors.none
              : QueueRequestStatesErrors.failedAccepting,
          action: accepted
              ? QueueRequestStateActionResults.approvedRequest
              : QueueRequestStateActionResults.none,
        ),
      );
    } on Exception {
      emit(
        state.copyWith(
          busy: false,
          error: QueueRequestStatesErrors.generic,
          action: QueueRequestStateActionResults.none,
        ),
      );
    }
  }

  /// Rejects the provided QueueRequest item
  Future<void> rejectRequest(QueueRequest queueRequest) async {
    if (queueRequest.id == null) {
      throw ArgumentError('`queueRequest.id` is required');
    }

    emit(
      state.copyWith(
        busy: true,
        error: QueueRequestStatesErrors.none,
        action: QueueRequestStateActionResults.none,
      ),
    );

    try {
      final rejected = await _repository.reject(
        queueRequest.id!,
        isRequest: queueRequest.isRequest,
      );

      emit(
        state.copyWith(
          busy: false,
          requests: rejected
              ? _removeFromRequests(
                  queueRequest.id!,
                )
              : state.requests,
          error: rejected
              ? QueueRequestStatesErrors.none
              : QueueRequestStatesErrors.failedRejecting,
          action: rejected
              ? QueueRequestStateActionResults.rejectedRequest
              : QueueRequestStateActionResults.none,
        ),
      );
    } on Exception {
      emit(
        state.copyWith(
          busy: false,
          error: QueueRequestStatesErrors.generic,
          action: QueueRequestStateActionResults.none,
        ),
      );
    }
  }

  List<QueueRequest> _removeFromRequests(String requestId) {
    return state.requests.where((x) => x.id != requestId).toList();
  }
}
