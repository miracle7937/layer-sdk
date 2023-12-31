import '../../../domain_layer/abstract_repositories.dart';
import '../../../domain_layer/models.dart';
import '../../mappings.dart';
import '../../providers.dart';

/// Handles all the categories data
class CategoryRepository implements CategoryRepositoryInterface {
  ///The provider
  final CategoryProvider provider;

  ///Creates a new repository with the supplied [CategoryProvider]
  CategoryRepository({
    required this.provider,
  });

  ///Lists the categories
  @override
  Future<List<Category>> list({
    bool forceRefresh = false,
  }) async {
    final categoryDTOs = await provider.list(
      forceRefresh: forceRefresh,
    );

    return categoryDTOs.map((e) => e.toCategory()).toList();
  }
}
