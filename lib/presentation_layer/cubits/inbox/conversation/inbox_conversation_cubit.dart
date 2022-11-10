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
  final LoadGlobalSettingsUseCase _loadGlobalSettingsUseCase;

  /// Creates a new [InboxConversationCubit]
  InboxConversationCubit({
    required SendReportChatMessageUseCase sendChatMessageUseCase,
    required PostInboxFilesUseCase postInboxFilesUseCase,
    required LoadGlobalSettingsUseCase loadGlobalSettingsUseCase,
  })  : _postInboxFilesUseCase = postInboxFilesUseCase,
        _sendChatMessageUseCase = sendChatMessageUseCase,
        _loadGlobalSettingsUseCase = loadGlobalSettingsUseCase,
        super(
          InboxConversationState(
            report: InboxReport(),
          ),
        );

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

      final settings = await _loadGlobalSettingsUseCase(
        codes: [
          'max_inbox_message_chars',
          'max_file_limit',
        ],
      );

      final maxCharacters =
          settings.firstWhere((it) => it.code == 'max_inbox_message_chars');
      final maxFileSize =
          settings.firstWhere((it) => it.code == 'max_file_limit');

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

      messages
          .sort((o, n) => n.message.tsCreated!.compareTo(o.message.tsCreated!));

      emit(
        state.copyWith(
          busy: false,
          busyAction: InboxConversationBusyAction.idle,
          errorStatus: InboxConversationErrorStatus.none,
          uploadedFiles: files,
          messages: messages,
          report: report,
          maxCharactersPerMessage: maxCharacters.value,
          maxFileSizeLimit: maxFileSize.value,
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
    }
  }

  /// Posts a new inbox chat message
  void sendMessage({
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
        reportId: state.report.id ?? 0,
        senderType: InboxReportSenderType.customer,
        tsCreated: DateTime.now(),
      );

      final inboxChatMessage = InboxChatMessage(
        message: inboxReportMessage,
        status: InboxChatMessageStatus.uploading,
        sentTime: DateTime.now(),
      );

      final inboxMessage = await _sendChatMessageUseCase(
        reportId: state.report.id ?? 0,
        messageText: message,
        fileUrl: fileURL,
      );

      emit(
        state.copyWith(
          busy: false,
          busyAction: InboxConversationBusyAction.idle,
          report: state.report.copyWith(
            messages: [
              inboxMessage,
              ...state.report.messages,
            ],
          ),
          messages: [
            inboxChatMessage.copyWith(
              message: inboxMessage,
              status: InboxChatMessageStatus.uploaded,
            ),
            ...state.messages,
          ],
        ),
      );
    } on Exception catch (e) {
      final failedInboxMessage = InboxReportMessage(
        text: message,
        reportId: state.report.id ?? 0,
      );

      emit(
        state.copyWith(
          busy: false,
          busyAction: InboxConversationBusyAction.idle,
          report: state.report.copyWith(
            messages: [
              failedInboxMessage,
              if (state.report.messages.isNotEmpty)
                ...state.report.messages.sublist(0, state.messages.length - 1),
            ],
          ),
          messages: [
            InboxChatMessage(
              message: failedInboxMessage,
              status: InboxChatMessageStatus.failed,
              sentTime: DateTime.now(),
            ),
            if (state.messages.isNotEmpty)
              ...(state.messages.sublist(0, state.messages.length - 1)),
          ],
          errorStatus: e is NetException
              ? InboxConversationErrorStatus.network
              : InboxConversationErrorStatus.generic,
          errorMessage: e is NetException ? e.message : e.toString(),
        ),
      );
    }
  }

  /// Upload a list of [InboxFiles]
  void uploadInboxFiles() async {
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

      final inboxMessage = InboxReportMessage(
        reportId: state.report.id ?? 0,
        text: state.messageText,
        senderType: InboxReportSenderType.customer,
        files: _displayFiles,
      );

      final inboxChatMessage = InboxChatMessage(
        message: inboxMessage,
        status: InboxChatMessageStatus.uploading,
        sentTime: DateTime.now(),
      );

      final sentMessage = await _postInboxFilesUseCase(
        reportId: state.report.id ?? 0,
        files: state.filesToUpload,
        messageText: state.messageText,
      );

      emit(
        state.copyWith(
          busy: false,
          filesToUpload: [],
          uploadedFiles: [],
          messages: [
            inboxChatMessage.copyWith(
              message: sentMessage,
              status: InboxChatMessageStatus.uploaded,
            ),
            if (state.messages.isNotEmpty)
              ...state.messages.sublist(0, state.messages.length - 1),
          ],
          report: state.report.copyWith(
            messages: [
              sentMessage,
              if (state.report.messages.isNotEmpty)
                ...state.report.messages.sublist(0, state.messages.length - 1),
            ],
          ),
        ),
      );
    } on Exception catch (e) {
      final failedInboxMessage = InboxReportMessage(
        text: state.messageText,
        reportId: state.report.id ?? 0,
      );
      emit(
        state.copyWith(
          busy: false,
          busyAction: InboxConversationBusyAction.idle,
          report: state.report.copyWith(
            messages: [
              failedInboxMessage,
              if (state.report.messages.isNotEmpty)
                ...state.report.messages.sublist(state.messages.length - 1),
            ],
          ),
          messages: [
            InboxChatMessage(
              message: failedInboxMessage,
              status: InboxChatMessageStatus.failed,
              sentTime: DateTime.now(),
            ),
            if (state.messages.isNotEmpty)
              ...(state.messages.sublist(0, state.messages.length - 1)),
          ],
          errorStatus: e is NetException
              ? InboxConversationErrorStatus.network
              : InboxConversationErrorStatus.generic,
          errorMessage: e is NetException ? e.message : e.toString(),
        ),
      );

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
    }
  }

  /// Method that handles if should resend the files or just the text message
  void resendMessage({required InboxChatMessage failedMessage}) async {
    try {
      emit(
        state.copyWith(
          busy: true,
          busyAction: InboxConversationBusyAction.postingInboxFiles,
          errorStatus: InboxConversationErrorStatus.none,
          messages: [
            failedMessage.copyWith(
              sentTime: DateTime.now(),
              status: InboxChatMessageStatus.uploading,
            ),
            if (state.messages.isNotEmpty)
              ...state.messages.sublist(0, state.messages.length - 1),
          ],
          report: state.report.copyWith(
            messages: [
              failedMessage.message,
              if (state.report.messages.isNotEmpty)
                ...state.report.messages.sublist(0, state.messages.length - 1)
            ],
          ),
        ),
      );

      final sentMessage = await _postInboxFilesUseCase(
        reportId: state.report.id ?? 0,
        files: state.filesToUpload,
        messageText: failedMessage.message.text,
      );

      emit(
        state.copyWith(
          busy: false,
          filesToUpload: [],
          uploadedFiles: [],
          messages: [
            if (state.messages.isNotEmpty)
              ...state.messages.sublist(0, state.messages.length - 1),
            failedMessage.copyWith(
              message: sentMessage,
              status: InboxChatMessageStatus.uploaded,
            ),
          ],
          report: state.report.copyWith(
            messages: [
              sentMessage,
              if (state.report.messages.isNotEmpty)
                ...state.report.messages
                    .sublist(0, state.report.messages.length - 1),
            ],
          ),
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          busy: false,
          busyAction: InboxConversationBusyAction.idle,
          report: state.report.copyWith(
            messages: [
              failedMessage.message,
              if (state.report.messages.isNotEmpty)
                ...state.report.messages.sublist(
                  0,
                  state.report.messages.length - 1,
                ),
            ],
          ),
          messages: [
            failedMessage.copyWith(
              message: failedMessage.message,
              status: InboxChatMessageStatus.failed,
            ),
            if (state.messages.isNotEmpty)
              ...(state.messages.sublist(0, state.messages.length - 1)),
          ],
          errorStatus: e is NetException
              ? InboxConversationErrorStatus.network
              : InboxConversationErrorStatus.generic,
          errorMessage: e is NetException ? e.message : e.toString(),
        ),
      );
    }
  }

  /// Removes a failed message from the list
  void deleteFailedMessage(InboxChatMessage failedMessage) {
    final successfulMessages = [...state.messages]..remove(failedMessage);

    final reportMessages = [...state.report.messages]
      ..remove(failedMessage.message);

    final hasAttachments = failedMessage.message.files.isNotEmpty;

    emit(
      state.copyWith(
        messages: successfulMessages,
        report: state.report.copyWith(messages: reportMessages),
        filesToUpload: hasAttachments ? [] : state.filesToUpload,
      ),
    );
  }
}
