import 'package:flutter_test/flutter_test.dart';
import 'package:layer_sdk/domain_layer/models.dart';
import 'package:layer_sdk/domain_layer/use_cases.dart';

void main() {
  late List<AgentACL> acls;
  late List<Account> accounts;
  late List<Account> expectedAccounts;
  late FilterAgentVisibleAccountsUseCase useCase;

  setUp(() {
    acls = List.generate(
      5,
      (index) => AgentACL(
        aclId: index,
        cardId: '',
        accountId: index % 2 == 0 ? index.toString() : '',
      ),
    );

    accounts = List.generate(
      5,
      (index) => Account(
        id: index.toString(),
      ),
    );

    expectedAccounts = [
      accounts[0],
      accounts[2],
      accounts[4],
    ];

    useCase = FilterAgentVisibleAccountsUseCase();
  });

  test('Should return correct list of accounts', () async {
    final result = useCase(
      acls: acls,
      accounts: accounts,
    );

    expect(result, expectedAccounts);
  });
}
