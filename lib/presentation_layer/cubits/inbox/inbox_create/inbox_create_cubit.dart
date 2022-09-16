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

  /// Creates a new [InboxCreateCubit]
  InboxCreateCubit({
    required LoadAllInboxReportCategoriesUseCase categoriesUseCase,
    required CreateReportUseCase createReportUseCase,
  })  : _categoriesUseCase = categoriesUseCase,
        _createReportUseCase = createReportUseCase,
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

  /// Base function for running async code
  Future<void> _exec(Future<void> Function() execAction) async {
    try {
      return await execAction();
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

  /// Loads the categories
  Future<void> load() async {
    _exec(() async {
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
          categories: categories,
          selectedCategory: categories.first,
        ),
      );
    });
  }

  /// Posts a new [InboxReport]
  Future<void> post() async {
    _exec(() async {
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
    });
  }
}
