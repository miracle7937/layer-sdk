import 'dart:collection';

import 'package:equatable/equatable.dart';

///The operation for a decision
enum DecisionOperation {
  /// = (default)
  equal,

  /// <=
  lessOrEqual,

  /// >=
  greaterOrEqual,

  /// <
  less,

  /// >
  greater,
}

/// The decision elements supported in the apps.
///
/// This enum does not cover all of the values returned by the API, please only
/// add values here if you need to display them in the app.
///
/// All values returned by the API that are not supported by this enum
/// will be filtered out in DTO mapping.
enum DecisionElement {
  /// Decision is based on the amount of money spent in card transactions.
  cardSpend,

  /// Decision is based on the number of transactions made.
  numberOfTransactions,
}

///Contains the data for a decision of a rule
class RuleDecision extends Equatable {
  ///Dynamic decision fields:
  final DecisionElement element;

  ///The operation for this decision
  final DecisionOperation operation;

  ///Values to compare element with
  final UnmodifiableListView<dynamic>? values;

  ///Creates a new [RuleDecision]
  RuleDecision({
    required this.element,
    required this.operation,
    Iterable<dynamic>? values,
  }) : values = values != null ? UnmodifiableListView(values) : null;

  ///Creates a copy of this rule reward with different values
  RuleDecision copyWith({
    DecisionElement? element,
    DecisionOperation? operation,
    Iterable<dynamic>? values,
  }) =>
      RuleDecision(
        element: element ?? this.element,
        operation: operation ?? this.operation,
        values: values ?? this.values,
      );

  @override
  List<Object?> get props => [
        element,
        operation,
        values,
      ];
}
