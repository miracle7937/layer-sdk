import 'package:equatable/equatable.dart';

/// THe section this process should be put in.
enum DPAProcessDefinitionSection {
  /// Additional Accounts
  additionalAccount,

  /// Requests
  request,

  /// Others
  other,
}

/// Holds the data of a DPA process.
class DPAProcessDefinition extends Equatable {
  /// The process id.
  final String id;

  /// The key for this process.
  final String? key;

  /// The name of this process.
  final String? name;

  /// A description for this process.
  final String? description;

  /// The url to the icon to use for this process.
  final String? iconUrl;

  /// If this process has been suspended.
  final bool? suspended;

  /// The version number of this process, as a process with the same key can
  /// have several versions
  final int? version;

  /// The deployment id
  final String? deploymentId;

  /// The section to categorize this process.
  final DPAProcessDefinitionSection section;

  /// Creates a new [DPAProcessDefinition].
  DPAProcessDefinition({
    required this.id,
    this.key,
    this.name,
    this.description,
    this.iconUrl,
    this.suspended,
    this.version,
    this.deploymentId,
    required this.section,
  });

  @override
  List<Object?> get props => [
        id,
        key,
        name,
        description,
        iconUrl,
        suspended,
        version,
        deploymentId,
        section,
      ];

  /// Creates a new [DPAProcessDefinition] using another as a base.
  DPAProcessDefinition copyWith({
    String? id,
    String? key,
    String? name,
    String? description,
    String? iconUrl,
    bool? suspended,
    int? version,
    String? deploymentId,
    DPAProcessDefinitionSection? section,
  }) =>
      DPAProcessDefinition(
        id: id ?? this.id,
        key: key ?? this.key,
        name: name ?? this.name,
        description: description ?? this.description,
        iconUrl: iconUrl ?? this.iconUrl,
        suspended: suspended ?? this.suspended,
        version: version ?? this.version,
        deploymentId: deploymentId ?? this.deploymentId,
        section: section ?? this.section,
      );
}
