import '../../../features/checkbook.dart';

/// Abstract repository for the checkbooks.
abstract class CheckbookRepositoryInterface {
  /// List checkbooks of the provided customer ID
  Future<List<Checkbook>> list({
    required String customerId,
    bool forceRefresh = false,
    int? limit,
    int? offset,
    CheckbookSort? sort,
    bool descendingOrder = true,
  });
}
