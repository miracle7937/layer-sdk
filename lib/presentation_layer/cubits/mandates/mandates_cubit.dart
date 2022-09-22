import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data_layer/network.dart';
import '../../../domain_layer/models.dart';
import '../../../domain_layer/use_cases/mandates/load_mandates_use_case.dart';
import '../../utils.dart';
import 'mandates_state.dart';

/// TODO: cubit_issue | I think it would be better to merge the
/// [MandateCancelCubit], [MandateCreateCubit] and this cubit together.
/// Don't see the advantage of having all of these separated.
///
/// Cubit that loads a [Mandate] data
class MandatesCubit extends Cubit<MandatesState> {
  final LoadMandatesUseCase _mandatesUseCase;

  /// Creates a new [MandatesCubit] instance
  MandatesCubit({
    required LoadMandatesUseCase loadMandateUseCase,
    int limit = 25,
  })  : _mandatesUseCase = loadMandateUseCase,
        super(
          MandatesState(
            pagination: Pagination(
              limit: limit,
            ),
          ),
        );

  /// Load [Mandate]s
  Future<void> load({
    bool loadMore = false,
    int? mandateId,
  }) async {
    emit(
      state.copyWith(
        busy: true,
        busyAction: loadMore
            ? MandatesBusyAction.loadingMore
            : MandatesBusyAction.loading,
        errorStatus: MandatesErrorStatus.none,
        mandates: [],
      ),
    );

    try {
      final pagination = state.pagination.paginate(loadMore: loadMore);
      final foundMandates = await _mandatesUseCase(
        limit: pagination.limit,
        offset: pagination.offset,
        mandateId: mandateId,
      );

      final mandates = pagination.firstPage
          ? foundMandates
          : [
              ...state.mandates,
              ...foundMandates,
            ];

      emit(
        state.copyWith(
          busy: false,
          mandates: mandates,
          pagination: pagination.refreshCanLoadMore(
            loadedCount: foundMandates.length,
          ),
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          busy: false,
          errorStatus: e is NetException
              ? MandatesErrorStatus.network
              : MandatesErrorStatus.generic,
          errorMessage: e is NetException ? e.message : null,
        ),
      );
    }
  }
}
