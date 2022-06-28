import 'package:equatable/equatable.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:layer_sdk/domain_layer/abstract_repositories.dart';
import 'package:layer_sdk/domain_layer/use_cases.dart';
import 'package:mocktail/mocktail.dart';

class MockUserRepository extends Mock implements UserRepositoryInterface {}

void main() {
  EquatableConfig.stringify = true;

  late MockUserRepository _repository;
  late PatchUserBlockedChannelUseCase _pathUserBlockedChannelUseCase;

  setUp(() {
    _repository = MockUserRepository();
    _pathUserBlockedChannelUseCase = PatchUserBlockedChannelUseCase(
      repository: _repository,
    );

    when(
      () => _pathUserBlockedChannelUseCase(
        userId: any(named: 'userId'),
        channels: any(named: 'channels'),
      ),
    ).thenAnswer(
      (_) async => true,
    );
  });

  test('Should return a true value', () async {
    final response = await _pathUserBlockedChannelUseCase(
      userId: 'userId',
      channels: ['channel'],
    );

    expect(response, true);

    verify(
      () => _repository.patchUserBlockedChannels(
        userId: any(named: 'userId'),
        channels: any(named: 'channels'),
      ),
    ).called(1);

    verifyNoMoreInteractions(_repository);
  });
}
