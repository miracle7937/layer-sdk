import 'package:bloc/bloc.dart';

import '../../../../../../data_layer/network.dart';
import '../../../domain_layer/models.dart';
import '../../../domain_layer/use_cases.dart';
import '../../cubits.dart';

/// Cubit responsible for retrieving the list of [QueueRequest]
class QueueRequestCubit extends Cubit<QueueRequestStates> {
  final LoadQueuesUseCase _loadQueuesUseCase;
  final AcceptQueueUseCase _acceptQueueUseCase;
  final RejectQueueUseCase _rejectQueueUseCase;
  final RemoveQueueFromRequestsUseCase _removeQueueFromRequestsUseCase;

  /// Creates a new instance of [CardTransactionsCubit]
  QueueRequestCubit({
    required LoadQueuesUseCase loadQueuesUseCase,
    required AcceptQueueUseCase acceptQueueUseCase,
    required RejectQueueUseCase rejectQueueUseCase,
    required RemoveQueueFromRequestsUseCase removeQueueFromRequestsUseCase,
  })  : _loadQueuesUseCase = loadQueuesUseCase,
        _acceptQueueUseCase = acceptQueueUseCase,
        _rejectQueueUseCase = rejectQueueUseCase,
        _removeQueueFromRequestsUseCase = removeQueueFromRequestsUseCase,
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
      final offset = loadMore ? state.offset + state.limit : 0;

      final requests = await _loadQueuesUseCase(
        limit: state.limit,
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
          canLoadMore: requests.length >= state.limit,
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
      final accepted = await _acceptQueueUseCase(
        queueRequest.id!,
        isRequest: queueRequest.isRequest,
      );

      emit(
        state.copyWith(
          busy: false,
          requests: accepted
              ? _removeQueueFromRequestsUseCase(
                  requests: state.requests,
                  requestId: queueRequest.id!,
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
      final rejected = await _rejectQueueUseCase(
        queueRequest.id!,
        isRequest: queueRequest.isRequest,
      );

      emit(
        state.copyWith(
          busy: false,
          requests: rejected
              ? _removeQueueFromRequestsUseCase(
                  requests: state.requests,
                  requestId: queueRequest.id!,
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
}
