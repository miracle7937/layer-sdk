import 'package:flutter_test/flutter_test.dart';
import 'package:layer_sdk/domain_layer/abstract_repositories.dart';
import 'package:layer_sdk/domain_layer/models/campaign/campaign_response.dart';
import 'package:layer_sdk/domain_layer/use_cases.dart';
import 'package:mocktail/mocktail.dart';

class MockCampaignsRepository extends Mock
    implements CampaignRepositoryInterface {}

class MockCampaignResponse extends Mock implements CampaignResponse {}

late MockCampaignsRepository _repository;
late LoadPublicCampaignsUseCase _useCase;
late MockCampaignResponse _mockCampaignResponse;

final _limit = 10;
final _offset = 0;

void main() {
  setUp(() {
    _repository = MockCampaignsRepository();
    _useCase = LoadPublicCampaignsUseCase(repository: _repository);

    _mockCampaignResponse = MockCampaignResponse();

    when(
      () => _repository.list(
        limit: any(named: 'limit'),
        offset: any(named: 'offset'),
      ),
    ).thenAnswer((_) async => _mockCampaignResponse);
  });

  test('Should return an public campaign response', () async {
    final result = await _useCase(
      limit: _limit,
      offset: _offset,
    );

    expect(result, _mockCampaignResponse);

    verify(
      () => _repository.list(
        limit: _limit,
        offset: _offset,
      ),
    ).called(1);
  });
}
