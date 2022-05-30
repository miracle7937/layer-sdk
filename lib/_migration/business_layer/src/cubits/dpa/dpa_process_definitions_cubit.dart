import 'package:bloc/bloc.dart';

import 'package:logging/logging.dart';

import '../../../../../data_layer/network.dart';
import '../../../../data_layer/data_layer.dart';
import '../../../business_layer.dart';

/// A cubit that manages a list of DPA processes definitions available for
/// this user.
class DPAProcessDefinitionsCubit extends Cubit<DPAProcessDefinitionsState> {
  final _log = Logger('DPAProcessDefinitionsCubit');

  final DPARepository _repository;

  /// Creates a new cubit using the supplied [DPARepository].
  DPAProcessDefinitionsCubit({
    required DPARepository repository,
  })  : _repository = repository,
        super(DPAProcessDefinitionsState());

  /// Loads all the tasks available for this user.
  ///
  /// If [forceRefresh] is true, will skip the cache.
  /// Defaults to `false`.
  ///
  /// if [onlyLatestVersions] is true, the only the latest version will be
  /// retrieved.
  /// Defaults to `true`.
  Future<void> load({
    bool forceRefresh = false,
    bool onlyLatestVersions = true,
  }) async {
    _log.info('Load. Forcing refresh? $forceRefresh');

    emit(
      state.copyWith(
        busy: true,
        errorStatus: DPAProcessDefinitionsErrorStatus.none,
      ),
    );

    try {
      final definitions = await _repository.listProcessDefinitions(
        forceRefresh: forceRefresh,
        onlyLatestVersions: onlyLatestVersions,
      );

      emit(
        state.copyWith(
          definitions: definitions,
          busy: false,
        ),
      );
    } on NetException {
      emit(
        state.copyWith(
          busy: false,
          errorStatus: DPAProcessDefinitionsErrorStatus.network,
        ),
      );
    }
  }
}
