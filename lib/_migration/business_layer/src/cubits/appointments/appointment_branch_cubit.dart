import 'package:bloc/bloc.dart';

import '../../../../../data_layer/network.dart';
import '../../../../data_layer/data_layer.dart';
import 'appointment_branch_state.dart';

/// Class that manages a list of Branches and sets a selected branch
class AppointmentBranchCubit extends Cubit<AppointmentBranchState> {
  final BranchRepository _repository;

  /// Creates a new [AppointmentBranchCubit]
  AppointmentBranchCubit({
    required BranchRepository repository,
    Branch? selectedBranch,
  })  : _repository = repository,
        super(
          AppointmentBranchState(busy: true),
        );

  /// User latidude (used for calculating distance on BE)
  double? _lat;

  /// User longitude (used for calculating distance on BE)
  double? _long;

  /// Search query to filter branches
  String? _searchQuery;

  /// Loads the first page in the list of branches
  Future<void> load({
    bool forceRefresh = false,
    double? lat,
    double? long,

    /// Search query to filter branches, pass as null to fetch all branches
    String? searchQuery,
  }) {
    _lat = lat;
    _long = long;
    _searchQuery = searchQuery;
    return _load(forceRefresh: forceRefresh);
  }

  /// Loads the next page in the list of branches
  /// and adds them to the currenct list
  Future<void> loadMore({
    bool forceRefresh = false,
  }) {
    return _load(
      forceRefresh: forceRefresh,
      loadMore: true,
    );
  }

  Future<void> _load({
    bool forceRefresh = false,
    bool loadMore = false,
  }) async {
    emit(
      state.copyWith(
        busy: true,
        error: AppointmentBranchStateError.none,
        busyAction: loadMore
            ? AppointBranchBusyAction.loadingMore
            : AppointBranchBusyAction.loading,
      ),
    );

    try {
      final newPage = state.pagination.paginate(loadMore: loadMore);

      final foundBranches = await _repository.list(
        forceRefresh: forceRefresh,
        limit: newPage.limit,
        offset: newPage.offset,
        lat: _lat,
        long: _long,
        searchQuery: _searchQuery,
      );

      final Iterable<Branch> branches = newPage.firstPage
          ? foundBranches
          : [
              ...state.branches,
              ...foundBranches,
            ];

      emit(
        state.copyWith(
          branches: branches,
          busy: false,
          pagination: newPage.refreshCanLoadMore(
            loadedCount: foundBranches.length,
          ),
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          busy: false,
          error: e is NetException
              ? AppointmentBranchStateError.network
              : AppointmentBranchStateError.generic,
          errorMessage: e is NetException ? e.message : e.toString(),
        ),
      );

      rethrow;
    }
  }
}
