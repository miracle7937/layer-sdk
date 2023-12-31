import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain_layer/use_cases.dart';
import '../../../layer_sdk.dart';

/// A cubit that handles the [User] transfers
class LandingTransferCubit extends Cubit<LandingTransferState> {
  final LoadFrequentTransfersUseCase _loadFrequentTransfersUseCase;

  /// Creates a new cubit using the supplied [LoadFrequentTransfersUseCase].
  LandingTransferCubit({
    required LoadFrequentTransfersUseCase loadFrequentTransfersUseCase,
    int limit = 10,
  })  : _loadFrequentTransfersUseCase = loadFrequentTransfersUseCase,
        super(LandingTransferState(pagination: Pagination(limit: limit)));

  /// Loads the list of frequent transfers
  Future<void> load({
    bool loadMore = false,
  }) async {
    emit(
      state.copyWith(
        actions: state.addAction(LandingTransferAction.loading),
        errors: state.removeErrorForAction(LandingTransferAction.loading),
      ),
    );

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

      emit(
        state.copyWith(
          frequentTransfers: frequentTransfers,
          actions: state.removeAction(LandingTransferAction.loading),
        ),
      );
    } on Exception catch (e, st) {
      logException(e, st);
      emit(
        state.copyWith(
            actions: state.removeAction(LandingTransferAction.loading),
            errors: state.addErrorFromException(
                exception: e, action: LandingTransferAction.loading)),
      );

      rethrow;
    }
  }
}
