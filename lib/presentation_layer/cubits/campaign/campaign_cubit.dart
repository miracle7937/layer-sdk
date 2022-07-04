import 'package:bloc/bloc.dart';

import '../../../../data_layer/network.dart';
import '../../../domain_layer/models.dart';
import '../../../domain_layer/use_cases.dart';
import '../../utils.dart';
import 'campaign_state.dart';

/// A cubit that retrievs campaigns data with types.
class CampaignCubit extends Cubit<CampaignState> {
  final LoadCampaignsUseCase _loadCampaigns;

  /// Creates a new [CampaignCubit].
  CampaignCubit({
    required LoadCampaignsUseCase loadCampaigns,
    int limit = 10,
    int offset = 0,
  })  : _loadCampaigns = loadCampaigns,
        super(
          CampaignState(
            pagination: Pagination(
              limit: limit,
              offset: offset,
            ),
          ),
        );

  /// Loads the campaigns
  ///
  /// The [loadMore] value will load the next campaigns page if true.
  /// Use cases:
  ///   - Listing the campaigns on the app.
  ///
  Future<void> load({
    required List<CampaignType> types,
    bool? read,
    String? sortby,
    bool? desc,
    bool loadMore = false,
  }) async {
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
