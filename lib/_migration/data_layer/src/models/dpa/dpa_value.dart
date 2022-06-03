import 'package:equatable/equatable.dart';

import '../../../models.dart';

/// Holds the allowed values for a [DPAVariable].
class DPAValue extends Equatable {
  /// Value id
  final String id;

  /// Name
  final String name;

  /// Icon
  final String? icon;

  /// URL to an associated image.
  final String? imageUrl;

  /// A name to use when defining sub values.
  final String? subName;

  /// The description of this value.
  final String? description;

  /// The available fields for this value.
  final Iterable<DPAValueField> fields;

  /// Creates a new [DPAValue].
  DPAValue({
    required this.id,
    required this.name,
    this.icon,
    this.imageUrl,
    this.subName,
    this.description,
    this.fields = const [],
  });

  @override
  List<Object?> get props => [
        id,
        name,
        icon,
        imageUrl,
        subName,
        description,
        fields,
      ];

  /// Creates a new [DPAValue] using another as a base.
  DPAValue copyWith({
    String? id,
    String? name,
    String? icon,
    String? imageUrl,
    String? subName,
    String? description,
    Iterable<DPAValueField>? fields,
  }) =>
      DPAValue(
        id: id ?? this.id,
        name: name ?? this.name,
        icon: icon ?? this.icon,
        imageUrl: imageUrl ?? this.imageUrl,
        subName: subName ?? this.subName,
        description: description ?? this.description,
        fields: fields ?? this.fields,
      );
}
