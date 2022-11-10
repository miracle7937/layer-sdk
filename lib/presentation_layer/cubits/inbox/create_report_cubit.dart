import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data_layer/network.dart';
import '../../../../domain_layer/use_cases/inbox/create_inbox_report_use_case.dart';
import 'create_report_state.dart';

/// Create report cubit
class CreateReportCubit extends Cubit<CreateReportState> {
  /// Create report use case
  final CreateInboxReportUseCase createReportUseCase;

  /// Default constructor
  CreateReportCubit({required this.createReportUseCase})
      : super(
          CreateReportState(
            action: CreateReportAction.none,
            error: CreateReportErrorStatus.none,
          ),
        );

  /// Create report
  Future<void> createReport({
    required String categoryId,
  }) async {
    emit(
      state.copyWith(
        action: CreateReportAction.creating,
      ),
    );

    try {
      final report = await createReportUseCase(categoryId);
      emit(
        state.copyWith(
          action: CreateReportAction.none,
          createdReport: report,
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          action: CreateReportAction.none,
          error: e is NetException
              ? CreateReportErrorStatus.network
              : CreateReportErrorStatus.generic,
        ),
      );
    }
  }
}
