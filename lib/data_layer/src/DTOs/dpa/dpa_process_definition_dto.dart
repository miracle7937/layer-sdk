import '../../dtos.dart';

/// Holds the definition of a DPA process.
class DPAProcessDefinitionDTO {
  /// The process id.
  final String? id;

  /// The key for this process.
  final String key;

  /// The version number of this process, as a process with the same key can
  /// have several versions
  final int? version;

  /// The version number of this the deployed process,
  final String? deploymentVersion;

  /// An optional tag for this version.
  final String? versionTag;

  /// The name of this process.
  final String? name;

  /// A description for this process.
  final String? description;

  /// The category of this process
  final String? category;

  /// The deployment id
  final String? deploymentId;

  /// Diagram for this process.
  final String? diagram;

  /// How long should this live in history.
  final String? historyTimeToLive;

  /// The resource of this process.
  final String? resource;

  /// If this process has been suspended.
  final bool? suspended;

  /// A optional tag for this process.
  final String? tag;

  /// The tenant id.
  final String? tenantId;

  /// The role.
  final String? role;

  /// An optional property for this process.
  final DPAVariablePropertyDTO? property;

  /// Creates a new [DPAProcessDefinitionDTO].
  DPAProcessDefinitionDTO({
    this.id,
    required this.key,
    this.version,
    this.deploymentVersion,
    this.versionTag,
    this.name,
    this.description,
    this.category,
    this.deploymentId,
    this.diagram,
    this.historyTimeToLive,
    this.resource,
    this.suspended,
    this.tag,
    this.tenantId,
    this.role,
    this.property,
  });

  /// Creates a new [DPAProcessDefinitionDTO] from a JSON.
  factory DPAProcessDefinitionDTO.fromJson(Map<String, dynamic> json) =>
      DPAProcessDefinitionDTO(
        id: json['id'],
        key: json['key'],
        version: json['version'],
        deploymentVersion: json['deployment_version']?.toString(),
        versionTag: json['versionTag'],
        name: json['name'],
        description: json['description'],
        category: json['category'],
        deploymentId: json['deploymentId'],
        diagram: json['diagram'],
        historyTimeToLive: json['historyTimeToLive'],
        resource: json['resource'],
        suspended: json['suspended'] ?? false,
        tag: json['tag'],
        tenantId: json['tenantId'],
        role: json['role'],
        property: json['property'] == null
            ? null
            : DPAVariablePropertyDTO.fromJson(json['property']),
      );

  /// Returns a list of [DPAProcessDefinitionDTO] based on the given list of
  /// JSONs.
  static List<DPAProcessDefinitionDTO> fromJsonList(
          List<Map<String, dynamic>> json) =>
      json.map(DPAProcessDefinitionDTO.fromJson).toList();
}
