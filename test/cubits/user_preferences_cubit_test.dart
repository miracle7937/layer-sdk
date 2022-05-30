import 'package:bloc_test/bloc_test.dart';
import 'package:equatable/equatable.dart';
import 'package:layer_sdk/business_layer/business_layer.dart';
import 'package:layer_sdk/data_layer/data_layer.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockUserRepository extends Mock implements UserRepository {}

late MockUserRepository _repo;

final _exception = NetException(message: 'there was an exception');

void main() {
  EquatableConfig.stringify = true;

  final initialFavoriteList = [100, 120];
  final addFavoriteList = [100, 120, 130];
  final removeFavoriteList = [100];

  final exceptionFavoriteList = [140];

  final mockedUser = User(
    id: '',
    firstName: '',
    lastName: '',
    status: UserStatus.active,
    token: '',
    favoriteOffers: initialFavoriteList,
  );

  final exceptionMockedUser = User(
    id: '',
    firstName: '',
    lastName: '',
    status: UserStatus.active,
    token: '',
    favoriteOffers: [],
  );

  setUp(() {
    _repo = MockUserRepository();

    when(
      () => _repo.patchUserPreference(
        userPreference: FavoriteOffersPreference(value: addFavoriteList),
      ),
    ).thenAnswer(
      (_) async => mockedUser.copyWith(favoriteOffers: addFavoriteList),
    );

    when(
      () => _repo.patchUserPreference(
        userPreference: FavoriteOffersPreference(value: removeFavoriteList),
      ),
    ).thenAnswer(
      (_) async => mockedUser.copyWith(favoriteOffers: removeFavoriteList),
    );

    when(
      () => _repo.patchUserPreference(
        userPreference: FavoriteOffersPreference(value: exceptionFavoriteList),
      ),
    ).thenThrow(_exception);
  });

  blocTest<UserPreferencesCubit, UserPreferencesState>(
    'Starts with empty state',
    build: () => UserPreferencesCubit(
      user: mockedUser,
      repository: _repo,
    ),
    verify: (c) => expect(
      c.state,
      UserPreferencesState(favoriteOffers: initialFavoriteList),
    ),
  );

  blocTest<UserPreferencesCubit, UserPreferencesState>(
    'Handles NetException when changing the favorite offers',
    build: () => UserPreferencesCubit(
      user: exceptionMockedUser,
      repository: _repo,
    ),
    act: (c) => c.changeOfferFavoriteStatus(offerId: 140),
    expect: () => [
      UserPreferencesState(
        busy: true,
        favoriteOffers: exceptionMockedUser.favoriteOffers,
      ),
      UserPreferencesState(
        busy: false,
        error: UserPreferencesError.network,
        errorMessage: _exception.message,
        favoriteOffers: exceptionMockedUser.favoriteOffers,
      ),
    ],
    verify: (c) {
      verify(() => _repo.patchUserPreference(
            userPreference:
                FavoriteOffersPreference(value: exceptionFavoriteList),
          )).called(1);
      verifyNoMoreInteractions(_repo);
    },
  );

  blocTest<UserPreferencesCubit, UserPreferencesState>(
    'Check if the error is successfully cleared after a failure'
    'and the favorite offer list is reseted to the initial status',
    build: () => UserPreferencesCubit(
      user: exceptionMockedUser,
      repository: _repo,
    ),
    seed: () => UserPreferencesState(
      error: UserPreferencesError.network,
      errorMessage: _exception.message,
      favoriteOffers: exceptionMockedUser.favoriteOffers,
    ),
    act: (c) => c.changeOfferFavoriteStatus(offerId: 140),
    expect: () => [
      UserPreferencesState(
        busy: true,
        favoriteOffers: exceptionMockedUser.favoriteOffers,
      ),
      UserPreferencesState(
        busy: false,
        error: UserPreferencesError.network,
        errorMessage: _exception.message,
        favoriteOffers: exceptionMockedUser.favoriteOffers,
      ),
    ],
    verify: (c) {
      verify(() => _repo.patchUserPreference(
            userPreference:
                FavoriteOffersPreference(value: exceptionFavoriteList),
          )).called(1);

      verifyNoMoreInteractions(_repo);
    },
  );

  blocTest<UserPreferencesCubit, UserPreferencesState>(
    'Adds one offer to the favorite offer list',
    build: () => UserPreferencesCubit(
      user: mockedUser,
      repository: _repo,
    ),
    act: (c) => c.changeOfferFavoriteStatus(offerId: 130),
    expect: () => [
      UserPreferencesState(
        busy: true,
        favoriteOffers: mockedUser.favoriteOffers,
      ),
      UserPreferencesState(
        busy: false,
        favoriteOffers: addFavoriteList,
        action: UserPreferencesAction.favoriteAdded,
      ),
    ],
    verify: (c) {
      verify(() => _repo.patchUserPreference(
            userPreference: FavoriteOffersPreference(value: addFavoriteList),
          )).called(1);
      verifyNoMoreInteractions(_repo);
    },
  );

  blocTest<UserPreferencesCubit, UserPreferencesState>(
    'Removes one offer from the favorite offer list',
    build: () => UserPreferencesCubit(
      user: mockedUser,
      repository: _repo,
    ),
    act: (c) => c.changeOfferFavoriteStatus(offerId: 120),
    expect: () => [
      UserPreferencesState(
        busy: true,
        favoriteOffers: mockedUser.favoriteOffers,
      ),
      UserPreferencesState(
        busy: false,
        favoriteOffers: removeFavoriteList,
        action: UserPreferencesAction.favoriteRemoved,
      ),
    ],
    verify: (c) {
      verify(() => _repo.patchUserPreference(
            userPreference: FavoriteOffersPreference(value: removeFavoriteList),
          )).called(1);
      verifyNoMoreInteractions(_repo);
    },
  );
}
