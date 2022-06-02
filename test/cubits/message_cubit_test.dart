import 'package:bloc_test/bloc_test.dart';
import 'package:layer_sdk/domain_layer/models.dart';
import 'package:layer_sdk/domain_layer/use_cases.dart';
import 'package:layer_sdk/presentation_layer/cubits.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

class GetMessagesUseCaseMock extends Mock implements GetMessageUseCase {}

late GetMessagesUseCaseMock _getMessagesUseCaseMock;

final _failRefresh = true;
final _successRefresh = false;

void main() {
  _getMessagesUseCaseMock = GetMessagesUseCaseMock();

  final mockedMessages = List.generate(
    20,
    (index) => Message(
      id: index.toString(),
      message: 'Message $index',
      module: 'Mock module',
    ),
  );

  when(
    () => _getMessagesUseCaseMock(forceRefresh: _successRefresh),
  ).thenAnswer(
    (_) async => mockedMessages,
  );

  when(
    () => _getMessagesUseCaseMock(forceRefresh: _failRefresh),
  ).thenAnswer(
    (_) async => throw Exception('Some error'),
  );

  blocTest<MessageCubit, MessageState>(
    'starts with empty state',
    build: () => MessageCubit(_getMessagesUseCaseMock),
    verify: (c) => expect(c.state, MessageState()),
  );

  blocTest<MessageCubit, MessageState>(
    'get messages retrieves the list of messages',
    build: () => MessageCubit(
      _getMessagesUseCaseMock,
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
      () => _getMessagesUseCaseMock(
        forceRefresh: _successRefresh,
      ),
    ).called(1),
  );

  blocTest<MessageCubit, MessageState>(
    'get messages emits error on failure',
    build: () => MessageCubit(
      _getMessagesUseCaseMock,
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
      () => _getMessagesUseCaseMock(
        forceRefresh: _failRefresh,
      ),
    ).called(1),
  );
}
