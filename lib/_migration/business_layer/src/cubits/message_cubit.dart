import 'package:bloc/bloc.dart';

import '../../../data_layer/data_layer.dart';
import '../cubits.dart';

/// Cubit responsible for retrieving the list of [Message]s
class MessageCubit extends Cubit<MessageState> {
  final MessageRepository _messageRepository;

  /// Creates a new instance of [MessageCubit]
  MessageCubit({
    required MessageRepository messageRepository,
  })  : _messageRepository = messageRepository,
        super(
          MessageState(),
        );

  /// Loads all the messages
  Future<void> load({
    bool forceRefresh = false,
  }) async {
    emit(
      state.copyWith(
        busy: true,
        error: MessageStateErrors.none,
      ),
    );

    try {
      final messages = await _messageRepository.getMessages(
        forceRefresh: forceRefresh,
      );

      emit(
        state.copyWith(
          messages: messages,
          busy: false,
        ),
      );
    } on Exception {
      emit(
        state.copyWith(
          busy: false,
          error: MessageStateErrors.generic,
        ),
      );
    }
  }
}
