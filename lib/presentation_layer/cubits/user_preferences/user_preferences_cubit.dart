import 'package:bloc/bloc.dart';

import '../../../data_layer/network.dart';
import '../../../domain_layer/models.dart';
import '../../../domain_layer/use_cases.dart';
import '../../cubits.dart';

///A cubit that holds the user preferences from a [LoggedUser]
class UserPreferencesCubit extends Cubit<UserPreferencesState> {
  final ChangeOfferFavoriteStatusUseCase _changeOfferFavoriteStatusUseCase;

  ///Creates a new [UserPreferencesCubit]
  UserPreferencesCubit({
    required User user,
    required ChangeOfferFavoriteStatusUseCase changeOfferFavoriteStatusUseCase,
  })  : _changeOfferFavoriteStatusUseCase = changeOfferFavoriteStatusUseCase,
        super(
          UserPreferencesState(
            favoriteOffers: user.favoriteOffers.toList(),
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
    } on Exception catch (e) {
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
}