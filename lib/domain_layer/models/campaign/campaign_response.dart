import 'dart:collection';

import 'package:equatable/equatable.dart';

import '../../models.dart';

/// A model representing data returned after calling the campaigns endpoint.
class CampaignResponse extends Equatable {
  /// The total count of campaigns for the query
  final int totalCount;

  ///The list of campaigns
  final UnmodifiableListView<CustomerCampaign> campaigns;

  /// Creates [CampaignResponse].
  CampaignResponse({
    required this.totalCount,
    required Iterable<CustomerCampaign> campaigns,
  }) : campaigns = UnmodifiableListView(campaigns);

  /// Returns a copy modified by provided data.
  CampaignResponse copyWith({
    int? totalCount,
    Iterable<CustomerCampaign>? campaigns,
  }) =>
      CampaignResponse(
        totalCount: totalCount ?? this.totalCount,
        campaigns: campaigns ?? this.campaigns,
      );

  @override
  List<Object?> get props => [
        totalCount,
        campaigns,
      ];
}
