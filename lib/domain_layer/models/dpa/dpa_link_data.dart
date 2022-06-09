import 'package:equatable/equatable.dart';

/// A helper class that keeps the data of a DPA variable link.
class DPALinkData extends Equatable {
  /// The text that comes before the link.
  final String beforeLink;

  /// The link.
  final String link;

  /// The text that comes after the link.
  final String afterLink;

  /// The original text of this [DPALinkData].
  final String originalText;

  /// Creates a new [DPALinkData].
  const DPALinkData({
    required this.beforeLink,
    required this.link,
    required this.afterLink,
    required this.originalText,
  });

  @override
  List<Object?> get props => [
        beforeLink,
        link,
        afterLink,
        originalText,
      ];

  /// Creates a new [DPALinkData] using values from this one.
  DPALinkData copyWith({
    String? beforeLink,
    String? link,
    String? afterLink,
    String? originalText,
  }) =>
      DPALinkData(
        beforeLink: beforeLink ?? this.beforeLink,
        link: link ?? this.link,
        afterLink: afterLink ?? this.afterLink,
        originalText: originalText ?? this.originalText,
      );
}
