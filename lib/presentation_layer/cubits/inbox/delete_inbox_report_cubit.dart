import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data_layer/network/net_exceptions.dart';
import '../../../../domain_layer/use_cases.dart';
import '../../extensions.dart';
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
  void deleteReport({
    required int reportId,
  }) async {
    emit(
      state.copyWith(
        action: DeleteInboxReportAction.deleting,
        error: DeleteReportErrorStatus.none,
      ),
    );
    try {
      await deleteReportUseCase(reportId);

      emit(
        state.copyWith(
            action: DeleteInboxReportAction.none,
            error: DeleteReportErrorStatus.none),
      );
    } on Exception catch (e, st) {
      logException(e, st);
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
