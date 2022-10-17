import 'package:bloc/bloc.dart';

import '../../../../../../data_layer/network.dart';
import '../../../../presentation_layer/utils.dart';
import '../../../domain_layer/use_cases.dart';
import '../../../domain_layer/use_cases/payments/generate_device_uid_use_case.dart';
import '../../cubits.dart';

/// A cubit that keeps the list of customer transfers.
class TransferCubit extends Cubit<TransferState> {
  final LoadTransfersUseCase _loadTransfersUseCase;

  /// Creates a new cubit using the supplied [LoadTransfersUseCase].
  TransferCubit({
    required String customerId,
    required LoadTransfersUseCase loadTransfersUseCase,
    required GenerateDeviceUIDUseCase generateDeviceUIDUseCase,
    int limit = 50,
  })  : _loadTransfersUseCase = loadTransfersUseCase,
        super(
          TransferState(
            deviceUID: generateDeviceUIDUseCase(30),
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

      final list = await _loadTransfersUseCase(
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
