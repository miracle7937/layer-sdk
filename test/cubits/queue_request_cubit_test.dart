import 'package:bloc_test/bloc_test.dart';
import 'package:equatable/equatable.dart';
import 'package:layer_sdk/business_layer/business_layer.dart';
import 'package:layer_sdk/data_layer/data_layer.dart';
import 'package:layer_sdk/migration/data_layer/network.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockQueueRequestRepository extends Mock
    implements QueueRequestRepository {}

late MockQueueRequestRepository _repo;

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
    setUpAll(() {
      _repo = MockQueueRequestRepository();

      /// Test case that retrieves a portion of requests successfully
      /// This is the first load, so offset == 0
      when(
        () => _repo.list(
          limit: _defaultLimit,
          offset: 0,
          forceRefresh: any(named: 'forceRefresh'),
        ),
      ).thenAnswer((_) async => mockedRequests.take(_defaultLimit).toList());

      /// Test case that retrieves a portion of requests successfully
      when(
        () => _repo.list(
          limit: _defaultLimit,
          offset: _defaultLimit,
          forceRefresh: any(named: 'forceRefresh'),
        ),
      ).thenAnswer((_) async =>
          mockedRequests.skip(_defaultLimit).take(_defaultLimit).toList());

      /// Test case that retrieves the next portion of requests successfully
      when(
        () => _repo.list(
          limit: _defaultLimit,
          offset: _defaultLimit * 2,
          forceRefresh: any(named: 'forceRefresh'),
        ),
      ).thenAnswer(
          (_) async => mockedRequests.skip(_defaultLimit * 2).toList());

      /// Test case that approves a request successfully
      when(
        () => _repo.accept(
          mockedRequests.first.id!,
          isRequest: true,
        ),
      ).thenAnswer((_) async => true);

      /// Test case that rejects a request successfully
      when(
        () => _repo.reject(
          mockedRequests.first.id!,
          isRequest: true,
        ),
      ).thenAnswer((_) async => true);
    });

    blocTest<QueueRequestCubit, QueueRequestStates>(
      'Starts with empty state',
      build: () => QueueRequestCubit(
        limit: _defaultLimit,
        repository: _repo,
      ),
      verify: (c) => expect(
        c.state,
        QueueRequestStates(),
      ),
    );

    blocTest<QueueRequestCubit, QueueRequestStates>(
      'Does first load successfully',
      build: () => QueueRequestCubit(
        limit: _defaultLimit,
        repository: _repo,
      ),
      act: (c) => c.load(loadMore: false),
      expect: () => [
        QueueRequestStates(
          action: QueueRequestStateActionResults.none,
          busy: true,
          busyOnFirstLoad: true,
          canLoadMore: false,
          error: QueueRequestStatesErrors.none,
          offset: 0,
          requests: [],
        ),
        QueueRequestStates(
          action: QueueRequestStateActionResults.none,
          busy: false,
          busyOnFirstLoad: false,
          canLoadMore: true,
          error: QueueRequestStatesErrors.none,
          offset: 0,
          requests: mockedRequests.take(_defaultLimit).toList(),
        ),
      ],
    );

    blocTest<QueueRequestCubit, QueueRequestStates>(
      'Loads next page successfully',
      build: () => QueueRequestCubit(
        limit: _defaultLimit,
        repository: _repo,
      ),
      act: (c) => c.load(loadMore: true),
      seed: () => QueueRequestStates(
        action: QueueRequestStateActionResults.none,
        busy: false,
        busyOnFirstLoad: false,
        canLoadMore: true,
        error: QueueRequestStatesErrors.none,
        requests: mockedRequests.take(_defaultLimit).toList(),
      ),
      expect: () => [
        QueueRequestStates(
          action: QueueRequestStateActionResults.none,
          busy: true,
          busyOnFirstLoad: false,
          canLoadMore: true,
          error: QueueRequestStatesErrors.none,
          requests: mockedRequests.take(_defaultLimit).toList(),
        ),
        QueueRequestStates(
          action: QueueRequestStateActionResults.none,
          busy: false,
          busyOnFirstLoad: false,
          canLoadMore: true,
          error: QueueRequestStatesErrors.none,
          offset: _defaultLimit,
          requests: mockedRequests.take(_defaultLimit * 2).toList(),
        ),
      ],
    );

    blocTest<QueueRequestCubit, QueueRequestStates>(
      'Sets canLoadMore to false when no more items left to load',
      build: () => QueueRequestCubit(
        limit: _defaultLimit,
        repository: _repo,
      ),
      act: (c) => c.load(loadMore: true),
      seed: () => QueueRequestStates(
        offset: _defaultLimit,
        action: QueueRequestStateActionResults.none,
        busy: false,
        busyOnFirstLoad: false,
        canLoadMore: true,
        error: QueueRequestStatesErrors.none,
        requests: mockedRequests.take(_defaultLimit * 2).toList(),
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
        ),
        QueueRequestStates(
          action: QueueRequestStateActionResults.none,
          busy: false,
          busyOnFirstLoad: false,
          canLoadMore: false,
          error: QueueRequestStatesErrors.none,
          offset: _defaultLimit * 2,
          requests: mockedRequests,
        ),
      ],
    );

    blocTest<QueueRequestCubit, QueueRequestStates>(
      'Approves request successfully',
      build: () => QueueRequestCubit(
        limit: _defaultLimit,
        repository: _repo,
      ),
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
          action: QueueRequestStateActionResults.approvedRequest,
          busy: false,
          busyOnFirstLoad: false,
          canLoadMore: true,
          error: QueueRequestStatesErrors.none,
          requests: mockedRequests.take(_defaultLimit).toList()..removeAt(0),
        ),
      ],
    );

    blocTest<QueueRequestCubit, QueueRequestStates>(
      'Rejects request successfully',
      build: () => QueueRequestCubit(
        limit: _defaultLimit,
        repository: _repo,
      ),
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
          action: QueueRequestStateActionResults.rejectedRequest,
          busy: false,
          busyOnFirstLoad: false,
          canLoadMore: true,
          error: QueueRequestStatesErrors.none,
          requests: mockedRequests.take(_defaultLimit).toList()..removeAt(0),
        ),
      ],
    );
  });

  group('Error cases', () {
    setUpAll(() {
      _repo = MockQueueRequestRepository();

      /// Test case that throws network exception when trying to load requests
      when(
        () => _repo.list(
          limit: _networkErrorLimit,
          offset: any(named: 'offset'),
          forceRefresh: any(named: 'forceRefresh'),
        ),
      ).thenThrow(
        NetException(message: 'Some network error'),
      );

      /// Test case that throws generic exception when trying to load requests
      when(
        () => _repo.list(
          limit: _genericErrorLimit,
          offset: any(named: 'offset'),
          forceRefresh: any(named: 'forceRefresh'),
        ),
      ).thenThrow(
        Exception('Some error'),
      );

      /// Test case that fails when approving a request
      when(
        () => _repo.accept(
          mockedRequests.first.id!,
          isRequest: true,
        ),
      ).thenAnswer((_) async => false);

      /// Test case that fails when rejecting a request
      when(
        () => _repo.reject(
          mockedRequests.first.id!,
          isRequest: true,
        ),
      ).thenAnswer((_) async => false);
    });

    blocTest<QueueRequestCubit, QueueRequestStates>(
      'Should handle network error',
      build: () => QueueRequestCubit(
        repository: _repo,
        limit: _networkErrorLimit,
      ),
      act: (c) => c.load(),
      expect: () => [
        QueueRequestStates(
          action: QueueRequestStateActionResults.none,
          busy: true,
          busyOnFirstLoad: true,
          error: QueueRequestStatesErrors.none,
          requests: [],
        ),
        QueueRequestStates(
          action: QueueRequestStateActionResults.none,
          busy: false,
          busyOnFirstLoad: false,
          error: QueueRequestStatesErrors.network,
          requests: [],
        ),
      ],
      errors: () => [
        isA<NetException>(),
      ],
    );

    blocTest<QueueRequestCubit, QueueRequestStates>(
      'Should handle generic error',
      build: () => QueueRequestCubit(
        repository: _repo,
        limit: _genericErrorLimit,
      ),
      act: (c) => c.load(),
      expect: () => [
        QueueRequestStates(
          action: QueueRequestStateActionResults.none,
          busy: true,
          busyOnFirstLoad: true,
          error: QueueRequestStatesErrors.none,
          requests: [],
        ),
        QueueRequestStates(
          action: QueueRequestStateActionResults.none,
          busy: false,
          busyOnFirstLoad: false,
          error: QueueRequestStatesErrors.generic,
          requests: [],
        ),
      ],
      errors: () => [
        isA<Exception>(),
      ],
    );

    blocTest<QueueRequestCubit, QueueRequestStates>(
      'Correct error when failling to approve request',
      build: () => QueueRequestCubit(
        limit: _defaultLimit,
        repository: _repo,
      ),
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
      build: () => QueueRequestCubit(
        limit: _defaultLimit,
        repository: _repo,
      ),
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
