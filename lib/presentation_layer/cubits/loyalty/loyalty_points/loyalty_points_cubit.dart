import 'package:bloc/bloc.dart';

import '../../../../data_layer/network.dart';
import '../../../../domain_layer/use_cases.dart';
import '../../../cubits.dart';
import '../../../extensions.dart';

/// Cubit responsible for [LoyaltyPoints] data.
class LoyaltyPointsCubit extends Cubit<LoyaltyPointsState> {
  final LoadAllLoyaltyPointsUseCase _loadAllLoyaltyPointsUseCase;
  final LoadCurrentLoyaltyPointsRateUseCase
      _loadCurrentLoyaltyPointsRateUseCase;
  final LoadExpiredLoyaltyPointsByDateUseCase
      _loadExpiredLoyaltyPointsByDateUseCase;
  final DateTime _expiryDate;

  /// Creates a new [LoyaltyPointsCubit] using the supplied use cases.
  LoyaltyPointsCubit({
    required LoadAllLoyaltyPointsUseCase loadAllLoyaltyPointsUseCase,
    required LoadCurrentLoyaltyPointsRateUseCase
        loadCurrentLoyaltyPointsRateUseCase,
    required LoadExpiredLoyaltyPointsByDateUseCase
        loadExpiredLoyaltyPointsByDateUseCase,
    required DateTime expiryDate,
  })  : _loadAllLoyaltyPointsUseCase = loadAllLoyaltyPointsUseCase,
        _loadCurrentLoyaltyPointsRateUseCase =
            loadCurrentLoyaltyPointsRateUseCase,
        _loadExpiredLoyaltyPointsByDateUseCase =
            loadExpiredLoyaltyPointsByDateUseCase,
        _expiryDate = expiryDate,
        super(LoyaltyPointsState());

  /// Loads all Loyalty points data.
  Future<void> load() async {
    emit(
      state.copyWith(
        busy: true,
        errorStatus: LoyaltyPointsErrorStatus.none,
      ),
    );

    try {
      final loyaltyPoints = await _loadAllLoyaltyPointsUseCase();
      final currentRate = await _loadCurrentLoyaltyPointsRateUseCase();
      final dueExpiryPoints = await _loadExpiredLoyaltyPointsByDateUseCase(
        expirationDate: _expiryDate,
      );

      emit(
        state.copyWith(
          busy: false,
          errorStatus:
              loyaltyPoints.isEmpty ? LoyaltyPointsErrorStatus.noData : null,
          loyaltyPoints: loyaltyPoints.isEmpty
              ? null
              : loyaltyPoints.first.copyWith(
                  rate: currentRate.rate.toDouble(),
                  dueExpiryPoints: dueExpiryPoints.amount,
                ),
        ),
      );
    } on Exception catch (e, st) {
      logException(e, st);
      emit(
        state.copyWith(
          busy: false,
          errorStatus: e is NetException
              ? LoyaltyPointsErrorStatus.network
              : LoyaltyPointsErrorStatus.generic,
        ),
      );

      rethrow;
    }
  }
}
