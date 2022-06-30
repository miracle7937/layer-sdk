import 'dart:collection';

import 'package:equatable/equatable.dart';

import '../../../domain_layer/models/campaign/customer_campaign.dart';
import '../../utils.dart';

/// The available errors.
enum CampaignStateError {
  /// No errors reported.
  none,

  /// Generic error.
  generic,

  /// Network error.
  network,
}

/// The state of the campaign cubit
class CampaignState extends Equatable {
  /// The campaigns.
  final UnmodifiableListView<CustomerCampaign> campaigns;

  /// If it's busy doing something.
  final bool busy;

  /// Holds the current error
  final CampaignStateError error;

  /// Holds the error message
  final String? errorMessage;

  /// Holds the pagination data.
  final Pagination pagination;

  /// Creates a new [CampaignState].
  CampaignState({
    Iterable<CustomerCampaign> campaigns = const <CustomerCampaign>[],
    this.busy = false,
    this.error = CampaignStateError.none,
    this.errorMessage,
    this.pagination = const Pagination(limit: 10),
  }) : campaigns = UnmodifiableListView(campaigns);

  /// Copies the object with different values.
  CampaignState copyWith({
    Iterable<CustomerCampaign>? campaigns,
    bool? busy,
    CampaignStateError? error,
    String? errorMessage,
    Pagination? pagination,
  }) =>
      CampaignState(
        campaigns: campaigns ?? this.campaigns,
        busy: busy ?? this.busy,
        error: error ?? this.error,
        errorMessage: error == CampaignStateError.none
            ? null
            : (errorMessage ?? this.errorMessage),
        pagination: pagination ?? this.pagination,
      );

  @override
  List<Object?> get props => [
        campaigns,
        busy,
        error,
        errorMessage,
        pagination,
      ];
}
