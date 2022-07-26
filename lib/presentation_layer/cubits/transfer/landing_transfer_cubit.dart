import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data_layer/network.dart';
import '../../../domain_layer/use_cases.dart';
import '../../../layer_sdk.dart';

/// A cubit that handles the [User] transfers
class LandingTransferCubit extends Cubit<LandingTransferState> {
  final LoadFrequentTransfersUseCase _loadFrequentTransfersUseCase;
  final LoadAllCurrenciesUseCase _loadAllCurrenciesUseCase;

  /// Creates a new cubit using the supplied [LoadFrequentTransfersUseCase].
  LandingTransferCubit({
    required LoadFrequentTransfersUseCase loadFrequentTransfersUseCase,
    required LoadAllCurrenciesUseCase loadAllCurrenciesUseCase,
    int limit = 10,
  })  : _loadFrequentTransfersUseCase = loadFrequentTransfersUseCase,
        _loadAllCurrenciesUseCase = loadAllCurrenciesUseCase,
        super(LandingTransferState(pagination: Pagination(limit: limit)));

  /// Loads the list of frequent transfers
  Future<void> load({
    bool loadMore = false,
  }) async {
    emit(state.copyWith(busy: true, error: LandingTransferErrorStatus.none));

    try {
      final newPage = state.pagination.paginate(loadMore: loadMore);

      final frequentTransfers = await _loadFrequentTransfersUseCase(
        offset: newPage.offset,
        limit: newPage.limit,
        status: TransferStatus.completed,
        types: [
          TransferType.own,
          TransferType.domestic,
          TransferType.international,
          TransferType.bank
        ],
      );

      final currencies = await _loadAllCurrenciesUseCase();

      emit(
        state.copyWith(
          frequentTransfers: frequentTransfers,
          currencies: currencies,
          busy: false,
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          error: e is NetException
              ? LandingTransferErrorStatus.network
              : LandingTransferErrorStatus.generic,
          busy: false,
        ),
      );

      rethrow;
    }
  }
}
