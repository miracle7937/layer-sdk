import 'package:flutter_test/flutter_test.dart';
import 'package:layer_sdk/_migration/data_layer/src/mappings.dart';
import 'package:layer_sdk/data_layer/interfaces.dart';
import 'package:layer_sdk/domain_layer/use_cases.dart';
import 'package:layer_sdk/features/user.dart';
import 'package:layer_sdk/presentation_layer/resources.dart';

import 'package:mocktail/mocktail.dart';

class MockGenericStorage extends Mock implements GenericStorage {}

late MockGenericStorage _genericStorage;
late LoadLoggedInUsersUseCase _useCase;
late List<User> _loggedInUsers;

final _loggedInUsersMap = {
  'users': [
    {'id': '1'},
    {'id': '2'},
    {'id': '3'},
  ]
};

final storageKey = StorageKeys.loggedUsers;

void main() {
  setUp(() {
    _genericStorage = MockGenericStorage();
    _useCase = LoadLoggedInUsersUseCase(secureStorage: _genericStorage);

    final users = List<Map<String, dynamic>>.from(_loggedInUsersMap['users']!);
    _loggedInUsers = users.map(UserJsonMapping.fromJson).toList();

    when(
      () => _genericStorage.getJson(storageKey),
    ).thenAnswer((_) async => _loggedInUsersMap);
  });

  test('Should return the logged in users list', () async {
    final result = await _useCase();

    expect(result, _loggedInUsers);

    verify(
      () => _genericStorage.getJson(storageKey),
    ).called(1);
  });
}
