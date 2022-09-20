import 'package:collection/collection.dart';

import '../../../features/accounts.dart';

/// The use case for the accounts on a beneficiary transfer flow.
class GetSourceAccountsForBeneficiaryTransferUseCase {
  final AccountRepositoryInterface _accountRepository;

  /// Creates a new [GetSourceAccountsForBeneficiaryTransferUseCase] use case.
  const GetSourceAccountsForBeneficiaryTransferUseCase({
    required AccountRepositoryInterface accountRepository,
  }) : _accountRepository = accountRepository;

  /// Return the accounts for the source account picker on the beneficiary
  /// transfer flow.
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
