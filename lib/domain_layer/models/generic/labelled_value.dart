import 'package:equatable/equatable.dart';

/// This is a model that will hold some label/value data
class LabelledValue extends Equatable {
  /// The label of the model
  final String label;

  /// The value of the model
  final String value;

  /// The optional description
  final String? description;

  /// Extra info we need to pass to instant
  final LabelledValueExtraInfo? labelledValueExtraInfo;

  /// Create new instant of [LabelledValue]
  const LabelledValue({
    required this.label,
    required this.value,
    this.description,
    this.labelledValueExtraInfo,
  });

  @override
  List<Object?> get props => [
        label,
        value,
        description,
        labelledValueExtraInfo,
      ];
}

/// This is an abstract class that will help customizing the extra info about
/// the label and the value.
///
/// Implement this abstract class to add your custom extra data for the label
/// and the value.
abstract class LabelledValueExtraInfo extends Equatable {}
