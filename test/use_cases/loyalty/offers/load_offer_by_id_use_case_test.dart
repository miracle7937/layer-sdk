import 'package:flutter_test/flutter_test.dart';
import 'package:layer_sdk/features/loyalty.dart';
import 'package:mocktail/mocktail.dart';

class MockOffersRepository extends Mock implements OffersRepositoryInterface {}

class MockOffer extends Mock implements Offer {}

late MockOffersRepository _repository;
late LoadOfferByIdUseCase _useCase;
late MockOffer _mockedOffer;

final _offerId = 1;

void main() {
  setUp(() {
    _repository = MockOffersRepository();
    _useCase = LoadOfferByIdUseCase(repository: _repository);

    _mockedOffer = MockOffer();

    when(
      () => _repository.getOffer(
        id: any(named: 'id'),
      ),
    ).thenAnswer((_) async => _mockedOffer);
  });

  test('Should return an offer', () async {
    final result = await _useCase(
      offerId: _offerId,
    );

    expect(result, _mockedOffer);

    verify(
      () => _repository.getOffer(
        id: _offerId,
      ),
    ).called(1);
  });
}
