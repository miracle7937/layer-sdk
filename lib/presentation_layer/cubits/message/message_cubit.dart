import 'package:bloc/bloc.dart';

import '../../../domain_layer/use_cases.dart';
import 'message_state.dart';

/// Cubit responsible for retrieving the list of [Message]s
class MessageCubit extends Cubit<MessageState> {
  /// Creates a new instance of [MessageCubit]
  MessageCubit(this._getMessageUseCase) : super(MessageState());

  final GetMessageUseCase _getMessageUseCase;

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
      final messages = await _getMessageUseCase(
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
