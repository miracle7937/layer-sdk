import '../../models.dart';

/// An abstract repository for the branch.
abstract class BranchRepositoryInterface {
  /// List all branches
  ///
  /// Use the `limit` and `offset` parameters to paginate.
  ///
  /// Use the `lat` and `long` parameters to load the branches starting from
  /// this location.
  Future<List<Branch>> list({
    bool forceRefresh = false,
    int? limit,
    int? offset,
    double? lat,
    double? long,
    String? searchQuery,
  });

  /// Get a branch by its id
  Future<Branch> getBranchById(String branchId);
}
