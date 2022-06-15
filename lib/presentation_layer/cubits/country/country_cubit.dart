import 'package:bloc/bloc.dart';

import '../../../../../../data_layer/network.dart';
import '../../../domain_layer/use_cases.dart';
import '../../cubits.dart';

///A cubit that holds the countries data
class CountryCubit extends Cubit<CountryState> {
  final LoadCountriesUseCase _loadCountriesUseCase;

  /// Creates a new [CountryCubit] providing an [CountryState].
  CountryCubit({
    required LoadCountriesUseCase loadCountriesUseCase,
  })  : _loadCountriesUseCase = loadCountriesUseCase,
        super(
          CountryState(),
        );

  ///Loads all the countries
  Future<void> load({
    bool registration = false,
    bool forceRefresh = true,
  }) async {
    emit(
      state.copyWith(
        busy: true,
        error: CountriesErrorStatus.none,
      ),
    );

    try {
      final countries = await _loadCountriesUseCase(
        registration: registration,
        forceRefresh: forceRefresh,
      );

      emit(
        state.copyWith(
          countries: countries,
          busy: false,
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          busy: false,
          error: e is NetException
              ? CountriesErrorStatus.network
              : CountriesErrorStatus.generic,
          errorMessage: e is NetException ? e.message : null,
        ),
      );

      rethrow;
    }
  }
}
