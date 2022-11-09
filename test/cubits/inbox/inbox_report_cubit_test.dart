import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:layer_sdk/domain_layer/models/inbox/inbox_report.dart';
import 'package:layer_sdk/domain_layer/use_cases.dart';
import 'package:layer_sdk/presentation_layer/cubits/inbox/reports/inbox_report_cubit.dart';
import 'package:layer_sdk/presentation_layer/cubits/inbox/reports/inbox_report_state.dart';
import 'package:mocktail/mocktail.dart';

class MockMarkReportAsReadUseCase extends Mock
    implements MarkReportAsReadUseCase {}

class MockLoadAllInboxMessagesUseCase extends Mock
    implements LoadAllInboxMessagesUseCase {}

void main() {
  late MarkReportAsReadUseCase markReportAsReadUseCase;
  late LoadAllInboxMessagesUseCase loadAllInboxMessagesUseCase;
  late InboxReportCubit inboxReportCubit;

  setUp(() {
    markReportAsReadUseCase = MockMarkReportAsReadUseCase();
    loadAllInboxMessagesUseCase = MockLoadAllInboxMessagesUseCase();
    inboxReportCubit = InboxReportCubit(
      listInboxUseCase: loadAllInboxMessagesUseCase,
      markReportAsReadUseCase: markReportAsReadUseCase,
    );
  });

  blocTest<InboxReportCubit, InboxReportState>(
    'should mark a report as read',
    build: () => inboxReportCubit,
    setUp: () {
      when(() => markReportAsReadUseCase.call(InboxReport(id: 1, read: false)))
          .thenAnswer((_) async => true);
    },
    act: (cubit) async {
      cubit.markReportAsRead(InboxReport(id: 1, read: false));
    },
    expect: () => [
      InboxReportState(
        busy: true,
        busyAction: InboxReportBusyAction.markingAsRead,
      ),
      InboxReportState(
        busy: false,
        busyAction: InboxReportBusyAction.none,
        errorMessage: '',
      ),
    ],
  );
}
