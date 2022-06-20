import 'package:bloc/bloc.dart';

import '../../../domain_layer/models.dart';
import '../../../domain_layer/use_cases.dart';
import '../../cubits.dart';

/// Cubit responsible for retrieving the list of customer [Checkbook]
class CheckbookCubit extends Cubit<CheckbookState> {
  final LoadCustomerCheckbooksUseCase _loadCustomerCheckbooksUseCase;

  /// Maximum number of checkbooks to load at a time.
  final int limit;

  /// Creates a new [CheckbookCubit]
  CheckbookCubit({
    required LoadCustomerCheckbooksUseCase loadCustomerCheckbooksUseCase,
    required String customerId,
    this.limit = 50,
  })  : _loadCustomerCheckbooksUseCase = loadCustomerCheckbooksUseCase,
        super(CheckbookState(
          customerId: customerId,
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

      final offset = loadMore ? limit + state.offset : 0;

      final checkbooks = await _loadCustomerCheckbooksUseCase(
        customerId: state.customerId,
        forceRefresh: forceRefresh,
        limit: limit,
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
        canLoadMore: checkbooks.length >= limit,
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
