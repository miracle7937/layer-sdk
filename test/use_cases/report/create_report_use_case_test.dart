import 'package:flutter_test/flutter_test.dart';
import 'package:layer_sdk/domain_layer/abstract_repositories.dart';
import 'package:layer_sdk/domain_layer/models.dart';
import 'package:layer_sdk/domain_layer/use_cases/inbox/create_inbox_report_use_case.dart';
import 'package:mocktail/mocktail.dart';

class MockReportRepository extends Mock implements InboxRepositoryInterface {}

void main() {
  late CreateInboxReportUseCase _createReportUseCase;
  late MockReportRepository _repository;
  final _category = '1_category_name';

  final _defReport = InboxReport(
    category: InboxReportCategory.appIssue,
    id: 1,
    customerID: '',
    deviceID: 123,
  );

  setUp(() {
    _repository = MockReportRepository();
    _createReportUseCase = CreateInboxReportUseCase(
      repository: _repository,
    );
  });

  test("Should create report", () async {
    when(
      () => _repository.createReport(_category),
    ).thenAnswer(
      (_) async => _defReport,
    );

    final result = await _createReportUseCase(_category);

    expect(result, isNotNull);
    expect(result, _defReport);
  });
}
