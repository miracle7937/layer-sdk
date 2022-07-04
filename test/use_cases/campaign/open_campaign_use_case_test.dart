import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:layer_sdk/domain_layer/abstract_repositories.dart';
import 'package:layer_sdk/domain_layer/use_cases.dart';

import 'package:mocktail/mocktail.dart';

class MockCampaignsRepository extends Mock
    implements CampaignRepositoryInterface {}

void main() {
  EquatableConfig.stringify = true;

  late MockCampaignsRepository _repository;
  late OpenCampaignsUseCase _openCampaignsUseCase;

  late Completer _completer;

  setUp(() {
    _repository = MockCampaignsRepository();
    _openCampaignsUseCase = OpenCampaignsUseCase(
      repository: _repository,
    );
    _completer = Completer<void>();

    when(() => _openCampaignsUseCase(
          id: any(
            named: 'id',
          ),
        )).thenAnswer((_) async => _completer.complete());
  });

  test('Should call open campaign properly', () async {
    await _openCampaignsUseCase(
      id: 1,
    );

    verify(
      () => _repository.onCampaignOpened(
        id: any(
          named: 'id',
        ),
      ),
    );

    verifyNoMoreInteractions(_repository);
  });
}
