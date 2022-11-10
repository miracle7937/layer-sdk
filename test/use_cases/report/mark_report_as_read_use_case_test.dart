import 'package:flutter_test/flutter_test.dart';
import 'package:layer_sdk/domain_layer/abstract_repositories.dart';
import 'package:layer_sdk/domain_layer/models.dart';
import 'package:layer_sdk/domain_layer/use_cases.dart';
import 'package:mocktail/mocktail.dart';

class MockInboxRepository extends Mock implements InboxRepositoryInterface {}

void main() {
  late InboxRepositoryInterface inboxRepository;
  late MarkReportAsReadUseCase markReportAsReadUseCase;

  setUp(() {
    inboxRepository = MockInboxRepository();
    markReportAsReadUseCase = MarkReportAsReadUseCase(inboxRepository);
  });

  test('should mark a report as read', () async {
    when(() => inboxRepository.markReportAsRead(InboxReport(id: 1)))
        .thenAnswer((_) async => InboxReport(id: 1, read: true));

    final result = await markReportAsReadUseCase.call(InboxReport(id: 1));

    expect(result.read, true);
  });
}
