import 'package:equatable/equatable.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:layer_sdk/domain_layer/abstract_repositories.dart';
import 'package:layer_sdk/domain_layer/use_cases.dart';
import 'package:mocktail/mocktail.dart';

class MockCertificateRepositoy extends Mock
    implements CertificateRepositoryInterface {}

void main() {
  EquatableConfig.stringify = true;

  late MockCertificateRepositoy _repository;
  late RequestBankStatementUseCase _requestBankStatementUseCase;

  final _mockedIntList = [1, 2, 3];

  final _mockDate = DateTime.now();

  setUp(() {
    _repository = MockCertificateRepositoy();
    _requestBankStatementUseCase = RequestBankStatementUseCase(
      repository: _repository,
    );

    when(
      () => _requestBankStatementUseCase(
        toDate: _mockDate,
        accountId: '1',
        fromDate: _mockDate,
        customerId: '1',
      ),
    ).thenAnswer(
      (_) async => _mockedIntList,
    );
  });

  test('Should the file list of bytes', () async {
    final response = await _requestBankStatementUseCase(
      toDate: _mockDate,
      accountId: '1',
      fromDate: _mockDate,
      customerId: '1',
    );

    expect(response, _mockedIntList);

    verify(
      () => _repository.requestBankStatement(
        toDate: _mockDate,
        accountId: '1',
        fromDate: _mockDate,
        customerId: '1',
      ),
    );

    verifyNoMoreInteractions(_repository);
  });
}
