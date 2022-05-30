import 'package:equatable/equatable.dart';

///The category type
enum CategoryType {
  ///Income
  income,

  ///Expense
  expense,

  ///Transfer
  transfer,
}

/// Contains the data for a category
class Category extends Equatable {
  ///The category's id
  final int? id;

  ///The category's name
  final String? name;

  ///The hex color for the category
  final String? color;

  ///The description of the category
  final String? description;

  ///The icon url of the category
  final String? iconURL;

  ///When the category was created
  final DateTime? created;

  ///Last time the category was updated
  final DateTime? updated;

  ///The category type
  final CategoryType? type;

  ///Creates a new [Category]
  Category({
    this.id,
    this.name,
    this.color,
    this.description,
    this.iconURL,
    this.created,
    this.updated,
    this.type,
  });

  ///Creates a copy of this category with different values
  Category copyWith({
    int? id,
    String? name,
    String? color,
    String? description,
    String? iconURL,
    DateTime? created,
    DateTime? updated,
    CategoryType? type,
  }) =>
      Category(
        id: id ?? this.id,
        name: name ?? this.name,
        color: color ?? this.color,
        description: description ?? this.description,
        iconURL: iconURL ?? this.iconURL,
        created: created ?? this.created,
        updated: updated ?? this.updated,
        type: type ?? this.type,
      );

  @override
  List<Object?> get props => [
        id,
        name,
        color,
        description,
        iconURL,
        created,
        updated,
        type,
      ];
}
