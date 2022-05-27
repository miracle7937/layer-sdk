import 'package:bloc/bloc.dart';

import '../../../data_layer/data_layer.dart';
import '../../business_layer.dart';

/// A cubit that keeps a list of bills.
class BillCubit extends Cubit<BillState> {
  final BillRepository _repository;

  /// Maximum number of bills to load at a time.
  final int limit;

  /// Creates a new cubit using the supplied [BillRepository] and
  /// customer id.
  BillCubit({
    required BillRepository repository,
    required String customerId,
    this.limit = 50,
  })  : _repository = repository,
        super(
          BillState(
            customerId: customerId,
          ),
        );

  /// Loads the customer's list of bills
  Future<void> load({
    bool loadMore = false,
    bool forceRefresh = false,
  }) async {
    emit(
      state.copyWith(
        busy: true,
        errorStatus: BillsErrorStatus.none,
      ),
    );

    final offset = loadMore ? state.offset + limit : 0;

    try {
      final bills = await _repository.list(
        customerId: state.customerId,
        offset: offset,
        limit: limit,
        forceRefresh: forceRefresh,
      );

      final list =
          offset > 0 ? [...state.bills.take(offset).toList(), ...bills] : bills;

      emit(
        state.copyWith(
          bills: list,
          busy: false,
          canLoadMore: state.bills.length != list.length,
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          errorStatus: e is NetException
              ? BillsErrorStatus.network
              : BillsErrorStatus.generic,
          busy: false,
        ),
      );

      rethrow;
    }
  }
}
