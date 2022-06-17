import 'package:bloc/bloc.dart';

import '../../../data_layer/extensions.dart';
import '../../../domain_layer/models.dart';
import '../../../domain_layer/use_cases.dart';
import '../../cubits.dart';

/// Cubit responsible for retrieving the list of customer [Audit]
class CustomerAuditsCubit extends Cubit<CustomerAuditsState> {
  final LoadCustomerAuditsUseCase _loadCustomerAuditsUseCase;

  /// Maximum number of audits to load at a time.
  final int limit;

  /// Application configurations
  final Config? config;

  /// Creates a new [CustomerAuditsCubit].
  CustomerAuditsCubit({
    required LoadCustomerAuditsUseCase loadCustomerAuditsUseCase,
    required String customerId,
    this.config,
    this.limit = 50,
  })  : _loadCustomerAuditsUseCase = loadCustomerAuditsUseCase,
        super(CustomerAuditsState(customerId: customerId));

  /// Loads the audits done by the provided customerId
  Future<void> load({
    bool forceRefresh = false,
    bool loadMore = false,
    String? searchText,
    AuditSort sortBy = AuditSort.date,
    bool descendingOrder = true,
  }) async {
    emit(state.copyWith(
      busy: true,
      error: CustomerAuditsStateError.none,
    ));

    try {
      final offset = loadMore ? state.offset + limit : 0;

      var audits = await _loadCustomerAuditsUseCase(
        customerId: state.customerId,
        forceRefresh: forceRefresh,
        limit: limit,
        offset: offset,
        sortBy: sortBy,
        descendingOrder: descendingOrder,
        searchText: searchText,
      );

      if (config != null) {
        audits = audits
            .map(
              (audit) => audit.copyWith(
                graphanaUrl: config?.getGraphanaURLFromAudit(
                  audit,
                ),
              ),
            )
            .toList(
              growable: false,
            );
      }

      final list = offset > 0 ? [...state.audits, ...audits] : audits;

      emit(state.copyWith(
        audits: list,
        busy: false,
        error: CustomerAuditsStateError.none,
        offset: offset,
        canLoadMore: audits.length >= limit,
        sortBy: sortBy,
        descendingOrder: descendingOrder,
      ));
    } on Exception {
      emit(state.copyWith(
        error: CustomerAuditsStateError.generic,
        busy: false,
      ));

      rethrow;
    }
  }
}
