import '../../../features/accounts.dart';

/// The use case for the accounts on the own transfer flow.
class GetSourceAccountsForOwnTransferUseCase {
  final AccountRepositoryInterface _accountRepository;

  /// Creates a new [GetSourceAccountsForOwnTransferUseCase] use case.
  const GetSourceAccountsForOwnTransferUseCase({
    required AccountRepositoryInterface accountRepository,
  }) : _accountRepository = accountRepository;

  /// Return the accounts for the source account picker on the own transfer flow
  Future<List<Account>> call() async {
    final accounts = await _accountRepository.list(
      statuses: const [
        AccountStatus.active,
      ],
    );
    return accounts.where((account) => account.canTransferOwn).toList();
  }
}
