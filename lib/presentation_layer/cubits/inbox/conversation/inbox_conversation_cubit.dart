import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:layer_sdk/domain_layer/models.dart';
import 'package:layer_sdk/presentation_layer/cubits/inbox/conversation/inbox_conversation_state.dart';

import '../../../../data_layer/network.dart';
import '../../../../domain_layer/use_cases.dart';

/// Cubit for handling the InboxConversationScreen
///
/// It loads a [InboxReport] categories, a message
/// and a list of files that can be sent to the server
class InboxConversationCubit extends Cubit<InboxConversationState> {
  LoadAllInboxReportCategoriesUseCase _categoriesUseCase;

  /// Creates a new [InboxConversationCubit]
  InboxConversationCubit({
    required LoadAllInboxReportCategoriesUseCase categoriesUseCase,
  })  : _categoriesUseCase = categoriesUseCase,
        super(InboxConversationState());

  /// Set the selectedCategory
  void setCategory(Message message) {
    emit(
      state.copyWith(selectedCategory: message),
    );
  }

  /// Set the report message
  void setReportMessage(String message) {
    emit(
      state.copyWith(reportMessage: message),
    );
  }

  /// Adds a file to the report
  void addFile(Uint8List base64Image) {
    emit(
      state.copyWith(
        files: [...state.base64Files, base64Image],
      ),
    );
  }

  /// Loads the categories
  Future<void> load() async {
    try {
      emit(
        state.copyWith(
          busy: true,
          busyAction: InboxConversationBusyAction.loadingCategories,
          errorStatus: InboxConversationErrorStatus.none,
        ),
      );

      final categories = await _categoriesUseCase();

      emit(
        state.copyWith(
          categories: categories,
          selectedCategory: categories.first,
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
