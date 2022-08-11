import 'package:bloc/bloc.dart';

import '../../../../../../data_layer/network.dart';
import '../../../domain_layer/use_cases.dart';
import 'beneficiaries_states.dart';

/// A cubit that keeps the list of beneficiaries.
class BeneficiariesCubit extends Cubit<BeneficiariesState> {
  final LoadCustomerBeneficiariesUseCase _loadCustomerBeneficiariesUseCase;

  /// Maximum number of beneficiaries to load at a time.
  final int limit;

  /// Creates a new cubit using the supplied [LoadCustomerBeneficiariesUseCase]
  /// and optional `customerId`.
  BeneficiariesCubit({
    required LoadCustomerBeneficiariesUseCase loadCustomerBeneficiariesUseCase,
    String? customerID,
    this.limit = 50,
    bool ascendingOrder = true,
  })  : _loadCustomerBeneficiariesUseCase = loadCustomerBeneficiariesUseCase,
        super(
          BeneficiariesState(
            customerID: customerID,
            listData: BeneficiaryListData(),
          ),
        );

  /// Loads a list of beneficiaries, optionally using
  /// a search text to filter them.
  ///
  /// If [loadMore] is true, will try to update the list with more data.
  Future<void> load({
    String? searchText,
    bool loadMore = false,
    bool forceRefresh = false,
    bool activeOnly = false,
  }) async {
    emit(
      state.copyWith(
        busy: true,
        errorStatus: BeneficiariesErrorStatus.none,
      ),
    );

    final offset = loadMore ? state.listData.offset + limit : 0;

    try {
      final beneficiaries = await _loadCustomerBeneficiariesUseCase(
        customerId: state.customerID,
        query: searchText,
        offset: offset,
        limit: limit,
        forceRefresh: forceRefresh,
        activeOnly: activeOnly,
      );

      final list = offset > 0
          ? [...state.beneficiaries.take(offset).toList(), ...beneficiaries]
          : beneficiaries;

      emit(
        state.copyWith(
          beneficiaries: list,
          busy: false,
          canLoadMore: state.beneficiaries.length != list.length,
          listData: state.listData.copyWith(
            canLoadMore: beneficiaries.length >= limit,
            offset: offset,
            searchText: searchText,
          ),
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          busy: false,
          errorStatus: e is NetException
              ? BeneficiariesErrorStatus.network
              : BeneficiariesErrorStatus.generic,
        ),
      );

      rethrow;
    }
  }
}
