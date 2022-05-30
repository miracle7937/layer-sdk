import 'package:bloc_test/bloc_test.dart';
import 'package:layer_sdk/_migration/business_layer/business_layer.dart';
import 'package:layer_sdk/_migration/data_layer/data_layer.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockMessageRepository extends Mock implements MessageRepository {}

late MockMessageRepository _repo;

final _failRefresh = true;
final _successRefresh = false;

void main() {
  _repo = MockMessageRepository();

  final mockedMessages = List.generate(
    20,
    (index) => Message(
      id: index.toString(),
      message: 'Message $index',
      module: 'Mock module',
    ),
  );

  when(
    () => _repo.getMessages(forceRefresh: _successRefresh),
  ).thenAnswer(
    (_) async => mockedMessages,
  );

  when(
    () => _repo.getMessages(forceRefresh: _failRefresh),
  ).thenAnswer(
    (_) async => throw Exception('Some error'),
  );

  blocTest<MessageCubit, MessageState>(
    'starts with empty state',
    build: () => MessageCubit(
      messageRepository: _repo,
    ),
    verify: (c) => expect(c.state, MessageState()),
  );

  blocTest<MessageCubit, MessageState>(
    'get messages retrieves the list of messages',
    build: () => MessageCubit(
      messageRepository: _repo,
    ),
    act: (c) => c.load(forceRefresh: _successRefresh),
    expect: () => [
      MessageState(
        busy: true,
      ),
      MessageState(
        busy: false,
        error: MessageStateErrors.none,
        messages: mockedMessages,
      ),
    ],
    verify: (c) => verify(
      () => _repo.getMessages(
        forceRefresh: _successRefresh,
      ),
    ).called(1),
  );

  blocTest<MessageCubit, MessageState>(
    'get messages emits error on failure',
    build: () => MessageCubit(
      messageRepository: _repo,
    ),
    act: (c) => c.load(forceRefresh: _failRefresh),
    expect: () => [
      MessageState(
        busy: true,
      ),
      MessageState(
        busy: false,
        error: MessageStateErrors.generic,
        messages: [],
      ),
    ],
    verify: (c) => verify(
      () => _repo.getMessages(
        forceRefresh: _failRefresh,
      ),
    ).called(1),
  );
}
