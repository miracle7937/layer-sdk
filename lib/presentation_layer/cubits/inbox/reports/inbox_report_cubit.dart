import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data_layer/network.dart';
import '../../../../domain_layer/use_cases.dart';
import 'inbox_report_state.dart';

/// Cubit used to load reports for the inbox feature
class InboxReportCubit extends Cubit<InboxReportState> {
  /// Use case that load all [InboxReport]s
  final LoadAllInboxMessagesUseCase _listInboxUseCase;

  /// Creates a new [InboxReportCubit] instance
  InboxReportCubit({
    required LoadAllInboxMessagesUseCase listInboxUseCase,
  })  : _listInboxUseCase = listInboxUseCase,
        super(InboxReportState());

  /// Loads a list of [InboxReport]s and adds them to the state.
  ///
  /// The [searchQuery] parameter can be used for filtering the results.
  Future<void> load({
    String? searchQuery,
    bool loadMore = false,
  }) async {
    try {
      emit(
        state.copyWith(
          busy: true,
          busyAction: loadMore == true
              ? InboxReportBusyAction.loadingMore
              : InboxReportBusyAction.loading,
        ),
      );

      final pagination = state.pagination.paginate(loadMore: loadMore);

      final foundReports = await _listInboxUseCase(
        limit: pagination.limit,
        offset: pagination.offset,
        searchQuery: searchQuery,
      );

      final reports = pagination.firstPage
          ? foundReports
          : [
              ...state.reports,
              ...foundReports,
            ];

      emit(
        state.copyWith(
          busy: false,
          errorMessage: '',
          errorStatus: InboxReportErrorStatus.none,
          pagination: pagination.refreshCanLoadMore(
            loadedCount: foundReports.length,
          ),
          reports: reports,
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          busy: false,
          errorStatus: e is NetException
              ? InboxReportErrorStatus.network
              : InboxReportErrorStatus.generic,
          errorMessage: e is NetException ? e.message : null,
        ),
      );
    }
  }
}
