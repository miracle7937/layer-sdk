import 'package:equatable/equatable.dart';

import '../../models.dart';

/// Keeps the data of the payment biller
class Biller extends Equatable {
  /// The unique id of the biller
  final String id;

  /// The name of the biller
  final String name;

  /// The cateory this biller belongs to
  final BillerCategory category;

  /// The date of creation of the biller
  final DateTime? created;

  /// The last date the biller was updated
  final DateTime? updated;

  /// The image url of the biller
  final String? imageUrl;

  /// Creates a new [Biller]
  const Biller({
    required this.id,
    required this.name,
    required this.category,
    this.created,
    this.updated,
    this.imageUrl,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        category,
        created,
        updated,
        imageUrl,
      ];
}
