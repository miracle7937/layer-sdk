import 'package:bloc/bloc.dart';

import '../../../../../data_layer/network.dart';
import '../../../../data_layer/data_layer.dart';
import 'loyalty_states.dart';

/// Cubit responsible for [Loyalty] data
class LoyaltyCubit extends Cubit<LoyaltyState> {
  final LoyaltyPointsRepository _repository;
  final DateTime _expiryDate;

  /// Creates a new cubit using the supplied [LoyaltyPointsRepository].
  LoyaltyCubit({
    required LoyaltyPointsRepository repository,
    required DateTime expiryDate,
  })  : _repository = repository,
        _expiryDate = expiryDate,
        super(LoyaltyState());

  /// Loads all Loyalty data
  Future<void> load() async {
    emit(
      state.copyWith(
        busy: true,
        errorStatus: LoyaltyErrorStatus.none,
      ),
    );

    try {
      final loyalties = await _repository.listAllLoyalty();
      final currentRate = await _repository.getCurrentRate();
      final dueExpiryPoints =
          await _repository.getExpiryPointsByDate(expirationDate: _expiryDate);

      emit(
        state.copyWith(
          busy: false,
          errorStatus: loyalties.isEmpty ? LoyaltyErrorStatus.noData : null,
          loyalty: loyalties.isEmpty
              ? null
              : loyalties.first.copyWith(
                  rate: currentRate.rate.toDouble(),
                  dueExpiryPoints: dueExpiryPoints.amount,
                ),
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          busy: false,
          errorStatus: e is NetException
              ? LoyaltyErrorStatus.network
              : LoyaltyErrorStatus.generic,
        ),
      );

      rethrow;
    }
  }
}
