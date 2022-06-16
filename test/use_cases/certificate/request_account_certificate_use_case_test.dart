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
  late RequestAccountCertificateUseCase _requestAccountCertificateUseCase;

  final _mockedIntList = [1, 2, 3];

  setUp(() {
    _repository = MockCertificateRepositoy();
    _requestAccountCertificateUseCase = RequestAccountCertificateUseCase(
      repository: _repository,
    );

    when(() => _requestAccountCertificateUseCase(
          customerId: '1',
          accountId: '1',
        )).thenAnswer(
      (_) async => _mockedIntList,
    );
  });

  test('Should the file list of bytes', () async {
    final response = await _requestAccountCertificateUseCase(
      customerId: '1',
      accountId: '1',
    );

    expect(response, _mockedIntList);

    verify(
      () => _repository.requestAccountCertificate(
        customerId: '1',
        accountId: '1',
      ),
    );

    verifyNoMoreInteractions(_repository);
  });
}
