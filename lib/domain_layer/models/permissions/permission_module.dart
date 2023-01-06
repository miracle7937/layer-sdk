import 'package:collection/collection.dart';
import 'package:equatable/equatable.dart';

import '../../models.dart';

/// Holds the data of a permission module.
class PermissionModule extends Equatable {
  /// The module id.
  final String id;

  /// The regular expression to use for selecting the URL.
  final String urlRegex;

  /// A list of [ModulePermissionDefinition] that define this module.
  final UnmodifiableListView<ModulePermissionDefinition> definitions;

  /// Creates a new [PermissionModule].
  PermissionModule({
    required this.id,
    required this.urlRegex,
    required Iterable<ModulePermissionDefinition> definitions,
  }) : definitions = UnmodifiableListView(definitions);

  @override
  List<Object> get props => [
        id,
        urlRegex,
        definitions,
      ];

  /// Returns a copy of this module with select different values.
  PermissionModule copyWith({
    String? id,
    String? urlRegex,
    Iterable<ModulePermissionDefinition>? definitions,
  }) =>
      PermissionModule(
        id: id ?? this.id,
        urlRegex: urlRegex ?? this.urlRegex,
        definitions: definitions ?? this.definitions,
      );
}
