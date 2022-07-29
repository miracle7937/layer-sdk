import 'package:equatable/equatable.dart';

/// Keeps the data of the biller category
class BillerCategory extends Equatable {
  /// The category code this biller belongs to
  final String categoryCode;

  /// The category description of the biller
  final String? categoryDesc;

  /// Creates a new [BillerCategory]
  BillerCategory({
    required this.categoryCode,
    this.categoryDesc,
  });

  @override
  List<Object?> get props => [
        categoryCode,
        categoryDesc,
      ];
}
