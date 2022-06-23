import 'package:flutter_test/flutter_test.dart';
import 'package:layer_sdk/features/audit.dart';
import 'package:mocktail/mocktail.dart';

class MockAuditRepository extends Mock implements AuditRepositoryInterface {}

class MockAudit extends Mock implements Audit {}

late MockAuditRepository _repository;
late LoadCustomerAuditsUseCase _useCase;
late List<MockAudit> _mockedAuditList;

final _customerId = '1';

void main() {
  setUp(() {
    _repository = MockAuditRepository();
    _useCase = LoadCustomerAuditsUseCase(repository: _repository);

    _mockedAuditList = List.generate(
      5,
      (index) => MockAudit(),
    );

    when(
      () => _repository.listCustomerAudits(
        customerId: any(named: 'customerId'),
      ),
    ).thenAnswer((_) async => _mockedAuditList);
  });

  test('Should return a list of audits', () async {
    final result = await _useCase(customerId: _customerId);

    expect(result, _mockedAuditList);

    verify(
      () => _repository.listCustomerAudits(customerId: _customerId),
    ).called(1);
  });
}
