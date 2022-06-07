import 'package:bloc/bloc.dart';

import '../../../../data_layer/network.dart';
import '../../../domain_layer/models.dart';
import '../../../domain_layer/use_cases/campaign/load_campaigns_use_case.dart';
import '../utils.dart';
import 'campaign_state.dart';

/// Holds campaigns data with types.
/// The more specialized classes are the ones who set this type.
/// This is done to make it easier to use the cubits on a screen that has
/// all the types.
class CampaignCubit extends Cubit<CampaignState> {
  final LoadCampaignsUseCase _loadCampaigns;

  /// Creates a new [CampaignCubit].
  CampaignCubit({
    required LoadCampaignsUseCase loadCampaigns,
    required CampaignStateType campaignStateType,
    //  required CampaignType campaignType,
    required int limit,
  })  : _loadCampaigns = loadCampaigns,
        super(
          CampaignState(
            type: campaignStateType,
            //     campaignType: campaignType,
            pagination: Pagination(
              limit: limit,
            ),
          ),
        );

  /// Loads the campaigns
  ///
  /// The [loadMore] value will load the next campaigns page if true.
  /// Use cases:
  ///   - Listing the public campaigns on the app.
  ///

  Future<void> load({
    List<CampaignType>? types,
    bool? read,
    required int limit,
    required int offset,
    String? sortby,
    bool? desc,
    bool loadMore = false,
  }) async {
    assert(types == null);

    emit(
      state.copyWith(
        busy: true,
        error: CampaignStateError.none,
      ),
    );

    try {
      final newPage = state.pagination.paginate(loadMore: loadMore);

      final response = await _loadCampaigns(
        types: types,
        offset: newPage.offset,
        limit: newPage.limit,
        read: read,
        sortby: sortby,
        desc: desc,
      );

      Iterable<CustomerCampaign> campaigns = newPage.firstPage
          ? response.campaigns
          : [
              ...state.campaigns,
              ...response.campaigns,
            ];

      emit(
        state.copyWith(
          campaigns: campaigns,
          busy: false,
          pagination: newPage.copyWith(
            canLoadMore: campaigns.length < response.totalCount,
          ),
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          busy: false,
          error: e is NetException
              ? CampaignStateError.network
              : CampaignStateError.generic,
          errorMessage: e is NetException ? e.message : null,
        ),
      );

      rethrow;
    }
  }
}
