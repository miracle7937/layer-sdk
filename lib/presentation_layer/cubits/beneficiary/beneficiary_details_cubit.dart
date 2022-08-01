import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain_layer/use_cases.dart';
import '../../cubits.dart';

/// The cubit responsible for handling the beneficiary details actions.
class BeneficiaryDetailsCubit extends Cubit<BeneficiaryDetailsState> {
  final DeleteBeneficiaryUseCase _deleteBeneficiaryUseCase;

  /// Creates new [BeneficiaryDetailsCubit].
  BeneficiaryDetailsCubit({
    required DeleteBeneficiaryUseCase deleteBeneficiaryUseCase,
  })  : _deleteBeneficiaryUseCase = deleteBeneficiaryUseCase,
        super(BeneficiaryDetailsState());

  /// Deletes the beneficiary with the provided id.
  Future<void> delete({
    required int id,
  }) async {
    emit(state.copyWith(
      actions: state.actions.union({
        BeneficiaryDetailsAction.delete,
      }),
      error: BeneficiaryDetailsError.none,
    ));

    try {
      await _deleteBeneficiaryUseCase(id: id);
      emit(state.copyWith(
        actions: state.actions.difference({
          BeneficiaryDetailsAction.delete,
        }),
      ));
    } on Exception {
      emit(state.copyWith(
        actions: state.actions.difference({
          BeneficiaryDetailsAction.delete,
        }),
        error: BeneficiaryDetailsError.generic,
      ));
    }
  }
}
