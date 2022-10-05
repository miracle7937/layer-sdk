import '../../models.dart';

/// An abstract repository for categories
abstract class CategoryRepositoryInterface {
  ///Lists the categories
  Future<List<Category>> list({
    bool forceRefresh = false,
  });
}
