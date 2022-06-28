import 'package:bloc_test/bloc_test.dart';
import 'package:equatable/equatable.dart';
import 'package:layer_sdk/data_layer/network.dart';
import 'package:layer_sdk/domain_layer/models.dart';
import 'package:layer_sdk/features/branch_activation.dart';
import 'package:layer_sdk/presentation_layer/utils.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockCheckBranchActivationCodeUseCase extends Mock
    implements CheckBranchActivationCodeUseCase {}

class MockVerifyOTPForBranchActivationUseCase extends Mock
    implements VerifyOTPForBranchActivationUseCase {}

class MockResendOTPUseCase extends Mock implements ResendOTPUseCase {}

class MockLoadUserDetailsFromTokenUseCase extends Mock
    implements LoadUserDetailsFromTokenUseCase {}

class MockSetAccessPinForUserUseCase extends Mock
    implements SetAccessPinForUserUseCase {}

final MockCheckBranchActivationCodeUseCase _checkBranchActivationCodeUseCase =
    MockCheckBranchActivationCodeUseCase();
final MockVerifyOTPForBranchActivationUseCase
    _verifyOTPForBranchActivationUseCase =
    MockVerifyOTPForBranchActivationUseCase();
final MockResendOTPUseCase _resendOTPUseCase = MockResendOTPUseCase();
final MockLoadUserDetailsFromTokenUseCase _loadUserDetailsFromTokenUseCase =
    MockLoadUserDetailsFromTokenUseCase();
final MockSetAccessPinForUserUseCase _setAccessPinForUserUseCase =
    MockSetAccessPinForUserUseCase();

final _keepPollingException = NetException(statusCode: 404);
final _netException = NetException(message: 'Server timed out');
final _genericException = Exception();

var _didPollAlready = false;
final _pollingCode = ActivationCodeUtils().generateActivationCode(6);

final _successCode = ActivationCodeUtils().generateActivationCode(6);
final _codeSuccessResult = BranchActivationResponse(token: _successUserToken);

final _otpCode = ActivationCodeUtils().generateActivationCode(6);
final _codeOtpResult = BranchActivationResponse(
    secondFactorVerification: SecondFactorVerification(
  type: SecondFactorType.otp,
));
final _successOtp = '0000';
final _netExceptionOtp = '1111';
final _genericExceptionOtp = '2222';

final _netExceptionCode = ActivationCodeUtils().generateActivationCode(6);

final _genericExceptionCode = ActivationCodeUtils().generateActivationCode(6);

final _successUserToken = 'success_token';
final _user = User(id: '1');
final _netExceptionUserToken = 'net_exception_token';
final _genericExceptionUserToken = 'generic_exception_token';

final _successAccessPin = '1234';
final _netExceptionAccessPin = '4321';
final _genericExceptionAccessPin = '1111';

void main() {
  EquatableConfig.stringify = true;

  setUpAll(() {
    /// Branch activation
    when(
      () => _checkBranchActivationCodeUseCase(
        code: _pollingCode,
      ),
    ).thenAnswer((_) async {
      if (!_didPollAlready) {
        _didPollAlready = true;
        throw _keepPollingException;
      } else {
        return Future.value(_codeSuccessResult);
      }
    });

    when(
      () => _checkBranchActivationCodeUseCase(
        code: _successCode,
      ),
    ).thenAnswer((_) async => _codeSuccessResult);

    when(
      () => _checkBranchActivationCodeUseCase(
        code: _otpCode,
      ),
    ).thenAnswer((_) async => _codeOtpResult);

    when(
      () => _checkBranchActivationCodeUseCase(
        code: _netExceptionCode,
      ),
    ).thenThrow(_netException);

    when(
      () => _checkBranchActivationCodeUseCase(
        code: _genericExceptionCode,
      ),
    ).thenThrow(_genericException);

    /// OTP
    when(
      () => _verifyOTPForBranchActivationUseCase(
        code: any(named: 'code'),
        otpValue: _successOtp,
      ),
    ).thenAnswer((_) async => _codeSuccessResult);

    when(
      () => _verifyOTPForBranchActivationUseCase(
        code: any(named: 'code'),
        otpValue: _netExceptionOtp,
      ),
    ).thenThrow(_netException);

    when(
      () => _verifyOTPForBranchActivationUseCase(
        code: any(named: 'code'),
        otpValue: _genericExceptionOtp,
      ),
    ).thenThrow(_genericException);

    when(
      () => _resendOTPUseCase(
        otpId: int.parse(_successOtp),
      ),
    ).thenAnswer((_) async => NetResponse(statusCode: 200));

    when(
      () => _resendOTPUseCase(
        otpId: int.parse(_netExceptionOtp),
      ),
    ).thenThrow(_netException);

    when(
      () => _resendOTPUseCase(
        otpId: int.parse(_genericExceptionOtp),
      ),
    ).thenThrow(_genericException);

    /// User
    when(
      () => _loadUserDetailsFromTokenUseCase(
        token: _successUserToken,
      ),
    ).thenAnswer((_) async => _user);

    when(
      () => _loadUserDetailsFromTokenUseCase(
        token: _netExceptionUserToken,
      ),
    ).thenThrow(_netException);

    when(
      () => _loadUserDetailsFromTokenUseCase(
        token: _genericExceptionUserToken,
      ),
    ).thenThrow(_genericException);

    when(
      () => _setAccessPinForUserUseCase(
        pin: _successAccessPin,
        token: any(named: 'token'),
      ),
    ).thenAnswer((_) async => _user);

    when(
      () => _setAccessPinForUserUseCase(
        pin: _netExceptionAccessPin,
        token: any(named: 'token'),
      ),
    ).thenThrow(_netException);

    when(
      () => _setAccessPinForUserUseCase(
        pin: _genericExceptionAccessPin,
        token: any(named: 'token'),
      ),
    ).thenThrow(_genericException);
  });

  blocTest<BranchActivationCubit, BranchActivationState>(
    'check activation code length',
    build: () => BranchActivationCubit(
      checkBranchActivationCodeUseCase: _checkBranchActivationCodeUseCase,
      verifyOTPForBranchActivationUseCase: _verifyOTPForBranchActivationUseCase,
      resendOTPUseCase: _resendOTPUseCase,
      loadUserDetailsFromTokenUseCase: _loadUserDetailsFromTokenUseCase,
      setAccessPinForUserUseCase: _setAccessPinForUserUseCase,
      activationCodeLength: 7,
    ),
    verify: (c) => expect(
      c.state.activationCode.length,
      7,
    ),
  );

  group('Activation code test |', _activationCodeTests);

  group('Otp test |', _otpTests);

  group('User test |', _userTests);

  group('Access pin test |', _accesPinTests);
}

void _activationCodeTests() {
  final pollingState = BranchActivationState(
    activationCode: _pollingCode,
  );

  blocTest<BranchActivationCubit, BranchActivationState>(
    'polls activation code, gets response and gets user',
    build: () => BranchActivationCubit(
      checkBranchActivationCodeUseCase: _checkBranchActivationCodeUseCase,
      verifyOTPForBranchActivationUseCase: _verifyOTPForBranchActivationUseCase,
      resendOTPUseCase: _resendOTPUseCase,
      loadUserDetailsFromTokenUseCase: _loadUserDetailsFromTokenUseCase,
      setAccessPinForUserUseCase: _setAccessPinForUserUseCase,
      testActivationCode: _pollingCode,
      delay: 1,
    ),
    act: (c) => c.checkBranchActivationCode(),
    expect: () => [
      pollingState.copyWith(
        error: BranchActivationError.none,
        action: BranchActivationAction.activationCode,
      ),
      pollingState.copyWith(
        error: BranchActivationError.none,
        action: BranchActivationAction.activationCode,
        activationResponse: _codeSuccessResult,
      ),
      pollingState.copyWith(
        busy: true,
        error: BranchActivationError.none,
        action: BranchActivationAction.userRetrieval,
        activationResponse: _codeSuccessResult,
      ),
      pollingState.copyWith(
        busy: false,
        error: BranchActivationError.none,
        action: BranchActivationAction.userRetrieval,
        activationResponse: _codeSuccessResult,
        user: _user,
      ),
    ],
    verify: (c) {
      verify(
        () => _checkBranchActivationCodeUseCase(
          code: _pollingCode,
        ),
      ).called(2);

      verify(
        () => _loadUserDetailsFromTokenUseCase(
          token: _successUserToken,
        ),
      ).called(1);
    },
  );

  final successState = BranchActivationState(
    activationCode: _successCode,
  );

  blocTest<BranchActivationCubit, BranchActivationState>(
    'gets response without polling and gets user',
    build: () => BranchActivationCubit(
      checkBranchActivationCodeUseCase: _checkBranchActivationCodeUseCase,
      verifyOTPForBranchActivationUseCase: _verifyOTPForBranchActivationUseCase,
      resendOTPUseCase: _resendOTPUseCase,
      loadUserDetailsFromTokenUseCase: _loadUserDetailsFromTokenUseCase,
      setAccessPinForUserUseCase: _setAccessPinForUserUseCase,
      testActivationCode: _successCode,
      delay: 1,
    ),
    act: (c) => c.checkBranchActivationCode(),
    expect: () => [
      successState.copyWith(
        error: BranchActivationError.none,
        action: BranchActivationAction.activationCode,
      ),
      successState.copyWith(
        error: BranchActivationError.none,
        action: BranchActivationAction.activationCode,
        activationResponse: _codeSuccessResult,
      ),
      successState.copyWith(
        busy: true,
        error: BranchActivationError.none,
        action: BranchActivationAction.userRetrieval,
        activationResponse: _codeSuccessResult,
      ),
      successState.copyWith(
        busy: false,
        error: BranchActivationError.none,
        action: BranchActivationAction.userRetrieval,
        activationResponse: _codeSuccessResult,
        user: _user,
      ),
    ],
    verify: (c) {
      verify(
        () => _checkBranchActivationCodeUseCase(
          code: _successCode,
        ),
      ).called(1);

      verify(
        () => _loadUserDetailsFromTokenUseCase(
          token: _successUserToken,
        ),
      ).called(1);
    },
  );

  final otpState = BranchActivationState(
    activationCode: _otpCode,
  );

  blocTest<BranchActivationCubit, BranchActivationState>(
    'gets second factor method when checking the activation code',
    build: () => BranchActivationCubit(
      checkBranchActivationCodeUseCase: _checkBranchActivationCodeUseCase,
      verifyOTPForBranchActivationUseCase: _verifyOTPForBranchActivationUseCase,
      resendOTPUseCase: _resendOTPUseCase,
      loadUserDetailsFromTokenUseCase: _loadUserDetailsFromTokenUseCase,
      setAccessPinForUserUseCase: _setAccessPinForUserUseCase,
      testActivationCode: _otpCode,
      delay: 1,
    ),
    act: (c) => c.checkBranchActivationCode(),
    expect: () => [
      otpState.copyWith(
        error: BranchActivationError.none,
        action: BranchActivationAction.activationCode,
      ),
      otpState.copyWith(
        error: BranchActivationError.none,
        action: BranchActivationAction.activationCode,
        activationResponse: _codeOtpResult,
      ),
    ],
    verify: (c) {
      verify(
        () => _checkBranchActivationCodeUseCase(
          code: _otpCode,
        ),
      ).called(1);
    },
  );

  blocTest<BranchActivationCubit, BranchActivationState>(
    'reset the activation code',
    build: () => BranchActivationCubit(
      checkBranchActivationCodeUseCase: _checkBranchActivationCodeUseCase,
      verifyOTPForBranchActivationUseCase: _verifyOTPForBranchActivationUseCase,
      resendOTPUseCase: _resendOTPUseCase,
      loadUserDetailsFromTokenUseCase: _loadUserDetailsFromTokenUseCase,
      setAccessPinForUserUseCase: _setAccessPinForUserUseCase,
      delay: 1,
    ),
    seed: () => BranchActivationState(
      activationCode: _otpCode,
    ),
    act: (c) => c.checkBranchActivationCode(resetCode: true),
    verify: (c) {
      c.state.activationCode != _otpCode;
    },
  );

  final netExceptionState = BranchActivationState(
    activationCode: _netExceptionCode,
  );

  blocTest<BranchActivationCubit, BranchActivationState>(
    'net exception',
    build: () => BranchActivationCubit(
      checkBranchActivationCodeUseCase: _checkBranchActivationCodeUseCase,
      verifyOTPForBranchActivationUseCase: _verifyOTPForBranchActivationUseCase,
      resendOTPUseCase: _resendOTPUseCase,
      loadUserDetailsFromTokenUseCase: _loadUserDetailsFromTokenUseCase,
      setAccessPinForUserUseCase: _setAccessPinForUserUseCase,
      delay: 1,
      testActivationCode: _netExceptionCode,
    ),
    act: (c) => c.checkBranchActivationCode(),
    expect: () => [
      netExceptionState.copyWith(
        error: BranchActivationError.none,
        action: BranchActivationAction.activationCode,
      ),
      netExceptionState.copyWith(
        error: BranchActivationError.network,
        action: BranchActivationAction.activationCode,
        errorMessage: _netException.message,
      ),
    ],
    verify: (c) {
      verify(
        () => _checkBranchActivationCodeUseCase(
          code: _netExceptionCode,
        ),
      ).called(1);
    },
  );

  final genericExceptionState = BranchActivationState(
    activationCode: _genericExceptionCode,
  );

  blocTest<BranchActivationCubit, BranchActivationState>(
    'generic exception',
    build: () => BranchActivationCubit(
      checkBranchActivationCodeUseCase: _checkBranchActivationCodeUseCase,
      verifyOTPForBranchActivationUseCase: _verifyOTPForBranchActivationUseCase,
      resendOTPUseCase: _resendOTPUseCase,
      loadUserDetailsFromTokenUseCase: _loadUserDetailsFromTokenUseCase,
      setAccessPinForUserUseCase: _setAccessPinForUserUseCase,
      delay: 1,
      testActivationCode: _genericExceptionCode,
    ),
    act: (c) => c.checkBranchActivationCode(),
    expect: () => [
      genericExceptionState.copyWith(
        error: BranchActivationError.none,
        action: BranchActivationAction.activationCode,
      ),
      genericExceptionState.copyWith(
        error: BranchActivationError.generic,
        action: BranchActivationAction.activationCode,
      ),
    ],
    verify: (c) {
      verify(
        () => _checkBranchActivationCodeUseCase(
          code: _genericExceptionCode,
        ),
      ).called(1);
    },
  );
}

void _otpTests() {
  final defaultState = BranchActivationState(
    activationCode: '',
  );

  blocTest<BranchActivationCubit, BranchActivationState>(
    'gets response when sending opt value and gets user',
    build: () => BranchActivationCubit(
      checkBranchActivationCodeUseCase: _checkBranchActivationCodeUseCase,
      verifyOTPForBranchActivationUseCase: _verifyOTPForBranchActivationUseCase,
      resendOTPUseCase: _resendOTPUseCase,
      loadUserDetailsFromTokenUseCase: _loadUserDetailsFromTokenUseCase,
      setAccessPinForUserUseCase: _setAccessPinForUserUseCase,
      testActivationCode: '',
      delay: 1,
    ),
    act: (c) => c.verifyOTP(_successOtp),
    expect: () => [
      defaultState.copyWith(
        error: BranchActivationError.none,
        action: BranchActivationAction.otpCheck,
      ),
      defaultState.copyWith(
        error: BranchActivationError.none,
        action: BranchActivationAction.otpCheck,
        activationResponse: _codeSuccessResult,
      ),
      defaultState.copyWith(
        busy: true,
        error: BranchActivationError.none,
        action: BranchActivationAction.userRetrieval,
        activationResponse: _codeSuccessResult,
      ),
      defaultState.copyWith(
        busy: false,
        error: BranchActivationError.none,
        action: BranchActivationAction.userRetrieval,
        activationResponse: _codeSuccessResult,
        user: _user,
      ),
    ],
    verify: (c) {
      verify(
        () => _verifyOTPForBranchActivationUseCase(
          code: any(named: 'code'),
          otpValue: _successOtp,
        ),
      ).called(1);

      verify(
        () => _loadUserDetailsFromTokenUseCase(
          token: _successUserToken,
        ),
      ).called(1);
    },
  );

  blocTest<BranchActivationCubit, BranchActivationState>(
    'net exception on verify otp',
    build: () => BranchActivationCubit(
      checkBranchActivationCodeUseCase: _checkBranchActivationCodeUseCase,
      verifyOTPForBranchActivationUseCase: _verifyOTPForBranchActivationUseCase,
      resendOTPUseCase: _resendOTPUseCase,
      loadUserDetailsFromTokenUseCase: _loadUserDetailsFromTokenUseCase,
      setAccessPinForUserUseCase: _setAccessPinForUserUseCase,
      testActivationCode: '',
      delay: 1,
    ),
    act: (c) => c.verifyOTP(_netExceptionOtp),
    expect: () => [
      defaultState.copyWith(
        error: BranchActivationError.none,
        action: BranchActivationAction.otpCheck,
      ),
      defaultState.copyWith(
        error: BranchActivationError.network,
        action: BranchActivationAction.otpCheck,
        errorMessage: _netException.message,
      ),
    ],
    verify: (c) {
      verify(
        () => _verifyOTPForBranchActivationUseCase(
          code: any(named: 'code'),
          otpValue: _netExceptionOtp,
        ),
      ).called(1);
    },
  );

  blocTest<BranchActivationCubit, BranchActivationState>(
    'generic exception on verify otp',
    build: () => BranchActivationCubit(
      checkBranchActivationCodeUseCase: _checkBranchActivationCodeUseCase,
      verifyOTPForBranchActivationUseCase: _verifyOTPForBranchActivationUseCase,
      resendOTPUseCase: _resendOTPUseCase,
      loadUserDetailsFromTokenUseCase: _loadUserDetailsFromTokenUseCase,
      setAccessPinForUserUseCase: _setAccessPinForUserUseCase,
      testActivationCode: '',
      delay: 1,
    ),
    act: (c) => c.verifyOTP(_genericExceptionOtp),
    expect: () => [
      defaultState.copyWith(
        error: BranchActivationError.none,
        action: BranchActivationAction.otpCheck,
      ),
      defaultState.copyWith(
        error: BranchActivationError.generic,
        action: BranchActivationAction.otpCheck,
      ),
    ],
    verify: (c) {
      verify(
        () => _verifyOTPForBranchActivationUseCase(
          code: any(named: 'code'),
          otpValue: _genericExceptionOtp,
        ),
      ).called(1);
    },
  );

  final successResponse = BranchActivationResponse(
    secondFactorVerification: SecondFactorVerification(
      id: int.parse(_successOtp),
      type: SecondFactorType.otp,
    ),
  );

  blocTest<BranchActivationCubit, BranchActivationState>(
    'resends otp successfully',
    build: () => BranchActivationCubit(
      checkBranchActivationCodeUseCase: _checkBranchActivationCodeUseCase,
      verifyOTPForBranchActivationUseCase: _verifyOTPForBranchActivationUseCase,
      resendOTPUseCase: _resendOTPUseCase,
      loadUserDetailsFromTokenUseCase: _loadUserDetailsFromTokenUseCase,
      setAccessPinForUserUseCase: _setAccessPinForUserUseCase,
      testActivationCode: '',
      delay: 1,
    ),
    seed: () => defaultState.copyWith(
      activationResponse: successResponse,
    ),
    act: (c) => c.resendOTP(),
    expect: () => [
      defaultState.copyWith(
        busy: true,
        error: BranchActivationError.none,
        action: BranchActivationAction.otpCheck,
        activationResponse: successResponse,
      ),
      defaultState.copyWith(
        busy: false,
        error: BranchActivationError.none,
        action: BranchActivationAction.otpCheck,
        activationResponse: successResponse,
      ),
    ],
    verify: (c) {
      verify(
        () => _resendOTPUseCase(
          otpId: any(named: 'otpId'),
        ),
      ).called(1);
    },
  );

  final netExceptionResponse = BranchActivationResponse(
    secondFactorVerification: SecondFactorVerification(
      id: int.parse(_netExceptionOtp),
      type: SecondFactorType.otp,
    ),
  );

  blocTest<BranchActivationCubit, BranchActivationState>(
    'net exception on resend otp',
    build: () => BranchActivationCubit(
      checkBranchActivationCodeUseCase: _checkBranchActivationCodeUseCase,
      verifyOTPForBranchActivationUseCase: _verifyOTPForBranchActivationUseCase,
      resendOTPUseCase: _resendOTPUseCase,
      loadUserDetailsFromTokenUseCase: _loadUserDetailsFromTokenUseCase,
      setAccessPinForUserUseCase: _setAccessPinForUserUseCase,
      testActivationCode: '',
      delay: 1,
    ),
    seed: () => defaultState.copyWith(
      activationResponse: netExceptionResponse,
    ),
    act: (c) => c.resendOTP(),
    expect: () => [
      defaultState.copyWith(
        busy: true,
        error: BranchActivationError.none,
        action: BranchActivationAction.otpCheck,
        activationResponse: netExceptionResponse,
      ),
      defaultState.copyWith(
        busy: false,
        error: BranchActivationError.network,
        action: BranchActivationAction.otpCheck,
        errorMessage: _netException.message,
        activationResponse: netExceptionResponse,
      ),
    ],
    verify: (c) {
      verify(
        () => _resendOTPUseCase(
          otpId: any(named: 'otpId'),
        ),
      ).called(1);
    },
  );

  final genericExceptionResponse = BranchActivationResponse(
    secondFactorVerification: SecondFactorVerification(
      id: int.parse(_genericExceptionOtp),
      type: SecondFactorType.otp,
    ),
  );
  blocTest<BranchActivationCubit, BranchActivationState>(
    'generic exception on resend otp',
    build: () => BranchActivationCubit(
      checkBranchActivationCodeUseCase: _checkBranchActivationCodeUseCase,
      verifyOTPForBranchActivationUseCase: _verifyOTPForBranchActivationUseCase,
      resendOTPUseCase: _resendOTPUseCase,
      loadUserDetailsFromTokenUseCase: _loadUserDetailsFromTokenUseCase,
      setAccessPinForUserUseCase: _setAccessPinForUserUseCase,
      testActivationCode: '',
      delay: 1,
    ),
    seed: () => defaultState.copyWith(
      activationResponse: genericExceptionResponse,
    ),
    act: (c) => c.resendOTP(),
    expect: () => [
      defaultState.copyWith(
        busy: true,
        error: BranchActivationError.none,
        action: BranchActivationAction.otpCheck,
        activationResponse: genericExceptionResponse,
      ),
      defaultState.copyWith(
        busy: false,
        error: BranchActivationError.generic,
        action: BranchActivationAction.otpCheck,
        activationResponse: genericExceptionResponse,
      ),
    ],
    verify: (c) {
      verify(
        () => _resendOTPUseCase(
          otpId: any(named: 'otpId'),
        ),
      ).called(1);
    },
  );
}

void _userTests() {
  final defaultState = BranchActivationState(
    activationCode: '',
  );

  final successResponse = BranchActivationResponse(
    token: _successUserToken,
  );

  blocTest<BranchActivationCubit, BranchActivationState>(
    'gets user successfully',
    build: () => BranchActivationCubit(
      checkBranchActivationCodeUseCase: _checkBranchActivationCodeUseCase,
      verifyOTPForBranchActivationUseCase: _verifyOTPForBranchActivationUseCase,
      resendOTPUseCase: _resendOTPUseCase,
      loadUserDetailsFromTokenUseCase: _loadUserDetailsFromTokenUseCase,
      setAccessPinForUserUseCase: _setAccessPinForUserUseCase,
      testActivationCode: '',
      delay: 1,
    ),
    seed: () => defaultState.copyWith(
      activationResponse: successResponse,
    ),
    act: (c) => c.getUserDetails(),
    expect: () => [
      defaultState.copyWith(
        busy: true,
        error: BranchActivationError.none,
        action: BranchActivationAction.userRetrieval,
        activationResponse: successResponse,
      ),
      defaultState.copyWith(
        busy: false,
        error: BranchActivationError.none,
        action: BranchActivationAction.userRetrieval,
        activationResponse: successResponse,
        user: _user,
      ),
    ],
    verify: (c) {
      verify(
        () => _loadUserDetailsFromTokenUseCase(
          token: any(named: 'token'),
        ),
      ).called(1);
    },
  );

  final netExceptionResponse = BranchActivationResponse(
    token: _netExceptionUserToken,
  );

  blocTest<BranchActivationCubit, BranchActivationState>(
    'net exception on get user',
    build: () => BranchActivationCubit(
      checkBranchActivationCodeUseCase: _checkBranchActivationCodeUseCase,
      verifyOTPForBranchActivationUseCase: _verifyOTPForBranchActivationUseCase,
      resendOTPUseCase: _resendOTPUseCase,
      loadUserDetailsFromTokenUseCase: _loadUserDetailsFromTokenUseCase,
      setAccessPinForUserUseCase: _setAccessPinForUserUseCase,
      testActivationCode: '',
      delay: 1,
    ),
    seed: () => defaultState.copyWith(
      activationResponse: netExceptionResponse,
    ),
    act: (c) => c.getUserDetails(),
    expect: () => [
      defaultState.copyWith(
        busy: true,
        error: BranchActivationError.none,
        action: BranchActivationAction.userRetrieval,
        activationResponse: netExceptionResponse,
      ),
      defaultState.copyWith(
        busy: false,
        error: BranchActivationError.network,
        action: BranchActivationAction.userRetrieval,
        errorMessage: _netException.message,
        activationResponse: netExceptionResponse,
      ),
    ],
    verify: (c) {
      verify(
        () => _loadUserDetailsFromTokenUseCase(
          token: any(named: 'token'),
        ),
      ).called(1);
    },
  );

  final genericExceptionResponse = BranchActivationResponse(
    token: _genericExceptionUserToken,
  );
  blocTest<BranchActivationCubit, BranchActivationState>(
    'generic exception on get user',
    build: () => BranchActivationCubit(
      checkBranchActivationCodeUseCase: _checkBranchActivationCodeUseCase,
      verifyOTPForBranchActivationUseCase: _verifyOTPForBranchActivationUseCase,
      resendOTPUseCase: _resendOTPUseCase,
      loadUserDetailsFromTokenUseCase: _loadUserDetailsFromTokenUseCase,
      setAccessPinForUserUseCase: _setAccessPinForUserUseCase,
      testActivationCode: '',
      delay: 1,
    ),
    seed: () => defaultState.copyWith(
      activationResponse: genericExceptionResponse,
    ),
    act: (c) => c.getUserDetails(),
    expect: () => [
      defaultState.copyWith(
        busy: true,
        error: BranchActivationError.none,
        action: BranchActivationAction.userRetrieval,
        activationResponse: genericExceptionResponse,
      ),
      defaultState.copyWith(
        busy: false,
        error: BranchActivationError.generic,
        action: BranchActivationAction.userRetrieval,
        activationResponse: genericExceptionResponse,
      ),
    ],
    verify: (c) {
      verify(
        () => _loadUserDetailsFromTokenUseCase(
          token: any(named: 'token'),
        ),
      ).called(1);
    },
  );
}

void _accesPinTests() {
  final defaultState = BranchActivationState(
    activationCode: '',
    activationResponse: BranchActivationResponse(token: ''),
  );

  blocTest<BranchActivationCubit, BranchActivationState>(
    'set access pin successfully',
    build: () => BranchActivationCubit(
      checkBranchActivationCodeUseCase: _checkBranchActivationCodeUseCase,
      verifyOTPForBranchActivationUseCase: _verifyOTPForBranchActivationUseCase,
      resendOTPUseCase: _resendOTPUseCase,
      loadUserDetailsFromTokenUseCase: _loadUserDetailsFromTokenUseCase,
      setAccessPinForUserUseCase: _setAccessPinForUserUseCase,
      testActivationCode: '',
      delay: 1,
    ),
    seed: () => defaultState,
    act: (c) => c.setAccessPin(_successAccessPin),
    expect: () => [
      defaultState.copyWith(
        busy: true,
        error: BranchActivationError.none,
        action: BranchActivationAction.setAccessPin,
      ),
      defaultState.copyWith(
        busy: false,
        error: BranchActivationError.none,
        action: BranchActivationAction.setAccessPin,
        user: _user,
      ),
    ],
    verify: (c) {
      verify(
        () => _setAccessPinForUserUseCase(
          pin: _successAccessPin,
          token: any(named: 'token'),
        ),
      ).called(1);
    },
  );

  blocTest<BranchActivationCubit, BranchActivationState>(
    'net exception on set access pin',
    build: () => BranchActivationCubit(
      checkBranchActivationCodeUseCase: _checkBranchActivationCodeUseCase,
      verifyOTPForBranchActivationUseCase: _verifyOTPForBranchActivationUseCase,
      resendOTPUseCase: _resendOTPUseCase,
      loadUserDetailsFromTokenUseCase: _loadUserDetailsFromTokenUseCase,
      setAccessPinForUserUseCase: _setAccessPinForUserUseCase,
      testActivationCode: '',
      delay: 1,
    ),
    seed: () => defaultState,
    act: (c) => c.setAccessPin(_netExceptionAccessPin),
    expect: () => [
      defaultState.copyWith(
        busy: true,
        error: BranchActivationError.none,
        action: BranchActivationAction.setAccessPin,
      ),
      defaultState.copyWith(
        busy: false,
        error: BranchActivationError.network,
        action: BranchActivationAction.setAccessPin,
        errorMessage: _netException.message,
      ),
    ],
    verify: (c) {
      verify(
        () => _setAccessPinForUserUseCase(
          pin: _netExceptionAccessPin,
          token: any(named: 'token'),
        ),
      ).called(1);
    },
  );

  blocTest<BranchActivationCubit, BranchActivationState>(
    'generic exception on set access pin',
    build: () => BranchActivationCubit(
      checkBranchActivationCodeUseCase: _checkBranchActivationCodeUseCase,
      verifyOTPForBranchActivationUseCase: _verifyOTPForBranchActivationUseCase,
      resendOTPUseCase: _resendOTPUseCase,
      loadUserDetailsFromTokenUseCase: _loadUserDetailsFromTokenUseCase,
      setAccessPinForUserUseCase: _setAccessPinForUserUseCase,
      testActivationCode: '',
      delay: 1,
    ),
    seed: () => defaultState,
    act: (c) => c.setAccessPin(_genericExceptionAccessPin),
    expect: () => [
      defaultState.copyWith(
        busy: true,
        error: BranchActivationError.none,
        action: BranchActivationAction.setAccessPin,
      ),
      defaultState.copyWith(
        busy: false,
        error: BranchActivationError.generic,
        action: BranchActivationAction.setAccessPin,
      ),
    ],
    verify: (c) {
      verify(
        () => _setAccessPinForUserUseCase(
          pin: _genericExceptionAccessPin,
          token: any(named: 'token'),
        ),
      ).called(1);
    },
  );
}
