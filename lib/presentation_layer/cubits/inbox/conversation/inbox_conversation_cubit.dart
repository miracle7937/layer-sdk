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
  void addInboxFile(InboxFile file) {
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
  void removeInboxFile(InboxFile file) {
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
  void load({
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
  void sendMessage({
    required String message,
    String? fileURL,
  }) async {
    InboxChatMessage? inboxChatMessage;

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
              ...state.report!.messages
                  .sublist(0, state.report!.messages.length - 1),
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
      final failedInboxMessage = InboxReportMessage(
        text: message,
        reportId: state.report?.id ?? 0,
      );

      emit(
        state.copyWith(
          busy: false,
          busyAction: InboxConversationBusyAction.idle,
          report: state.report!.copyWith(
            messages: [...state.report?.messages ?? [], failedInboxMessage],
          ),
          messages: [
            ...(state.messages.sublist(0, state.messages.length - 1)),
            InboxChatMessage(
              message: failedInboxMessage,
              status: InboxChatMessageStatus.failed,
              sentTime: DateTime.now(),
            ),
          ],
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
  void uploadInboxFiles() async {
    InboxReportMessage? inboxMessage;
    InboxChatMessage? inboxChatMessage;

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

      inboxMessage = InboxReportMessage(
        reportId: state.report?.id! ?? 0,
        text: state.messageText,
        senderType: InboxReportSenderType.customer,
        files: _displayFiles,
      );

      inboxChatMessage = InboxChatMessage(
        message: inboxMessage,
        status: InboxChatMessageStatus.uploading,
        sentTime: DateTime.now(),
      );

      emit(
        state.copyWith(
          messages: [
            ...state.messages,
            inboxChatMessage,
          ],
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
          uploadedFiles: [],
          messages: [
            ...state.messages,
            inboxChatMessage.copyWith(
              // message: message,
              message: sentMessage,
              status: InboxChatMessageStatus.uploaded,
            ),
          ],
          report: state.report?.copyWith(
            messages: [
              ...state.report!.messages,
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

  /// Resend a failed message
  void resendMessage({
    required InboxChatMessage failedMessage,
  }) async {
    try {
      emit(
        state.copyWith(
          busy: true,
          busyAction: InboxConversationBusyAction.postingInboxFiles,
          errorStatus: InboxConversationErrorStatus.none,
          messages: [
            ...state.messages.sublist(0, state.messages.length - 1),
            failedMessage.copyWith(
              sentTime: DateTime.now(),
              status: InboxChatMessageStatus.uploading,
            ),
          ],
        ),
      );

      final sentMessage = await _postInboxFilesUseCase(
        reportId: state.report?.id! ?? 0,
        files: state.filesToUpload,
        messageText: failedMessage.message.text,
      );

      emit(
        state.copyWith(
          filesToUpload: [],
          uploadedFiles: [],
          messages: [
            ...state.messages.sublist(0, state.messages.length - 1),
            failedMessage.copyWith(
              message: sentMessage,
              status: InboxChatMessageStatus.uploaded,
            ),
          ],
          report: state.report?.copyWith(
            messages: [
              ...state.report!.messages.sublist(
                0,
                state.report!.messages.length - 1,
              ),
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
          report: state.report!.copyWith(
            messages: [
              ...state.report!.messages.sublist(
                0,
                state.report!.messages.length - 1,
              ),
              failedMessage.message,
            ],
          ),
          messages: [
            ...(state.messages.sublist(0, state.messages.length - 1)),
            failedMessage.copyWith(
              message: failedMessage.message,
              status: InboxChatMessageStatus.failed,
            ),
          ],
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
