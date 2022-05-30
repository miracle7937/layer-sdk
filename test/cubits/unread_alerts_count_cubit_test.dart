import 'package:bloc_test/bloc_test.dart';
import 'package:equatable/equatable.dart';
import 'package:layer_sdk/business_layer/business_layer.dart';
import 'package:layer_sdk/data_layer/data_layer.dart';
import 'package:layer_sdk/migration/data_layer/network.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockAlertRepository extends Mock implements AlertRepository {}

late MockAlertRepository _repo;

void main() {
  EquatableConfig.stringify = true;

  setUp(
    () {
      _repo = MockAlertRepository();

      ///Test case for retreiving the unread alerts count
      when(
        () => _repo.getUnreadAlertsCount(forceRefresh: true),
      ).thenAnswer((_) async => 10);
    },
  );

  blocTest<UnreadAlertsCountCubit, UnreadAlertsCountState>(
    'Starts with empty state',
    build: () => UnreadAlertsCountCubit(
      repository: _repo,
    ),
    verify: (c) => expect(
      c.state,
      UnreadAlertsCountState(),
    ),
  );

  blocTest<UnreadAlertsCountCubit, UnreadAlertsCountState>(
    'Fetch unread alerts count',
    build: () => UnreadAlertsCountCubit(
      repository: _repo,
    ),
    act: (c) => c.load(),
    expect: () => [
      UnreadAlertsCountState(
        busy: true,
      ),
      UnreadAlertsCountState(
        busy: false,
        count: 10,
      ),
    ],
  );

  blocTest<UnreadAlertsCountCubit, UnreadAlertsCountState>(
    'Notifies the passed unread alerts count',
    build: () => UnreadAlertsCountCubit(
      repository: _repo,
    ),
    act: (c) => c.notify(23),
    expect: () => [
      UnreadAlertsCountState(
        busy: false,
        count: 23,
      ),
    ],
  );

  blocTest<UnreadAlertsCountCubit, UnreadAlertsCountState>(
    'Decreases the unread alerts count in 1 when the count is > 0',
    build: () => UnreadAlertsCountCubit(
      repository: _repo,
    ),
    seed: () => UnreadAlertsCountState(
      count: 10,
    ),
    act: (c) => c.decrease(),
    expect: () => [
      UnreadAlertsCountState(
        busy: false,
        count: 9,
      ),
    ],
  );

  blocTest<UnreadAlertsCountCubit, UnreadAlertsCountState>(
    'Decreases the unread alerts count in 1 when the count is equal to 0',
    build: () => UnreadAlertsCountCubit(
      repository: _repo,
    ),
    act: (c) => c.decrease(),
    expect: () => [
      UnreadAlertsCountState(
        busy: false,
        count: 0,
      ),
    ],
  );

  blocTest<UnreadAlertsCountCubit, UnreadAlertsCountState>(
    'Clears the count',
    build: () => UnreadAlertsCountCubit(
      repository: _repo,
    ),
    act: (c) => c.clear(),
    expect: () => [
      UnreadAlertsCountState(
        busy: false,
        count: 0,
      ),
    ],
  );

  group('Network exception handling', () {
    setUp(() {
      when(
        () => _repo.getUnreadAlertsCount(forceRefresh: true),
      ).thenThrow(
        NetException(message: 'net exception'),
      );
    });
    blocTest<UnreadAlertsCountCubit, UnreadAlertsCountState>(
      'Should handle network exception on fetch unread alerts count',
      build: () => UnreadAlertsCountCubit(
        repository: _repo,
      ),
      act: (c) => c.load(),
      expect: () => [
        UnreadAlertsCountState(
          busy: true,
        ),
        UnreadAlertsCountState(
          busy: false,
          errorMessage: 'net exception',
          error: UnreadAlertsCountError.network,
        ),
      ],
    );
  });

  group('Generic exception handling', () {
    setUp(() {
      when(
        () => _repo.getUnreadAlertsCount(forceRefresh: true),
      ).thenThrow(
        Exception(),
      );
    });
    blocTest<UnreadAlertsCountCubit, UnreadAlertsCountState>(
      'Should handle generic error on fetch unread alerts count',
      build: () => UnreadAlertsCountCubit(
        repository: _repo,
      ),
      act: (c) => c.load(),
      expect: () => [
        UnreadAlertsCountState(
          busy: true,
        ),
        UnreadAlertsCountState(
          busy: false,
          error: UnreadAlertsCountError.generic,
        ),
      ],
    );
  });
}
