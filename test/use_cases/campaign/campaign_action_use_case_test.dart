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
  late CampaignActionUseCase _campaingActionUseCase;

  late Completer _completer;

  setUp(() {
    _repository = MockCampaignsRepository();
    _campaingActionUseCase = CampaignActionUseCase(
      repository: _repository,
    );
    _completer = Completer<void>();

    when(() => _campaingActionUseCase(
          id: any(
            named: 'id',
          ),
        )).thenAnswer((_) async => _completer.complete());
  });

  test('Should call campaign action properly', () async {
    await _campaingActionUseCase(
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
