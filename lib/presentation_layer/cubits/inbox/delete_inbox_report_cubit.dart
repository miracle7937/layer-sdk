import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data_layer/network/net_exceptions.dart';
import '../../../../domain_layer/models/inbox/inbox_report.dart';
import '../../../../domain_layer/use_cases.dart';
import 'delete_inbox_report_state.dart';

/// Delete report cubit
class DeleteInboxReportCubit extends Cubit<DeleteInboxReportState> {
  /// Create report use case
  final DeleteInboxReportUseCase deleteReportUseCase;

  /// Default constructor
  DeleteInboxReportCubit({required this.deleteReportUseCase})
      : super(
          DeleteInboxReportState(
            action: DeleteInboxReportAction.none,
            error: DeleteReportErrorStatus.none,
          ),
        );

  /// Delete report
  Future<void> deleteReport({
    required InboxReport inboxReport,
  }) async {
    emit(
      state.copyWith(
        action: DeleteInboxReportAction.creating,
      ),
    );

    try {
      final result = await deleteReportUseCase(inboxReport);
      if (result) {
        emit(
          state.copyWith(
            action: DeleteInboxReportAction.none,
            deletedReport: inboxReport,
          ),
        );
      }
    } on Exception catch (e) {
      emit(
        state.copyWith(
          action: DeleteInboxReportAction.none,
          error: e is NetException
              ? DeleteReportErrorStatus.network
              : DeleteReportErrorStatus.generic,
        ),
      );
    }
  }
}
