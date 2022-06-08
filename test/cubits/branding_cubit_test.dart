import 'package:bloc_test/bloc_test.dart';
import 'package:equatable/equatable.dart';
import 'package:layer_sdk/data_layer/network.dart';
import 'package:layer_sdk/features/branding.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockLoadBrandingUseCase extends Mock implements LoadBrandingUseCase {}

late MockLoadBrandingUseCase _useCase;

final _backendBranding = Branding(
  defaultFontFamily: 'Roboto',
  logoURL: 'logo.svg',
  logo: '{width:30}',
  lightColors: BrandingColors(
    brandPrimary: 20,
    brandSecondary: 30,
  ),
);

final _defaultBranding = Branding(
  defaultFontFamily: 'thisisatest',
  logoURL: 'logo.svg',
  logo: '{width:30}',
  lightColors: BrandingColors(
    brandPrimary: 220,
    brandSecondary: 5,
  ),
);

void main() {
  EquatableConfig.stringify = true;

  setUpAll(() {
    _useCase = MockLoadBrandingUseCase();

    when(
      () => _useCase(forceDefault: false),
    ).thenAnswer(
      (_) async => _backendBranding,
    );

    when(
      () => _useCase(forceDefault: true),
    ).thenAnswer(
      (_) async => _defaultBranding,
    );
  });

  blocTest<BrandingCubit, BrandingState>(
    'starts on empty state',
    build: () => BrandingCubit(
      getBrandingUseCase: _useCase,
    ),
    verify: (c) => expect(
      c.state,
      BrandingState(),
    ),
  ); // starts on empty state

  blocTest<BrandingCubit, BrandingState>(
    'should load backend branding by default',
    build: () => BrandingCubit(
      getBrandingUseCase: _useCase,
    ),
    act: (c) => c.load(),
    expect: () => [
      BrandingState(busy: true),
      BrandingState(
        branding: _backendBranding,
        action: BrandingStateActions.newBranding,
      ),
    ],
    verify: (c) {
      verify(() => _useCase()).called(1);
    },
  ); // should load backend branding by default

  blocTest<BrandingCubit, BrandingState>(
    'should load backend branding',
    build: () => BrandingCubit(
      getBrandingUseCase: _useCase,
    ),
    act: (c) => c.load(defaultBranding: false),
    expect: () => [
      BrandingState(busy: true),
      BrandingState(
        branding: _backendBranding,
        action: BrandingStateActions.newBranding,
      ),
    ],
    verify: (c) {
      verify(() => _useCase()).called(1);
    },
  ); // should load backend branding

  blocTest<BrandingCubit, BrandingState>(
    'should load default branding',
    build: () => BrandingCubit(
      getBrandingUseCase: _useCase,
    ),
    act: (c) => c.load(defaultBranding: true),
    expect: () => [
      BrandingState(busy: true),
      BrandingState(
        branding: _defaultBranding,
        action: BrandingStateActions.newBranding,
      ),
    ],
    verify: (c) {
      verifyNever(() => _useCase());
    },
  ); // should load default branding

  group('Error handling', _dealWithErrors);
}

void _dealWithErrors() {
  setUpAll(() {
    when(
      () => _useCase(),
    ).thenThrow(
      NetException(message: 'Failed.'),
    );
  });

  blocTest<BrandingCubit, BrandingState>(
    'should deal with exception',
    build: () => BrandingCubit(
      getBrandingUseCase: _useCase,
    ),
    act: (c) => c.load(defaultBranding: false),
    expect: () => [
      BrandingState(busy: true),
      BrandingState(
        error: BrandingStateErrors.generic,
      ),
    ],
    verify: (c) {
      verify(() => _useCase()).called(1);
    },
  ); // should deal with exception
}
