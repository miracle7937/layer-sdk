import 'package:bloc_test/bloc_test.dart';
import 'package:equatable/equatable.dart';
import 'package:layer_sdk/business_layer/business_layer.dart';
import 'package:layer_sdk/data_layer/data_layer.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockBrandingRepository extends Mock implements BrandingRepository {}

late MockBrandingRepository _repository;

final _backendBranding = Branding(
  defaultFontFamily: 'Roboto',
  logoURL: 'logo.svg',
  logo: '{width:30}',
  lightColors: BrandingColors(
    brandPrimary: 20,
    brandSecondary: 30,
  ),
);

void main() {
  EquatableConfig.stringify = true;

  setUpAll(() {
    _repository = MockBrandingRepository();

    when(
      () => _repository.getBranding(),
    ).thenAnswer(
      (_) async => _backendBranding,
    );
  });

  blocTest<BrandingCubit, BrandingState>(
    'starts on empty state',
    build: () => BrandingCubit(repository: _repository),
    verify: (c) => expect(
      c.state,
      BrandingState(),
    ),
  ); // starts on empty state

  blocTest<BrandingCubit, BrandingState>(
    'should load backend branding by default',
    build: () => BrandingCubit(repository: _repository),
    act: (c) => c.load(),
    expect: () => [
      BrandingState(busy: true),
      BrandingState(
        branding: _backendBranding,
        action: BrandingStateActions.newBranding,
      ),
    ],
    verify: (c) {
      verify(() => _repository.getBranding()).called(1);
    },
  ); // should load backend branding by default

  blocTest<BrandingCubit, BrandingState>(
    'should load backend branding',
    build: () => BrandingCubit(repository: _repository),
    act: (c) => c.load(defaultBranding: false),
    expect: () => [
      BrandingState(busy: true),
      BrandingState(
        branding: _backendBranding,
        action: BrandingStateActions.newBranding,
      ),
    ],
    verify: (c) {
      verify(() => _repository.getBranding()).called(1);
    },
  ); // should load backend branding

  blocTest<BrandingCubit, BrandingState>(
    'should load default branding',
    build: () => BrandingCubit(repository: _repository),
    act: (c) => c.load(defaultBranding: true),
    expect: () => [
      BrandingState(busy: true),
      BrandingState(
        action: BrandingStateActions.newBranding,
      ),
    ],
    verify: (c) {
      verifyNever(() => _repository.getBranding());
    },
  ); // should load default branding

  group('Error handling', _dealWithErrors);
}

void _dealWithErrors() {
  setUpAll(() {
    when(
      () => _repository.getBranding(),
    ).thenThrow(
      NetException(message: 'Failed.'),
    );
  });

  blocTest<BrandingCubit, BrandingState>(
    'should deal with exception',
    build: () => BrandingCubit(repository: _repository),
    act: (c) => c.load(defaultBranding: false),
    expect: () => [
      BrandingState(busy: true),
      BrandingState(
        error: BrandingStateErrors.generic,
      ),
    ],
    verify: (c) {
      verify(() => _repository.getBranding()).called(1);
    },
  ); // should deal with exception
}
