import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:layer_sdk/data_layer/network/net_exceptions.dart';
import 'package:layer_sdk/domain_layer/models.dart';
import 'package:layer_sdk/domain_layer/use_cases.dart';
import 'package:layer_sdk/presentation_layer/cubits.dart';
import 'package:mocktail/mocktail.dart';

class MockDeleteReportUseCase extends Mock implements DeleteInboxReportUseCase {
}

void main() {
  late DeleteInboxReportUseCase deleteReportUseCase;
  late DeleteInboxReportCubit deleteReportCubit;
  late InboxReport report;

  setUp(() {
    report = InboxReport(
      category: InboxReportCategory.appIssue,
      id: 1,
      customerID: '',
      deviceID: 123,
    );
    deleteReportUseCase = MockDeleteReportUseCase();
    deleteReportCubit =
        DeleteInboxReportCubit(deleteReportUseCase: deleteReportUseCase);
  });

  blocTest<DeleteInboxReportCubit, DeleteInboxReportState>(
      "Should test initial state",
      build: () => deleteReportCubit,
      verify: (c) => expect(
          c.state,
          DeleteInboxReportState(
              action: DeleteInboxReportAction.none,
              error: DeleteReportErrorStatus.none)));

  blocTest<DeleteInboxReportCubit, DeleteInboxReportState>(
    "Should delete report",
    setUp: () {
      when(() => deleteReportUseCase(report)).thenAnswer(
        (invocation) async => true,
      );
    },
    build: () => deleteReportCubit,
    act: (c) => c.deleteReport(inboxReport: report),
    expect: () => [
      DeleteInboxReportState(
        action: DeleteInboxReportAction.creating,
        error: DeleteReportErrorStatus.none,
      ),
      DeleteInboxReportState(
        action: DeleteInboxReportAction.none,
        error: DeleteReportErrorStatus.none,
        deletedReport: report,
      ),
    ],
  );

  blocTest<DeleteInboxReportCubit, DeleteInboxReportState>(
    "Should emits network error",
    setUp: () {
      when(() => deleteReportUseCase(report)).thenThrow(NetException());
    },
    build: () => deleteReportCubit,
    act: (c) => c.deleteReport(inboxReport: report),
    expect: () => [
      DeleteInboxReportState(
        action: DeleteInboxReportAction.creating,
        error: DeleteReportErrorStatus.none,
      ),
      DeleteInboxReportState(
        action: DeleteInboxReportAction.none,
        error: DeleteReportErrorStatus.network,
      ),
    ],
  );

  blocTest<DeleteInboxReportCubit, DeleteInboxReportState>(
    "Should emits generic error",
    setUp: () {
      when(() => deleteReportUseCase(report)).thenThrow(Exception());
    },
    build: () => deleteReportCubit,
    act: (c) => c.deleteReport(inboxReport: report),
    expect: () => [
      DeleteInboxReportState(
          action: DeleteInboxReportAction.creating,
          error: DeleteReportErrorStatus.none),
      DeleteInboxReportState(
        action: DeleteInboxReportAction.none,
        error: DeleteReportErrorStatus.generic,
      ),
    ],
  );
}
