import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data_layer/network.dart';
import '../../../../domain_layer/models.dart';
import '../../../../domain_layer/use_cases.dart';
import 'inbox_conversation_state.dart';

/// Cubit for handling the InboxConversationScreen
///
/// It loads a [InboxReport] categories, a message
/// and a list of files that can be sent to the server
class InboxConversationCubit extends Cubit<InboxConversationState> {
  final SendReportChatMessageUseCase _sendChatMessageUseCase;
  final PostInboxFilesUseCase _postInboxFilesUseCase;

  /// Creates a new [InboxConversationCubit]
  InboxConversationCubit({
    required SendReportChatMessageUseCase sendChatMessageUseCase,
    required PostInboxFilesUseCase postInboxFilesUseCase,
  })  : _postInboxFilesUseCase = postInboxFilesUseCase,
        _sendChatMessageUseCase = sendChatMessageUseCase,
        super(InboxConversationState());

  /// Include a [InboxFile]
  Future<void> addInboxFile(InboxFile file) async {
    emit(
      state.copyWith(
        filesToUpload: [
          file.copyWith(
            fileCount: state.filesToUpload.length + 1,
            status: InboxChatMessageStatus.uploading,
          ),
          ...state.filesToUpload
        ],
      ),
    );
  }

  /// Remove the [InboxFile]
  Future<void> removeInboxFile(InboxFile file) async {
    emit(
      state.copyWith(
        filesToUpload: [...state.filesToUpload]..removeWhere((f) => f == file),
      ),
    );
  }

  /// Set the text of the message
  void setMessageText(String message) {
    emit(
      state.copyWith(messageText: message),
    );
  }

  /// Loads the categories
  Future<void> load({
    required InboxReport report,
  }) async {
    try {
      emit(
        state.copyWith(
          busy: true,
          busyAction: InboxConversationBusyAction.loadingFiles,
          errorStatus: InboxConversationErrorStatus.none,
        ),
      );

      final files = [
        for (final f in report.files)
          InboxFile(
            name: f,
            status: InboxChatMessageStatus.downloaded,
            path: '/issues/${report.id}/$f',
          )
      ];

      final messages = [
        for (final m in report.messages)
          InboxChatMessage(
            message: m,
            status: InboxChatMessageStatus.uploaded,
          )
      ];

      emit(
        state.copyWith(
          busy: true,
          busyAction: InboxConversationBusyAction.idle,
          errorStatus: InboxConversationErrorStatus.none,
          uploadedFiles: files,
          messages: messages,
          report: report,
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          busy: false,
          busyAction: InboxConversationBusyAction.idle,
          errorStatus: e is NetException
              ? InboxConversationErrorStatus.network
              : InboxConversationErrorStatus.generic,
          errorMessage: e is NetException ? e.message : e.toString(),
        ),
      );

      rethrow;
    }
  }

  /// Posts a new inbox chat message
  Future<void> sendMessage({
    required String message,
    String? fileURL,
  }) async {
    try {
      emit(
        state.copyWith(
          busy: true,
          busyAction: InboxConversationBusyAction.postingMessage,
          errorStatus: InboxConversationErrorStatus.none,
        ),
      );

      final inboxReportMessage = InboxReportMessage(
        text: message,
        reportId: state.report?.id ?? 0,
        senderType: InboxReportSenderType.customer,
        tsCreated: DateTime.now(),
      );

      final inboxChatMessage = InboxChatMessage(
        message: inboxReportMessage,
        status: InboxChatMessageStatus.uploading,
        sentTime: DateTime.now(),
      );

      emit(
        state.copyWith(
          busy: true,
          busyAction: InboxConversationBusyAction.postingMessage,
          errorStatus: InboxConversationErrorStatus.none,
          messages: [
            ...state.messages,
            inboxChatMessage,
          ],
        ),
      );

      final inboxMessage = await _sendChatMessageUseCase(
        reportId: state.report!.id ?? 0,
        messageText: message,
        fileUrl: fileURL,
      );

      emit(
        state.copyWith(
          report: state.report!.copyWith(
            messages: [
              ...state.report!.messages,
              inboxMessage,
            ],
          ),
          messages: [
            ...(state.messages.sublist(0, state.messages.length - 1)),
            inboxChatMessage.copyWith(
              message: inboxMessage,
              status: InboxChatMessageStatus.uploaded,
            ),
          ],
        ),
      );
    } on Exception catch (e) {
      /// TODO - catch if the exception is a failedToSend exception, and add the last item as a failed message
      emit(
        state.copyWith(
          busy: false,
          busyAction: InboxConversationBusyAction.idle,
          messages: state.messages,
          errorStatus: e is NetException
              ? InboxConversationErrorStatus.network
              : InboxConversationErrorStatus.generic,
          errorMessage: e is NetException ? e.message : e.toString(),
        ),
      );

      rethrow;
    }
  }

  /// Upload a list of [InboxFiles]
  Future<void> uploadInboxFiles() async {
    try {
      if (state.filesToUpload.isEmpty) {
        return;
      }

      emit(
        state.copyWith(
          busy: true,
          busyAction: InboxConversationBusyAction.postingInboxFiles,
          errorStatus: InboxConversationErrorStatus.none,
        ),
      );

      /// Removes [InboxFile]s that don't have a base64 value
      /// and has uploaded status
      final _displayFiles = state.filesToUpload
          .where(
            (f) =>
                f.fileBinary != null &&
                f.status == InboxChatMessageStatus.uploading,
          )
          .toList();

      final message = InboxReportMessage(
        reportId: state.report?.id! ?? 0,
        text: state.messageText,
        senderType: InboxReportSenderType.customer,
        files: _displayFiles,
      );

      final chatMessage = InboxChatMessage(
        message: message,
        status: InboxChatMessageStatus.uploading,
        sentTime: DateTime.now(),
      );

      emit(
        state.copyWith(
          messages: [chatMessage, ...state.messages],
        ),
      );

      final sentMessage = await _postInboxFilesUseCase(
        reportId: state.report?.id! ?? 0,
        files: state.filesToUpload,
        messageText: state.messageText,
      );

      emit(
        state.copyWith(
          filesToUpload: [],
          messages: [
            ...state.messages,
            chatMessage.copyWith(
              // message: message,
              message: sentMessage,
              status: InboxChatMessageStatus.uploaded,
            ),
          ],
          report: state.report?.copyWith(
            messages: [
              ...state.report!.messages,
              // message,
              sentMessage,
            ],
          ),
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          busy: false,
          busyAction: InboxConversationBusyAction.idle,
          errorStatus: e is NetException
              ? InboxConversationErrorStatus.network
              : InboxConversationErrorStatus.generic,
          errorMessage: e is NetException ? e.message : e.toString(),
        ),
      );

      rethrow;
    }
  }
}
