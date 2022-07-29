import '../../../features/accounts.dart';

/// The use case for the accounts on the own transfer flow.
class GetDestinationAccountsForOwnTransferUseCase {
  final AccountRepositoryInterface _accountRepository;

  /// Creates a new [GetDestinationAccountsForOwnTransferUseCase] use case.
  const GetDestinationAccountsForOwnTransferUseCase({
    required AccountRepositoryInterface accountRepository,
  }) : _accountRepository = accountRepository;

  /// Return the accounts for the destination account picker on the own transfer
  /// flow.
  Future<List<Account>> call() async {
    final accounts = await _accountRepository.list(
      statuses: const [
        AccountStatus.active,
      ],
    );
    return accounts.where((account) => account.canReceiveTransfer).toList();
  }
}
