import 'package:bloc_test/bloc_test.dart';
import 'package:layer_sdk/domain_layer/models.dart';
import 'package:layer_sdk/domain_layer/use_cases.dart';
import 'package:layer_sdk/presentation_layer/cubits.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class MockLoadMessagesUseCase extends Mock implements LoadMessageUseCase {}

late MockLoadMessagesUseCase _mockloadMessagesUseCase;

final _failRefresh = true;
final _successRefresh = false;

void main() {
  _mockloadMessagesUseCase = MockLoadMessagesUseCase();

  final mockedMessages = List.generate(
    20,
    (index) => Message(
      id: index.toString(),
      message: 'Message $index',
      module: 'Mock module',
    ),
  );

  when(
    () => _mockloadMessagesUseCase(forceRefresh: _successRefresh),
  ).thenAnswer(
    (_) async => mockedMessages,
  );

  when(
    () => _mockloadMessagesUseCase(forceRefresh: _failRefresh),
  ).thenAnswer(
    (_) async => throw Exception('Some error'),
  );

  blocTest<MessageCubit, MessageState>(
    'starts with empty state',
    build: () => MessageCubit(loadMessageUseCase: _mockloadMessagesUseCase),
    verify: (c) => expect(c.state, MessageState()),
  );

  blocTest<MessageCubit, MessageState>(
    'get messages retrieves the list of messages',
    build: () => MessageCubit(
      loadMessageUseCase: _mockloadMessagesUseCase,
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
      () => _mockloadMessagesUseCase(
        forceRefresh: _successRefresh,
      ),
    ).called(1),
  );

  blocTest<MessageCubit, MessageState>(
    'get messages emits error on failure',
    build: () => MessageCubit(
      loadMessageUseCase: _mockloadMessagesUseCase,
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
      () => _mockloadMessagesUseCase(
        forceRefresh: _failRefresh,
      ),
    ).called(1),
  );
}
