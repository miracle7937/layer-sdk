import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:layer_sdk/data_layer/network/net_exceptions.dart';
import 'package:layer_sdk/domain_layer/models.dart';
import 'package:layer_sdk/domain_layer/use_cases.dart';
import 'package:layer_sdk/presentation_layer/cubits.dart';
import 'package:mocktail/mocktail.dart';

class MockCreateReportUseCase extends Mock implements CreateInboxReportUseCase {
}

void main() {
  late CreateInboxReportUseCase createReportUseCase;
  late CreateInboxReportCubit createReportCubit;
  final _category = '1_category_name';
  final _defReport = InboxReport(
    category: InboxReportCategory.appIssue,
    id: 1,
    customerID: '',
    deviceID: 123,
  );

  setUp(() {
    createReportUseCase = MockCreateReportUseCase();
    createReportCubit =
        CreateInboxReportCubit(createReportUseCase: createReportUseCase);
  });

  blocTest<CreateInboxReportCubit, CreateInboxReportState>(
    "Should test initial state",
    build: () => createReportCubit,
    verify: (c) => expect(
      c.state,
      CreateInboxReportState(
        action: CreateInboxReportAction.none,
        error: CreateReportErrorStatus.none,
      ),
    ),
  );

  blocTest<CreateInboxReportCubit, CreateInboxReportState>(
    "Should create report",
    setUp: () {
      when(() => createReportUseCase(_category)).thenAnswer(
        (invocation) async => _defReport,
      );
    },
    build: () => createReportCubit,
    act: (c) => c.createReport(categoryId: _category),
    expect: () => [
      CreateInboxReportState(
        action: CreateInboxReportAction.creating,
        error: CreateReportErrorStatus.none,
      ),
      CreateInboxReportState(
        action: CreateInboxReportAction.none,
        error: CreateReportErrorStatus.none,
        createdReport: _defReport,
      ),
    ],
  );

  blocTest<CreateInboxReportCubit, CreateInboxReportState>(
    "Should emits network error",
    setUp: () {
      when(() => createReportUseCase(_category)).thenThrow(NetException());
    },
    build: () => createReportCubit,
    act: (c) => c.createReport(categoryId: _category),
    expect: () => [
      CreateInboxReportState(
        action: CreateInboxReportAction.creating,
        error: CreateReportErrorStatus.none,
      ),
      CreateInboxReportState(
        action: CreateInboxReportAction.none,
        error: CreateReportErrorStatus.network,
      ),
    ],
  );

  blocTest<CreateInboxReportCubit, CreateInboxReportState>(
    "Should emits generic error",
    setUp: () {
      when(() => createReportUseCase(_category)).thenThrow(Exception());
    },
    build: () => createReportCubit,
    act: (c) => c.createReport(categoryId: _category),
    expect: () => [
      CreateInboxReportState(
        action: CreateInboxReportAction.creating,
        error: CreateReportErrorStatus.none,
      ),
      CreateInboxReportState(
        action: CreateInboxReportAction.none,
        error: CreateReportErrorStatus.generic,
      ),
    ],
  );
}
