import 'package:bloc/bloc.dart';

import '../../../data_layer/data_layer.dart';
import '../utils.dart';
import 'transfer_state.dart';

/// A cubit that keeps the list of customer transfers.
class TransferCubit extends Cubit<TransferState> {
  final TransferRepository _repository;

  /// Creates a new cubit using the supplied [TransferRepository].
  TransferCubit({
    required TransferRepository repository,
    required String customerId,
    int limit = 50,
  })  : _repository = repository,
        super(
          TransferState(
            customerId: customerId,
            pagination: Pagination(limit: limit),
          ),
        );

  /// Loads a list of transfers.
  ///
  /// If [loadMore] is true, will try to update the list with more data.
  Future<void> load({
    bool loadMore = false,
    bool includeDetails = true,
    bool forceRefresh = false,
  }) async {
    emit(
      state.copyWith(
        busy: true,
        errorStatus: TransferErrorStatus.none,
      ),
    );

    try {
      final newPage = state.pagination.paginate(loadMore: loadMore);

      final list = await _repository.list(
        customerId: state.customerId,
        offset: newPage.offset,
        limit: newPage.limit,
        includeDetails: includeDetails,
        forceRefresh: forceRefresh,
      );

      final transfers = newPage.firstPage
          ? list
          : [
              ...state.transfers.take(newPage.offset).toList(),
              ...list,
            ];

      emit(
        state.copyWith(
          transfers: transfers,
          busy: false,
          pagination: newPage.refreshCanLoadMore(
            loadedCount: list.length,
          ),
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          errorStatus: e is NetException
              ? TransferErrorStatus.network
              : TransferErrorStatus.generic,
          busy: false,
        ),
      );

      rethrow;
    }
  }
}
