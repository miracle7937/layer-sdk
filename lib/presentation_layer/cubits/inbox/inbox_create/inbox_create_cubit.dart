import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data_layer/network.dart';
import '../../../../domain_layer/models.dart';
import '../../../../domain_layer/use_cases.dart';
import 'inbox_create_state.dart';

/// Cubit for handling the InboxConversationScreen
///
/// It loads a [InboxReport] categories, a message
/// and a list of files that can be sent to the server
class InboxCreateCubit extends Cubit<InboxCreateState> {
  final LoadAllInboxReportCategoriesUseCase _categoriesUseCase;
  final CreateReportUseCase _createReportUseCase;
  final CreateInboxReportUseCase _createInboxReportUseCase;

  /// Creates a new [InboxCreateCubit]
  InboxCreateCubit({
    required LoadAllInboxReportCategoriesUseCase categoriesUseCase,
    required CreateReportUseCase createReportUseCase,
    required CreateInboxReportUseCase createInboxReportUseCase,
  })  : _categoriesUseCase = categoriesUseCase,
        _createReportUseCase = createReportUseCase,
        _createInboxReportUseCase = createInboxReportUseCase,
        super(InboxCreateState());

  /// Set the selectedCategory
  void setCategory(Message message) {
    emit(
      state.copyWith(selectedCategory: message),
    );
  }

  /// Set the report message
  void setReportDescription(String description) {
    emit(
      state.copyWith(description: description),
    );
  }

  /// Adds a file to state
  void addFile(InboxFile file) {
    emit(
      state.copyWith(
        inboxFiles: [...state.inboxFiles, file],
      ),
    );
  }

  /// If the 'Send' button can be pressed
  bool canCreatePost() {
    return [
      state.busy == false,
      state.busyAction == InboxCreateBusyAction.idle,
      state.selectedCategory != null,
    ].every((it) => it);
  }

  /// Loads the categories
  Future<void> load() async {
    try {
      emit(
        state.copyWith(
          busy: true,
          busyAction: InboxCreateBusyAction.loadingCategories,
          errorStatus: InboxCreateErrorStatus.none,
        ),
      );

      final categories = await _categoriesUseCase();

      emit(
        state.copyWith(
          busy: false,
          categories: categories,
          selectedCategory: categories.first,
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          busy: false,
          busyAction: InboxCreateBusyAction.idle,
          errorStatus: e is NetException
              ? InboxCreateErrorStatus.network
              : InboxCreateErrorStatus.generic,
          errorMessage: e is NetException ? e.message : e.toString(),
        ),
      );

      rethrow;
    }
  }

  /// Posts a new [InboxReport]
  Future<void> post() async {
    try {
      emit(
        state.copyWith(
          busy: true,
          busyAction: InboxCreateBusyAction.creatingReport,
          errorStatus: InboxCreateErrorStatus.none,
        ),
      );

      if (state.selectedCategory?.id == 'application_issue') {
        /// TODO - Needs to include the log file when implemented
        addFile(InboxFile(name: ''));
      }

      final message = await _createReportUseCase(
        description: state.description ?? '',
        categoryId: state.selectedCategory!.id ?? '',
        files: state.inboxFiles,
      );

      emit(
        state.copyWith(
          busy: false,
          busyAction: InboxCreateBusyAction.idle,
          errorStatus: InboxCreateErrorStatus.none,
          inboxMessage: message,
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          busy: false,
          busyAction: InboxCreateBusyAction.idle,
          errorStatus: e is NetException
              ? InboxCreateErrorStatus.network
              : InboxCreateErrorStatus.generic,
          errorMessage: e is NetException ? e.message : e.toString(),
        ),
      );

      rethrow;
    }
  }

  /// Posts a new [InboxReport] using only the category of the report
  Future<void> createReport() async {
    try {
      emit(
        state.copyWith(
          busy: true,
          busyAction: InboxCreateBusyAction.creatingReport,
          errorStatus: InboxCreateErrorStatus.none,
        ),
      );

      if (state.selectedCategory?.id == 'application_issue') {
        /// TODO - Needs to include the log file when implemented
        addFile(InboxFile(name: ''));
      }

      await _createInboxReportUseCase(
        state.selectedCategory?.id ?? '',
      );

      emit(
        state.copyWith(
          busy: false,
          busyAction: InboxCreateBusyAction.idle,
          errorStatus: InboxCreateErrorStatus.none,
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          busy: false,
          busyAction: InboxCreateBusyAction.idle,
          errorStatus: e is NetException
              ? InboxCreateErrorStatus.network
              : InboxCreateErrorStatus.generic,
          errorMessage: e is NetException ? e.message : e.toString(),
        ),
      );

      rethrow;
    }
  }
}
