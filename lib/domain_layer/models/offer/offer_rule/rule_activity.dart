import 'package:equatable/equatable.dart';

import '../../../models.dart';

///Contains the data for an activity of a rule
class RuleActivity extends Equatable {
  ///The type for this rule activity
  final RuleActivityType type;

  ///Total needed to meet the decision
  final double total;

  ///Currently reached to meet the decision
  final double reached;

  ///Creates a new [RuleActivity]
  RuleActivity({
    required this.type,
    required this.total,
    required this.reached,
  });

  @override
  List<Object?> get props => [
        type,
        total,
        reached,
      ];
}
