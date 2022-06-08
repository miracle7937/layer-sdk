import 'package:flutter_test/flutter_test.dart';
import 'package:layer_sdk/features/branding.dart';
import 'package:mocktail/mocktail.dart';

class MockedBrandingRepository extends Mock
    implements BrandingRepositoryInterface {}

late MockedBrandingRepository _repository;
late LoadBrandingUseCase _useCase;
late Branding _mockedBranding;

void main() {
  setUp(() {
    _repository = MockedBrandingRepository();
    _useCase = LoadBrandingUseCase(
      repository: _repository,
    );

    _mockedBranding = Branding(
      logo: 'thisisatest',
    );

    when(
      () => _repository.getBranding(),
    ).thenAnswer(
      (_) async => _mockedBranding,
    );
  });

  test('Should return correct Branding', () async {
    final result = await _useCase();

    expect(result, _mockedBranding);

    verify(() => _repository.getBranding()).called(1);
  });
}
