import 'package:equatable/equatable.dart';

/// Holds the data for the next of kin.
class NextOfKin extends Equatable {
  /// Name of the next of kin.
  final String name;

  /// Relationship with the next of kin.
  final String relationship;

  /// Phone number of next of kin.
  final String mobile;

  /// Creates a new [NextOfKin].
  const NextOfKin({
    this.name = '',
    this.relationship = '',
    this.mobile = '',
  });

  @override
  List<Object?> get props => [
        name,
        relationship,
        mobile,
      ];
}
