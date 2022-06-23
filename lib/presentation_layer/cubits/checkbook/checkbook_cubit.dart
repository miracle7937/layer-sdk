import 'package:bloc/bloc.dart';

import '../../../domain_layer/models.dart';
import '../../../domain_layer/use_cases.dart';
import '../../cubits.dart';

/// Cubit responsible for retrieving the list of customer [Checkbook]
class CheckbookCubit extends Cubit<CheckbookState> {
  final LoadCustomerCheckbooksUseCase _loadCustomerCheckbooksUseCase;

  /// Creates a new [CheckbookCubit]
  CheckbookCubit({
    required LoadCustomerCheckbooksUseCase loadCustomerCheckbooksUseCase,
    required String customerId,
    required int limit,
  })  : _loadCustomerCheckbooksUseCase = loadCustomerCheckbooksUseCase,
        super(CheckbookState(
          customerId: customerId,
          limit: limit,
        ));

  /// Loads the customer's checkbooks
  Future<void> load({
    bool forceRefresh = false,
    bool loadMore = false,
    CheckbookSort? sortBy,
    bool descendingOrder = true,
  }) async {
    try {
      emit(state.copyWith(
        busy: true,
        error: CheckbookStateError.none,
      ));

      final offset = loadMore ? state.limit + state.offset : 0;

      final checkbooks = await _loadCustomerCheckbooksUseCase(
        customerId: state.customerId,
        forceRefresh: forceRefresh,
        limit: state.limit,
        offset: offset,
        sortBy: sortBy,
        descendingOrder: descendingOrder,
      );

      final list =
          offset > 0 ? [...state.checkbooks, ...checkbooks] : checkbooks;

      emit(state.copyWith(
        busy: false,
        checkbooks: list,
        offset: offset,
        canLoadMore: checkbooks.length >= state.limit,
        descendingOrder: descendingOrder,
        sortBy: sortBy,
      ));
    } on Exception {
      emit(state.copyWith(
        busy: false,
        error: CheckbookStateError.generic,
      ));

      rethrow;
    }
  }
}
