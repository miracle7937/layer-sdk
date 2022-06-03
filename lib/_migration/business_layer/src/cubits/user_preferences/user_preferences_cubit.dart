import 'package:bloc/bloc.dart';

import '../../../../../../data_layer/network.dart';
import '../../../../data_layer/data_layer.dart';
import '../../../business_layer.dart';

///A cubit that holds the user preferences from a [LoggedUser]
class UserPreferencesCubit extends Cubit<UserPreferencesState> {
  ///The repository
  final UserRepository _repository;

  ///Creates a new [UserPreferencesCubit]
  UserPreferencesCubit({
    required User user,
    required UserRepository repository,
  })  : _repository = repository,
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

      final response = await _repository.patchUserPreference(
        userPreference: FavoriteOffersPreference(value: newList),
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
