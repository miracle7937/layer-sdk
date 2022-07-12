import 'package:bloc_test/bloc_test.dart';
import 'package:equatable/equatable.dart';
import 'package:layer_sdk/data_layer/network/net_exceptions.dart';
import 'package:layer_sdk/features/user.dart';
import 'package:layer_sdk/presentation_layer/cubits.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockSetAccessPinForUserUseCase extends Mock
    implements SetAccessPinForUserUseCase {}

class MockUser extends Mock implements User {}

final _useCase = MockSetAccessPinForUserUseCase();

final _token = 'token';

final _sucessPin = '123123';
final _networkExceptionPin = '111111';
final _genericExceptionPin = '222222';

final _user = MockUser();
final _networkException = NetException();
final _genericException = Exception();

SetPinScreenCubit get cubit => SetPinScreenCubit(
      userToken: _token,
      setAccessPinForUserUseCase: _useCase,
    );

void main() {
  EquatableConfig.stringify = true;

  setUpAll(() {
    when(
      () => _useCase(
        pin: _sucessPin,
        token: any(named: 'token'),
      ),
    ).thenAnswer(
      (_) async => _user,
    );

    when(
      () => _useCase(
        pin: _networkExceptionPin,
        token: any(named: 'token'),
      ),
    ).thenThrow(_networkException);

    when(
      () => _useCase(
        pin: _genericExceptionPin,
        token: any(named: 'token'),
      ),
    ).thenThrow(_genericException);
  });

  blocTest<SetPinScreenCubit, SetPinScreenState>(
    'Starts with empty state',
    build: () => cubit,
    verify: (c) => expect(
      c.state,
      SetPinScreenState(),
    ),
  );

  blocTest<SetPinScreenCubit, SetPinScreenState>(
    'Sets the access pin successfully',
    build: () => cubit,
    act: (c) => c.setAccesPin(pin: _sucessPin),
    expect: () => [
      SetPinScreenState(
        busy: true,
      ),
      SetPinScreenState(
        busy: false,
        user: _user,
      ),
    ],
    verify: (c) {
      verify(
        () => _useCase(
          token: _token,
          pin: _sucessPin,
        ),
      ).called(1);
    },
  );

  blocTest<SetPinScreenCubit, SetPinScreenState>(
    'NetException while setting the access pin',
    build: () => cubit,
    act: (c) => c.setAccesPin(pin: _networkExceptionPin),
    expect: () => [
      SetPinScreenState(
        busy: true,
      ),
      SetPinScreenState(
        busy: false,
        error: SetPinScreenError.network,
      ),
    ],
    verify: (c) {
      verify(
        () => _useCase(
          token: _token,
          pin: _networkExceptionPin,
        ),
      ).called(1);
    },
  );

  blocTest<SetPinScreenCubit, SetPinScreenState>(
    'Generic exception while setting the access pin',
    build: () => cubit,
    act: (c) => c.setAccesPin(pin: _genericExceptionPin),
    expect: () => [
      SetPinScreenState(
        busy: true,
      ),
      SetPinScreenState(
        busy: false,
        error: SetPinScreenError.generic,
      ),
    ],
    verify: (c) {
      verify(
        () => _useCase(
          token: _token,
          pin: _genericExceptionPin,
        ),
      ).called(1);
    },
  );

  blocTest<SetPinScreenCubit, SetPinScreenState>(
    'Clears the current error when retrying',
    build: () => cubit,
    seed: () => SetPinScreenState(
      error: SetPinScreenError.generic,
    ),
    act: (c) => c.setAccesPin(pin: _sucessPin),
    expect: () => [
      SetPinScreenState(
        busy: true,
        error: SetPinScreenError.none,
      ),
      SetPinScreenState(
        busy: false,
        error: SetPinScreenError.none,
        user: _user,
      ),
    ],
    verify: (c) {
      verify(
        () => _useCase(
          token: _token,
          pin: _sucessPin,
        ),
      ).called(1);
    },
  );
}
