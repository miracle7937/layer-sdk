import 'package:bloc/bloc.dart';

import '../../../data_layer/network.dart';
import '../../../domain_layer/models.dart';
import '../../../domain_layer/use_cases.dart';
import '../../cubits.dart';
import '../../extensions.dart';

///A cubit that holds the user preferences from a [LoggedUser]
class UserPreferencesCubit extends Cubit<UserPreferencesState> {
  final ChangeOfferFavoriteStatusUseCase _changeOfferFavoriteStatusUseCase;
  final SetLowBalanceAlertUseCase _setLowBalanceAlertUseCase;
  final SetCustomUserPrefsUseCase _setCustomUserPrefsUseCase;

  ///Creates a new [UserPreferencesCubit]
  UserPreferencesCubit({
    User? user,
    required ChangeOfferFavoriteStatusUseCase changeOfferFavoriteStatusUseCase,
    required SetLowBalanceAlertUseCase setLowBalanceAlertUseCase,
    required SetCustomUserPrefsUseCase setCustomUserPrefsUseCase,
  })  : _changeOfferFavoriteStatusUseCase = changeOfferFavoriteStatusUseCase,
        _setLowBalanceAlertUseCase = setLowBalanceAlertUseCase,
        _setCustomUserPrefsUseCase = setCustomUserPrefsUseCase,
        super(
          UserPreferencesState(
            favoriteOffers: user != null ? user.favoriteOffers.toList() : [],
          ),
        );

  ///Adds / Removes a favorite offer from the user preferences of a [LoggedUser]
  Future<void> changeOfferFavoriteStatus({
    required int offerId,
  }) async {
    emit(
      state.copyWith(
        busy: true,
        error: UserPreferencesError.none,
        action: UserPreferencesAction.none,
      ),
    );

    try {
      UserPreferencesAction action;

      final newList = state.favoriteOffers.toList();

      if (newList.contains(offerId)) {
        newList.remove(offerId);
        action = UserPreferencesAction.favoriteRemoved;
      } else {
        newList.add(offerId);
        action = UserPreferencesAction.favoriteAdded;
      }

      final response = await _changeOfferFavoriteStatusUseCase(
        offerIds: newList,
      );

      emit(
        state.copyWith(
          favoriteOffers: response.favoriteOffers.toList(),
          busy: false,
          action: action,
        ),
      );
    } on Exception catch (e, st) {
      logException(e, st);
      emit(
        state.copyWith(
          busy: false,
          error: e is NetException
              ? UserPreferencesError.network
              : UserPreferencesError.generic,
          errorMessage: e is NetException ? e.message : null,
        ),
      );
    }
  }

  ///Adds a low balance alert
  Future<void> setLowBalanceAlert({
    required double lowBalanceValue,
    required String accountId,
    bool? valueAlert,
  }) async {
    UserPreferencesAction action;
    action = UserPreferencesAction.lowBalanceAdded;
    emit(
      state.copyWith(
        busy: true,
        actions: state.addAction(
          action,
        ),
        errors: state.removeErrorForAction(
          action,
        ),
      ),
    );
    var keyLowBalance = "customer_account.$accountId.pref_lowbal";
    var keyAlertLowBalance = "customer_account.$accountId.pref_alert_lowbal";
    var keyAlerted = "customer_account.$accountId.alerted";

    try {
      final response = await _setLowBalanceAlertUseCase(
        valueLowBalance: lowBalanceValue,
        keyLowBalance: keyLowBalance,
        valueAlertLowBalance: valueAlert,
        keyAlerted: keyAlerted,
        keyAlertLowBalance: keyAlertLowBalance,
      );

      emit(
        state.copyWith(
          lowBalanceValue: response.lowBalanceValue,
          busy: false,
          actions: state.removeAction(action),
        ),
      );
    } on Exception catch (e, st) {
      logException(e, st);
      emit(
        state.copyWith(
          busy: false,
          actions: state.removeAction(action),
          errors: state.addErrorFromException(
            action: action,
            exception: e,
          ),
          errorMessage: e is NetException ? e.message : null,
        ),
      );
    }
  }

  ///Adds a low balance alert
  Future<void> removeBalanceAlert({
    required double lowBalanceValue,
    required String accountId,
    bool? valueAlert,
  }) async {
    UserPreferencesAction action;
    action = UserPreferencesAction.alertRemoved;
    emit(
      state.copyWith(
        busy: true,
        actions: state.addAction(
          action,
        ),
        errors: state.removeErrorForAction(
          action,
        ),
      ),
    );
    var keyLowBalance = "customer_account.$accountId.pref_lowbal";
    var keyAlerted = "customer_account.$accountId.pref_alert_lowbal";

    try {
      final response = await _setLowBalanceAlertUseCase(
        valueLowBalance: lowBalanceValue,
        keyLowBalance: keyLowBalance,
        keyAlertLowBalance: keyAlerted,
      );

      emit(
        state.copyWith(
          lowBalanceValue: response.lowBalanceValue,
          busy: false,
          actions: state.removeAction(action),
        ),
      );
    } on Exception catch (e, st) {
      logException(e, st);
      emit(
        state.copyWith(
          busy: false,
          actions: state.removeAction(action),
          errors: state.addErrorFromException(
            action: action,
            exception: e,
          ),
          errorMessage: e is NetException ? e.message : null,
        ),
      );
    }
  }

  /// Sets a custom user pref based on the
  /// key/value passed to this function
  Future<void> setCustomUserPrefs({
    required String key,
    required dynamic value,
  }) async {
    var action = UserPreferencesAction.prefAdded;

    emit(
      state.copyWith(
        busy: true,
        actions: state.addAction(
          action,
        ),
        errors: state.removeErrorForAction(
          action,
        ),
      ),
    );

    try {
      await _setCustomUserPrefsUseCase(
        key: key,
        value: value,
      );

      emit(
        state.copyWith(
          busy: false,
          actions: state.removeAction(action),
        ),
      );
    } on Exception catch (e, st) {
      logException(e, st);
      emit(
        state.copyWith(
          busy: false,
          actions: state.removeAction(action),
          errors: state.addErrorFromException(
            action: action,
            exception: e,
          ),
          errorMessage: e is NetException ? e.message : null,
        ),
      );
    }
  }
}
