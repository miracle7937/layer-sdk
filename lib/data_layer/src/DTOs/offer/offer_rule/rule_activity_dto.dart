import '../../../dtos.dart';
import '../../../helpers.dart';

///Data transfer object representing an activity for an offer rule
class RuleActivityDTO {
  ///The type for this rule activity
  RuleActivityTypeDTO? type;

  ///Total needed to meet the decision
  double? total;

  ///Currently reached to meet the decision
  double? reached;

  ///Creates a new [RuleActivityDTO]
  RuleActivityDTO({
    this.type,
    this.total,
    this.reached,
  });

  ///Creates a [RuleActivityDTO] form a JSON object
  factory RuleActivityDTO.fromJson(Map<String, dynamic> json) =>
      RuleActivityDTO(
        type: RuleActivityTypeDTO.fromRaw(json['activity_type']),
        total: JsonParser.parseDouble(json['total']),
        reached: JsonParser.parseDouble(json['reached']),
      );

  /// Creates a list of [RuleActivityDTO]s from the given JSON list.
  static List<RuleActivityDTO> fromJsonList(List<Map<String, dynamic>> json) =>
      json.map(RuleActivityDTO.fromJson).toList();
}
