import 'package:bloc_test/bloc_test.dart';
import 'package:equatable/equatable.dart';
import 'package:layer_sdk/data_layer/network.dart';
import 'package:layer_sdk/domain_layer/use_cases.dart';
import 'package:layer_sdk/presentation_layer/cubits.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockLoadUnreadAlertsCountUseCase extends Mock
    implements LoadUnreadAlertsUseCase {}

late MockLoadUnreadAlertsCountUseCase _loadUnreadAlertsUseCase;
late UnreadAlertsCountCubit _cubit;

void main() {
  EquatableConfig.stringify = true;

  setUp(
    () {
      _loadUnreadAlertsUseCase = MockLoadUnreadAlertsCountUseCase();
      _cubit = UnreadAlertsCountCubit(
        loadUnreadAlertsUseCase: _loadUnreadAlertsUseCase,
      );

      ///Test case for retreiving the unread alerts count
      when(
        () => _loadUnreadAlertsUseCase(forceRefresh: true),
      ).thenAnswer((_) async => 10);
    },
  );

  blocTest<UnreadAlertsCountCubit, UnreadAlertsCountState>(
    'Starts with empty state',
    build: () => _cubit,
    verify: (c) => expect(
      c.state,
      UnreadAlertsCountState(),
    ),
  );

  blocTest<UnreadAlertsCountCubit, UnreadAlertsCountState>(
    'Fetch unread alerts count',
    build: () => _cubit,
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
    build: () => _cubit,
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
    build: () => _cubit,
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
    build: () => _cubit,
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
    build: () => _cubit,
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
        () => _loadUnreadAlertsUseCase(forceRefresh: true),
      ).thenThrow(
        NetException(message: 'net exception'),
      );
    });
    blocTest<UnreadAlertsCountCubit, UnreadAlertsCountState>(
      'Should handle network exception on fetch unread alerts count',
      build: () => _cubit,
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
        () => _loadUnreadAlertsUseCase(forceRefresh: true),
      ).thenThrow(
        Exception(),
      );
    });
    blocTest<UnreadAlertsCountCubit, UnreadAlertsCountState>(
      'Should handle generic error on fetch unread alerts count',
      build: () => _cubit,
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
