import '../../models.dart';

/// The abstract repository for the accounts.
// ignore: one_member_abstracts
abstract class AccountRepositoryInterface {
  /// Retrieves a list of accounts.
  Future<List<Account>> list({
    String? customerId,
    bool includeDetails = true,
    bool forceRefresh = false,
    List<AccountStatus> statuses = const [],
  });

  /// Requests a new Stripe secret key for account top ups.
  Future<AccountTopUpRequest> getAccountTopUpSecret({
    required String accountId,
    required String currency,
    required double amount,
  });

  /// Requests a top up receipt with the provided parameters.
  Future<List<int>> getTopUpReceipt({
    required String topUpId,
    required ReceiptType type,
  });
}

/// Enum that defines all possible receipts types.
enum ReceiptType {
  /// PDF receipt
  pdf,

  /// Image receipt
  image,
}
