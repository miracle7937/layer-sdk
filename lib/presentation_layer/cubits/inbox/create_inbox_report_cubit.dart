import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data_layer/network.dart';
import '../../../../domain_layer/use_cases/inbox/create_inbox_report_use_case.dart';
import 'create_inbox_report_state.dart';

/// Create report cubit
class CreateInboxReportCubit extends Cubit<CreateInboxReportState> {
  /// Create report use case
  final CreateInboxReportUseCase createReportUseCase;

  /// Default constructor
  CreateInboxReportCubit({required this.createReportUseCase})
      : super(
          CreateInboxReportState(
            action: CreateInboxReportAction.none,
            error: CreateReportErrorStatus.none,
          ),
        );

  /// Create report
  Future<void> createReport({
    required String categoryId,
  }) async {
    emit(
      state.copyWith(
        action: CreateInboxReportAction.creating,
      ),
    );

    try {
      final report = await createReportUseCase(categoryId);
      emit(
        state.copyWith(
          action: CreateInboxReportAction.none,
          createdReport: report,
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          action: CreateInboxReportAction.none,
          error: e is NetException
              ? CreateReportErrorStatus.network
              : CreateReportErrorStatus.generic,
        ),
      );
    }
  }
}
