import 'package:equatable/equatable.dart';

/// Holds the information related to the customer's company
class CustomerCompany extends Equatable {
  /// Name of the company.
  final String name;

  /// Type of the company.
  final String type;

  /// Creates a new [CustomerCompany].
  const CustomerCompany({
    this.name = '',
    this.type = '',
  });

  @override
  List<Object?> get props => [
        name,
        type,
      ];

  /// Returns a copy of the [CustomerCompany] with select different values.
  CustomerCompany copyWith({
    String? name,
    String? type,
  }) {
    return CustomerCompany(
      name: name ?? this.name,
      type: type ?? this.type,
    );
  }
}
