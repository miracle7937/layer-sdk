import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:layer_sdk/data_layer/network/net_exceptions.dart';
import 'package:layer_sdk/domain_layer/models/report/report.dart';
import 'package:layer_sdk/domain_layer/use_cases/report/create_report_use_case.dart';
import 'package:layer_sdk/presentation_layer/cubits/report/create_report_cubit.dart';
import 'package:layer_sdk/presentation_layer/cubits/report/create_report_state.dart';
import 'package:mocktail/mocktail.dart';

class MockCreateReportUseCase extends Mock implements CreateReportUseCase {}

void main() {
  late CreateReportUseCase createReportUseCase;
  late CreateReportCubit createReportCubit;

  setUp(() {
    createReportUseCase = MockCreateReportUseCase();
    createReportCubit =
        CreateReportCubit(createReportUseCase: createReportUseCase);
  });

  blocTest<CreateReportCubit, CreateReportState>("Should test initial state",
      build: () => createReportCubit,
      verify: (c) => expect(
          c.state,
          CreateReportState(
              action: CreateReportAction.none,
              error: CreateReportErrorStatus.none)));

  blocTest<CreateReportCubit, CreateReportState>(
    "Should create report",
    setUp: () {
      when(() => createReportUseCase({"category": "1_category_name"}))
          .thenAnswer((invocation) async => Report());
    },
    build: () => createReportCubit,
    act: (c) => c.create({"category": "1_category_name"}),
    expect: () => [
      CreateReportState(
          action: CreateReportAction.creating,
          error: CreateReportErrorStatus.none),
      CreateReportState(
          action: CreateReportAction.none,
          error: CreateReportErrorStatus.none,
          createdReport: Report()),
    ],
  );

  blocTest<CreateReportCubit, CreateReportState>(
    "Should emits network error",
    setUp: () {
      when(() => createReportUseCase({"category": "1_category_name"}))
          .thenThrow(NetException());
    },
    build: () => createReportCubit,
    act: (c) => c.create({"category": "1_category_name"}),
    expect: () => [
      CreateReportState(
          action: CreateReportAction.creating,
          error: CreateReportErrorStatus.none),
      CreateReportState(
        action: CreateReportAction.none,
        error: CreateReportErrorStatus.network,
      ),
    ],
  );

  blocTest<CreateReportCubit, CreateReportState>(
    "Should emits generic error",
    setUp: () {
      when(() => createReportUseCase({"category": "1_category_name"}))
          .thenThrow(Exception());
    },
    build: () => createReportCubit,
    act: (c) => c.create({"category": "1_category_name"}),
    expect: () => [
      CreateReportState(
          action: CreateReportAction.creating,
          error: CreateReportErrorStatus.none),
      CreateReportState(
        action: CreateReportAction.none,
        error: CreateReportErrorStatus.generic,
      ),
    ],
  );
}
