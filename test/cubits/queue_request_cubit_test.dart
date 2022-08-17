import 'package:bloc_test/bloc_test.dart';
import 'package:equatable/equatable.dart';
import 'package:layer_sdk/data_layer/network.dart';
import 'package:layer_sdk/layer_sdk.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockLoadQueuesUseCase extends Mock implements LoadQueuesUseCase {}

class MockAcceptQueueUseCase extends Mock implements AcceptQueueUseCase {}

class MockRejectQueueUseCase extends Mock implements RejectQueueUseCase {}

late MockLoadQueuesUseCase _loadQueuesUseCase;
late MockAcceptQueueUseCase _acceptQueueUseCase;
late MockRejectQueueUseCase _rejectQueueUseCase;

late QueueRequestCubit _cubit;

final _defaultLimit = 10;

final _networkErrorLimit = 1337;
final _genericErrorLimit = 7331;

void main() {
  EquatableConfig.stringify = true;

  final mockedRequests = List.generate(
    25,
    (index) => QueueRequest(
      id: index.toString(),
      creationDate: DateTime.now(),
      makerId: 'Test Console User',
      isRequest: true,
    ),
  );

  group('Success cases', () {
    setUp(() {
      _loadQueuesUseCase = MockLoadQueuesUseCase();
      _acceptQueueUseCase = MockAcceptQueueUseCase();
      _rejectQueueUseCase = MockRejectQueueUseCase();

      _cubit = QueueRequestCubit(
        loadQueuesUseCase: _loadQueuesUseCase,
        acceptQueueUseCase: _acceptQueueUseCase,
        rejectQueueUseCase: _rejectQueueUseCase,
      );

      /// Test case that retrieves a portion of requests successfully
      /// This is the first load, so offset == 0
      when(
        () => _loadQueuesUseCase(
          limit: _defaultLimit,
          offset: 0,
          forceRefresh: any(named: 'forceRefresh'),
        ),
      ).thenAnswer((_) async => mockedRequests.take(_defaultLimit).toList());

      /// Test case that retrieves a portion of requests successfully
      when(
        () => _loadQueuesUseCase(
          limit: _defaultLimit,
          offset: _defaultLimit,
          forceRefresh: any(named: 'forceRefresh'),
        ),
      ).thenAnswer((_) async =>
          mockedRequests.skip(_defaultLimit).take(_defaultLimit).toList());

      /// Test case that retrieves the next portion of requests successfully
      when(
        () => _loadQueuesUseCase(
          limit: _defaultLimit,
          offset: _defaultLimit * 2,
          forceRefresh: any(named: 'forceRefresh'),
        ),
      ).thenAnswer(
          (_) async => mockedRequests.skip(_defaultLimit * 2).toList());

      /// Test case that approves a request successfully
      when(
        () => _acceptQueueUseCase(
          mockedRequests.first.id!,
          isRequest: true,
        ),
      ).thenAnswer((_) async => true);

      /// Test case that rejects a request successfully
      when(
        () => _rejectQueueUseCase(
          mockedRequests.first.id!,
          isRequest: true,
        ),
      ).thenAnswer((_) async => true);
    });

    blocTest<QueueRequestCubit, QueueRequestStates>(
      'Starts with empty state',
      build: () => _cubit,
      verify: (c) => expect(
        c.state,
        QueueRequestStates(),
      ),
    );

    blocTest<QueueRequestCubit, QueueRequestStates>(
      'Does first load successfully',
      build: () => _cubit,
      act: (c) => c.load(loadMore: false),
      seed: () => QueueRequestStates(
        limit: _defaultLimit,
      ),
      expect: () => [
        QueueRequestStates(
          action: QueueRequestStateActionResults.none,
          busy: true,
          busyOnFirstLoad: true,
          canLoadMore: false,
          error: QueueRequestStatesErrors.none,
          offset: 0,
          requests: [],
          limit: _defaultLimit,
        ),
        QueueRequestStates(
          action: QueueRequestStateActionResults.none,
          busy: false,
          busyOnFirstLoad: false,
          canLoadMore: true,
          error: QueueRequestStatesErrors.none,
          offset: 0,
          requests: mockedRequests.take(_defaultLimit).toList(),
          limit: _defaultLimit,
        ),
      ],
    );

    blocTest<QueueRequestCubit, QueueRequestStates>(
      'Loads next page successfully',
      build: () => _cubit,
      act: (c) => c.load(loadMore: true),
      seed: () => QueueRequestStates(
        action: QueueRequestStateActionResults.none,
        busy: false,
        busyOnFirstLoad: false,
        canLoadMore: true,
        error: QueueRequestStatesErrors.none,
        requests: mockedRequests.take(_defaultLimit).toList(),
        limit: _defaultLimit,
      ),
      expect: () => [
        QueueRequestStates(
          action: QueueRequestStateActionResults.none,
          busy: true,
          busyOnFirstLoad: false,
          canLoadMore: true,
          error: QueueRequestStatesErrors.none,
          requests: mockedRequests.take(_defaultLimit).toList(),
          limit: _defaultLimit,
        ),
        QueueRequestStates(
          action: QueueRequestStateActionResults.none,
          busy: false,
          busyOnFirstLoad: false,
          canLoadMore: true,
          error: QueueRequestStatesErrors.none,
          offset: _defaultLimit,
          requests: mockedRequests.take(_defaultLimit * 2).toList(),
          limit: _defaultLimit,
        ),
      ],
    );

    blocTest<QueueRequestCubit, QueueRequestStates>(
      'Sets canLoadMore to false when no more items left to load',
      build: () => _cubit,
      act: (c) => c.load(loadMore: true),
      seed: () => QueueRequestStates(
        offset: _defaultLimit,
        action: QueueRequestStateActionResults.none,
        busy: false,
        busyOnFirstLoad: false,
        canLoadMore: true,
        error: QueueRequestStatesErrors.none,
        requests: mockedRequests.take(_defaultLimit * 2).toList(),
        limit: _defaultLimit,
      ),
      expect: () => [
        QueueRequestStates(
          offset: _defaultLimit,
          action: QueueRequestStateActionResults.none,
          busy: true,
          busyOnFirstLoad: false,
          canLoadMore: true,
          error: QueueRequestStatesErrors.none,
          requests: mockedRequests.take(_defaultLimit * 2).toList(),
          limit: _defaultLimit,
        ),
        QueueRequestStates(
          action: QueueRequestStateActionResults.none,
          busy: false,
          busyOnFirstLoad: false,
          canLoadMore: false,
          error: QueueRequestStatesErrors.none,
          offset: _defaultLimit * 2,
          requests: mockedRequests,
          limit: _defaultLimit,
        ),
      ],
    );

    blocTest<QueueRequestCubit, QueueRequestStates>(
      'Approves request successfully',
      build: () => _cubit,
      act: (c) => c.acceptRequest(mockedRequests.first),
      seed: () => QueueRequestStates(
        offset: _defaultLimit,
        action: QueueRequestStateActionResults.none,
        busy: false,
        busyOnFirstLoad: false,
        canLoadMore: true,
        error: QueueRequestStatesErrors.none,
        requests: mockedRequests.take(_defaultLimit).toList(),
        limit: _defaultLimit,
      ),
      expect: () => [
        QueueRequestStates(
          offset: _defaultLimit,
          action: QueueRequestStateActionResults.none,
          busy: true,
          busyOnFirstLoad: false,
          canLoadMore: true,
          error: QueueRequestStatesErrors.none,
          requests: mockedRequests.take(_defaultLimit).toList(),
          limit: _defaultLimit,
        ),
        QueueRequestStates(
          offset: _defaultLimit,
          action: QueueRequestStateActionResults.approvedRequest,
          busy: false,
          busyOnFirstLoad: false,
          canLoadMore: true,
          error: QueueRequestStatesErrors.none,
          requests: mockedRequests.take(_defaultLimit).toList()..removeAt(0),
          limit: _defaultLimit,
        ),
      ],
    );

    blocTest<QueueRequestCubit, QueueRequestStates>(
      'Rejects request successfully',
      build: () => _cubit,
      act: (c) => c.rejectRequest(mockedRequests.first),
      seed: () => QueueRequestStates(
        offset: _defaultLimit,
        action: QueueRequestStateActionResults.none,
        busy: false,
        busyOnFirstLoad: false,
        canLoadMore: true,
        error: QueueRequestStatesErrors.none,
        requests: mockedRequests.take(_defaultLimit).toList(),
        limit: _defaultLimit,
      ),
      expect: () => [
        QueueRequestStates(
          offset: _defaultLimit,
          action: QueueRequestStateActionResults.none,
          busy: true,
          busyOnFirstLoad: false,
          canLoadMore: true,
          error: QueueRequestStatesErrors.none,
          requests: mockedRequests.take(_defaultLimit).toList(),
          limit: _defaultLimit,
        ),
        QueueRequestStates(
          offset: _defaultLimit,
          action: QueueRequestStateActionResults.rejectedRequest,
          busy: false,
          busyOnFirstLoad: false,
          canLoadMore: true,
          error: QueueRequestStatesErrors.none,
          requests: mockedRequests.take(_defaultLimit).toList()..removeAt(0),
          limit: _defaultLimit,
        ),
      ],
    );
  });

  group('Error cases', () {
    setUp(() {
      _loadQueuesUseCase = MockLoadQueuesUseCase();
      _acceptQueueUseCase = MockAcceptQueueUseCase();
      _rejectQueueUseCase = MockRejectQueueUseCase();

      _cubit = QueueRequestCubit(
        loadQueuesUseCase: _loadQueuesUseCase,
        acceptQueueUseCase: _acceptQueueUseCase,
        rejectQueueUseCase: _rejectQueueUseCase,
      );

      /// Test case that throws network exception when trying to load requests
      when(
        () => _loadQueuesUseCase(
          limit: _networkErrorLimit,
          offset: any(named: 'offset'),
          forceRefresh: any(named: 'forceRefresh'),
        ),
      ).thenThrow(
        NetException(message: 'Some network error'),
      );

      /// Test case that throws generic exception when trying to load requests
      when(
        () => _loadQueuesUseCase(
          limit: _genericErrorLimit,
          offset: any(named: 'offset'),
          forceRefresh: any(named: 'forceRefresh'),
        ),
      ).thenThrow(
        Exception('Some error'),
      );

      /// Test case that fails when approving a request
      when(
        () => _acceptQueueUseCase(
          mockedRequests.first.id!,
          isRequest: true,
        ),
      ).thenAnswer((_) async => false);

      /// Test case that fails when rejecting a request
      when(
        () => _rejectQueueUseCase(
          mockedRequests.first.id!,
          isRequest: true,
        ),
      ).thenAnswer((_) async => false);
    });

    blocTest<QueueRequestCubit, QueueRequestStates>(
      'Should handle network error',
      build: () => _cubit,
      act: (c) => c.load(),
      seed: () => QueueRequestStates(
        limit: _networkErrorLimit,
      ),
      expect: () => [
        QueueRequestStates(
          action: QueueRequestStateActionResults.none,
          busy: true,
          busyOnFirstLoad: true,
          error: QueueRequestStatesErrors.none,
          requests: [],
          limit: _networkErrorLimit,
        ),
        QueueRequestStates(
          action: QueueRequestStateActionResults.none,
          busy: false,
          busyOnFirstLoad: false,
          error: QueueRequestStatesErrors.network,
          requests: [],
          limit: _networkErrorLimit,
        ),
      ],
      errors: () => [
        isA<NetException>(),
      ],
    );

    blocTest<QueueRequestCubit, QueueRequestStates>(
      'Should handle generic error',
      build: () => _cubit,
      act: (c) => c.load(),
      seed: () => QueueRequestStates(
        limit: _genericErrorLimit,
      ),
      expect: () => [
        QueueRequestStates(
          action: QueueRequestStateActionResults.none,
          busy: true,
          busyOnFirstLoad: true,
          error: QueueRequestStatesErrors.none,
          requests: [],
          limit: _genericErrorLimit,
        ),
        QueueRequestStates(
          action: QueueRequestStateActionResults.none,
          busy: false,
          busyOnFirstLoad: false,
          error: QueueRequestStatesErrors.generic,
          requests: [],
          limit: _genericErrorLimit,
        ),
      ],
      errors: () => [
        isA<Exception>(),
      ],
    );

    blocTest<QueueRequestCubit, QueueRequestStates>(
      'Correct error when failling to approve request',
      build: () => _cubit,
      act: (c) => c.acceptRequest(mockedRequests.first),
      seed: () => QueueRequestStates(
        offset: _defaultLimit,
        action: QueueRequestStateActionResults.none,
        busy: false,
        busyOnFirstLoad: false,
        canLoadMore: true,
        error: QueueRequestStatesErrors.none,
        requests: mockedRequests.take(_defaultLimit).toList(),
      ),
      expect: () => [
        QueueRequestStates(
          offset: _defaultLimit,
          action: QueueRequestStateActionResults.none,
          busy: true,
          busyOnFirstLoad: false,
          canLoadMore: true,
          error: QueueRequestStatesErrors.none,
          requests: mockedRequests.take(_defaultLimit).toList(),
        ),
        QueueRequestStates(
          offset: _defaultLimit,
          action: QueueRequestStateActionResults.none,
          busy: false,
          busyOnFirstLoad: false,
          canLoadMore: true,
          error: QueueRequestStatesErrors.failedAccepting,
          requests: mockedRequests.take(_defaultLimit).toList(),
        ),
      ],
    );

    blocTest<QueueRequestCubit, QueueRequestStates>(
      'Correct error when failling to reject request',
      build: () => _cubit,
      act: (c) => c.rejectRequest(mockedRequests.first),
      seed: () => QueueRequestStates(
        offset: _defaultLimit,
        action: QueueRequestStateActionResults.none,
        busy: false,
        busyOnFirstLoad: false,
        canLoadMore: true,
        error: QueueRequestStatesErrors.none,
        requests: mockedRequests.take(_defaultLimit).toList(),
      ),
      expect: () => [
        QueueRequestStates(
          offset: _defaultLimit,
          action: QueueRequestStateActionResults.none,
          busy: true,
          busyOnFirstLoad: false,
          canLoadMore: true,
          error: QueueRequestStatesErrors.none,
          requests: mockedRequests.take(_defaultLimit).toList(),
        ),
        QueueRequestStates(
          offset: _defaultLimit,
          action: QueueRequestStateActionResults.none,
          busy: false,
          busyOnFirstLoad: false,
          canLoadMore: true,
          error: QueueRequestStatesErrors.failedRejecting,
          requests: mockedRequests.take(_defaultLimit).toList(),
        ),
      ],
    );
  });
}
