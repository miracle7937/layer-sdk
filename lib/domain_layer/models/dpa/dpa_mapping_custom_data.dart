import 'package:equatable/equatable.dart';

import '../../models.dart';

/// Holds data that can be used by different DPA mappings to set variables,
/// tasks, etc.
class DPAMappingCustomData extends Equatable {
  /// A custom token that can be used in different situations.
  ///
  /// For instance, for a [DPAVariable] that is a link, this can be used
  /// to set the authentication token for the HTTP header.
  final String token;

  /// The base URL to use to fetch files.
  final String fileBaseURL;

  /// The [DPAVariablePropertyType] form the [DPAVariableProperty].
  final DPAVariablePropertyType? propertyType;

  /// Creates a new [DPAMappingCustomData].
  const DPAMappingCustomData({
    required this.token,
    required this.fileBaseURL,
    this.propertyType,
  });

  /// Creates a new custom data object based on this one.
  DPAMappingCustomData copyWith({
    String? token,
    String? fileBaseURL,
    DPAVariablePropertyType? propertyType,
  }) =>
      DPAMappingCustomData(
        token: token ?? this.token,
        fileBaseURL: fileBaseURL ?? this.fileBaseURL,
        propertyType: propertyType ?? this.propertyType,
      );

  @override
  List<Object?> get props => [
        token,
        fileBaseURL,
        propertyType,
      ];
}
