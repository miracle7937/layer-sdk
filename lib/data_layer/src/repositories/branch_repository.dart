import '../../models.dart';
import '../../providers.dart';
import '../mappings.dart';

/// Handles all the branches data.
class BranchRepository {
  /// The provider to use to fetch the branch data.
  final BranchProvider _provider;

  /// Creates a new [BranchRepository].
  const BranchRepository({
    required BranchProvider provider,
  }) : _provider = provider;

  ///Lists the currencies
  Future<List<Branch>> list({
    bool forceRefresh = false,
    int? limit,
    int? offset,
    double? lat,
    double? long,
    String? searchQuery,
  }) async {
    final dtos = await _provider.list(
      forceRefresh: forceRefresh,
      limit: limit,
      offset: offset,
      lat: lat,
      long: long,
      searchQuery: searchQuery,
    );

    return dtos.map((e) => e.toBranch()).toList(growable: false);
  }

  /// Get a branch by its id
  Future<Branch> getBranchById(String branchId) async {
    final branch = await _provider.fetchBranchById(branchId);
    return branch.toBranch();
  }
}
