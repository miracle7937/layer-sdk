import '../../../domain_layer/models.dart';
import '../../dtos.dart';
import '../../errors.dart';

/// Extension that provides mappings for [BillerDTO]
extension BillerDTOMapping on BillerDTO {
  /// Maps into a [Biller]
  Biller toBiller() {
    return Biller(
      id: billerId ?? '',
      name: name ?? '',
      category: BillerCategory(
        categoryCode: categoryCode ?? '',
        categoryDesc: categoryDesc,
      ),
      created: created,
      updated: updated,
      imageUrl: imageUrl,
    );
  }
}

/// Extension that provides mappings for a list of [Biller]
extension BillerCategoryMapping on List<Biller> {
  /// Maps into a list of  [BillerCategory]
  List<BillerCategory> toBillerCategories() {
    final _map = <String, BillerCategory>{};

    for (var i = 0; i < length; i++) {
      final category = this[i].category;
      _map[category.categoryCode] = category;
    }

    return _map.values.toList(growable: false);
  }
}

/// Provides DTO mappings for [BillerStatus]
extension BillerStatusMapping on BillerStatus {
  /// Maps into a DTO status.
  String toDTOStatus() {
    switch (this) {
      case BillerStatus.active:
        return 'A';

      default:
        throw MappingException(
          from: BillerStatus,
          to: String,
        );
    }
  }
}
