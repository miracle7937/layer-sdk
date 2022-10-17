import 'package:bloc_test/bloc_test.dart';
import 'package:equatable/equatable.dart';
import 'package:layer_sdk/data_layer/network.dart';
import 'package:layer_sdk/domain_layer/models.dart';
import 'package:layer_sdk/domain_layer/use_cases/user/set_custom_user_prefs_use_case.dart';
import 'package:layer_sdk/features/user_preferences.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockChangeOfferFavoriteStatusUseCase extends Mock
    implements ChangeOfferFavoriteStatusUseCase {}

class MockSetLowBalanceAlertUseCase extends Mock
    implements SetLowBalanceAlertUseCase {}

class MockSetCustomUserPrefsUseCase extends Mock
    implements SetCustomUserPrefsUseCase {}

late MockChangeOfferFavoriteStatusUseCase _useCase;
late MockSetLowBalanceAlertUseCase _balanceAlertUseCase;
late MockSetCustomUserPrefsUseCase _setCustomUserPrefsUseCase;

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
    _useCase = MockChangeOfferFavoriteStatusUseCase();
    _balanceAlertUseCase = MockSetLowBalanceAlertUseCase();
    _setCustomUserPrefsUseCase = MockSetCustomUserPrefsUseCase();

    when(
      () => _useCase(
        offerIds: addFavoriteList,
      ),
    ).thenAnswer(
      (_) async => mockedUser.copyWith(favoriteOffers: addFavoriteList),
    );

    when(
      () => _useCase(
        offerIds: removeFavoriteList,
      ),
    ).thenAnswer(
      (_) async => mockedUser.copyWith(favoriteOffers: removeFavoriteList),
    );

    when(
      () => _useCase(
        offerIds: exceptionFavoriteList,
      ),
    ).thenThrow(_exception);
  });

  blocTest<UserPreferencesCubit, UserPreferencesState>(
    'Starts with empty state',
    build: () => UserPreferencesCubit(
      user: mockedUser,
      changeOfferFavoriteStatusUseCase: _useCase,
      setLowBalanceAlertUseCase: _balanceAlertUseCase,
      setCustomUserPrefsUseCase: _setCustomUserPrefsUseCase,
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
      changeOfferFavoriteStatusUseCase: _useCase,
      setLowBalanceAlertUseCase: _balanceAlertUseCase,
      setCustomUserPrefsUseCase: _setCustomUserPrefsUseCase,
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
      verify(() => _useCase(
            offerIds: exceptionFavoriteList,
          )).called(1);
      verifyNoMoreInteractions(_useCase);
    },
  );

  blocTest<UserPreferencesCubit, UserPreferencesState>(
    'Check if the error is successfully cleared after a failure'
    'and the favorite offer list is reseted to the initial status',
    build: () => UserPreferencesCubit(
      user: exceptionMockedUser,
      changeOfferFavoriteStatusUseCase: _useCase,
      setLowBalanceAlertUseCase: _balanceAlertUseCase,
      setCustomUserPrefsUseCase: _setCustomUserPrefsUseCase,
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
      verify(() => _useCase(
            offerIds: exceptionFavoriteList,
          )).called(1);

      verifyNoMoreInteractions(_useCase);
    },
  );

  blocTest<UserPreferencesCubit, UserPreferencesState>(
    'Adds one offer to the favorite offer list',
    build: () => UserPreferencesCubit(
      user: mockedUser,
      changeOfferFavoriteStatusUseCase: _useCase,
      setLowBalanceAlertUseCase: _balanceAlertUseCase,
      setCustomUserPrefsUseCase: _setCustomUserPrefsUseCase,
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
      verify(() => _useCase(
            offerIds: addFavoriteList,
          )).called(1);
      verifyNoMoreInteractions(_useCase);
    },
  );

  blocTest<UserPreferencesCubit, UserPreferencesState>(
    'Removes one offer from the favorite offer list',
    build: () => UserPreferencesCubit(
      user: mockedUser,
      changeOfferFavoriteStatusUseCase: _useCase,
      setLowBalanceAlertUseCase: _balanceAlertUseCase,
      setCustomUserPrefsUseCase: _setCustomUserPrefsUseCase,
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
      verify(() => _useCase(
            offerIds: removeFavoriteList,
          )).called(1);
      verifyNoMoreInteractions(_useCase);
    },
  );
}
