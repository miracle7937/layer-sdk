import 'package:flutter_test/flutter_test.dart';
import 'package:layer_sdk/features/user.dart';
import 'package:layer_sdk/features/user_preferences.dart';
import 'package:mocktail/mocktail.dart';

class MockUserRepositoryInterface extends Mock
    implements UserRepositoryInterface {}

late ChangeOfferFavoriteStatusUseCase _useCase;
late MockUserRepositoryInterface _repo;
late User _successUser;
late List<int> _offerIds;

void main() {
  setUp(() {
    registerFallbackValue(FavoriteOffersPreference(value: []));
    _repo = MockUserRepositoryInterface();
    _useCase = ChangeOfferFavoriteStatusUseCase(repository: _repo);

    _successUser = User(
      id: 'thiswassuccessfull',
    );
    _offerIds = List.generate(5, (index) => index);

    when(
      () => _repo.patchUserPreference(
        userPreference: any(named: 'userPreference'),
      ),
    ).thenAnswer(
      (_) async => _successUser,
    );
  });

  test('Should return user model', () async {
    final result = await _useCase(
      offerIds: _offerIds,
    );

    expect(result, _successUser);

    verify(
      () => _repo.patchUserPreference(
        userPreference: FavoriteOffersPreference(value: _offerIds),
      ),
    ).called(1);
  });
}
