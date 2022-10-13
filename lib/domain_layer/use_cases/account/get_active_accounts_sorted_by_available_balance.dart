import 'package:collection/collection.dart';

import '../../../features/accounts.dart';

/// The use case getting the active accounts sorted by the available balance.
class GetActiveAccountsSortedByAvailableBalance {
  final AccountRepositoryInterface _accountRepository;

  /// Creates a new [GetActiveAccountsSortedByAvailableBalance] use case.
  const GetActiveAccountsSortedByAvailableBalance({
    required AccountRepositoryInterface accountRepository,
  }) : _accountRepository = accountRepository;

  /// Return the active accounts sorted by the available balance.
  Future<List<Account>> call() async {
    final accounts = await _accountRepository.list(
      statuses: const [
        AccountStatus.active,
      ],
    );

    return accounts
        .sortedBy<num>((element) => element.availableBalance ?? 0.0)
        .reversed
        .toList();
  }
}
