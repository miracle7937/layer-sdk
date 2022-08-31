import 'package:flutter_test/flutter_test.dart';
import 'package:layer_sdk/domain_layer/abstract_repositories/report/report_repository_interface.dart';
import 'package:layer_sdk/domain_layer/models/report/report.dart';
import 'package:layer_sdk/domain_layer/use_cases/report/create_report_use_case.dart';
import 'package:mocktail/mocktail.dart';

class MockReportRepository extends Mock implements ReportRepositoryInterface {}

void main() {
  late CreateReportUseCase createReportUseCase;
  late ReportRepositoryInterface repository;

  setUp(() {
    repository = MockReportRepository();
    createReportUseCase = CreateReportUseCase(repository);
  });

  test("Should create report", () async {
    when(() => repository.createReport({"category": "1_category_name"}))
        .thenAnswer((invocation) async => Report(category: "1_category_name"));

    final result = await createReportUseCase({"category": "1_category_name"});

    expect(result, isNotNull);
    expect(result, Report(category: "1_category_name"));
  });
}
