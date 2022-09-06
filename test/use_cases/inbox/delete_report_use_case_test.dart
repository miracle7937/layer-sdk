import 'package:flutter_test/flutter_test.dart';
import 'package:layer_sdk/domain_layer/abstract_repositories.dart';
import 'package:layer_sdk/domain_layer/models.dart';
import 'package:layer_sdk/domain_layer/use_cases.dart';
import 'package:mocktail/mocktail.dart';

class MockReportRepository extends Mock implements InboxRepositoryInterface {}

void main() {
  late DeleteInboxReportUseCase _deleteReportUseCase;
  late MockReportRepository _repository;

  late InboxReport report;

  setUp(() {
    report = InboxReport(
      category: InboxReportCategory.appIssue,
      id: 1,
      customerID: '',
      deviceID: 123,
    );
    _repository = MockReportRepository();
    _deleteReportUseCase = DeleteInboxReportUseCase(repository: _repository);
  });

  test("Should delete report", () async {
    when(
      () => _repository.deleteReport(report),
    ).thenAnswer(
      (_) async => true,
    );

    final result = await _deleteReportUseCase(report);

    expect(result, true);
  });
}
