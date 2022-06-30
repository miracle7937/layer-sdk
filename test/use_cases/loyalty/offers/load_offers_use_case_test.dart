import 'package:flutter_test/flutter_test.dart';
import 'package:layer_sdk/features/loyalty.dart';
import 'package:mocktail/mocktail.dart';

class MockOffersRepository extends Mock implements OffersRepositoryInterface {}

class MockOfferResponse extends Mock implements OfferResponse {}

late MockOffersRepository _repository;
late LoadOffersUseCase _useCase;
late MockOfferResponse _mockedOfferResponse;

final _limit = 10;
final _offset = 0;

void main() {
  setUp(() {
    _repository = MockOffersRepository();
    _useCase = LoadOffersUseCase(repository: _repository);

    _mockedOfferResponse = MockOfferResponse();

    when(
      () => _repository.list(
        limit: any(named: 'limit'),
        offset: any(named: 'offset'),
        isFavorites: false,
        isForMe: false,
      ),
    ).thenAnswer((_) async => _mockedOfferResponse);
  });

  test('Should return an offer response', () async {
    final result = await _useCase(
      limit: _limit,
      offset: _offset,
    );

    expect(result, _mockedOfferResponse);

    verify(
      () => _repository.list(
        limit: _limit,
        offset: _offset,
        isFavorites: false,
        isForMe: false,
      ),
    ).called(1);
  });
}
