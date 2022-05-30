import 'package:collection/collection.dart';

import '../../helpers.dart';

///Data transfer object reperesenting a category
class CategoryDTO {
  ///The category's id
  int? id;

  ///The category's name
  String? name;

  ///The hex color for the category
  String? color;

  ///The description of the category
  String? description;

  ///The icon url of the category
  String? iconURL;

  ///When the category was created
  DateTime? created;

  ///Last time the category was updated
  DateTime? updated;

  ///The category type
  CategoryTypeDTO? type;

  ///Creates a new [CategoryDTO]
  CategoryDTO({
    this.id,
    this.name,
    this.color,
    this.description,
    this.iconURL,
    this.created,
    this.updated,
    this.type,
  });

  ///Creates a [CategoryDTO] form a JSON object
  factory CategoryDTO.fromJson(Map<String, dynamic> json) => CategoryDTO(
        id: JsonParser.parseInt(json['category_id']),
        name: json['category_name'],
        color: json['color'],
        description: json['descritpion'],
        iconURL: json['iconURL'],
        created: JsonParser.parseDate(json['ts_created']),
        updated: JsonParser.parseDate(json['ts_updated']),
        type: CategoryTypeDTO.fromRaw(json['type']),
      );

  /// Creates a list of [CategoryDTO]s from the given JSON list.
  static List<CategoryDTO> fromJsonList(List<Map<String, dynamic>> json) =>
      json.map(CategoryDTO.fromJson).toList();
}

///Data transfer object representing the type for a category
class CategoryTypeDTO extends EnumDTO {
  /// Income
  static const income = CategoryTypeDTO._internal('I');

  /// Expense
  static const expense = CategoryTypeDTO._internal('E');

  /// Transfer
  static const transfer = CategoryTypeDTO._internal('T');

  /// All the possible types for a category
  static const List<CategoryTypeDTO> values = [
    income,
    expense,
    transfer,
  ];

  const CategoryTypeDTO._internal(String value) : super.internal(value);

  /// Creates a [CategoryTypeDTO] from a `String`.
  static CategoryTypeDTO? fromRaw(String? raw) => values.firstWhereOrNull(
        (val) => val.value == raw,
      );
}
