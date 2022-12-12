import '../../../domain_layer/models.dart';
import '../../dtos.dart';
import '../../environment.dart';
import '../../errors.dart';

///Extension for mapping the [CategoryDTO]
extension CategoryDTOMapping on CategoryDTO {
  ///Maps an [CategoryDTO] into an [Category]
  Category toCategory() => Category(
        id: id,
        name: name,
        color: color,
        description: description,
        iconURL: iconURL != null && iconURL!.isNotEmpty
            ? '${EnvironmentConfiguration.current.fullUrl}/infobanking/v1'
                '$iconURL'
            : null,
        created: created,
        updated: updated,
        type: type?.toCategoryType(),
      );
}

///Extension for mapping the [CategoryTypeDTO]
extension CategoryTypeDTOMapping on CategoryTypeDTO {
  ///Maps a [CategoryTypeDTO] into a [CategoryType]
  CategoryType toCategoryType() {
    switch (this) {
      case CategoryTypeDTO.income:
        return CategoryType.income;

      case CategoryTypeDTO.expense:
        return CategoryType.expense;

      case CategoryTypeDTO.transfer:
        return CategoryType.transfer;

      default:
        throw MappingException(from: CategoryTypeDTO, to: CategoryType);
    }
  }
}
