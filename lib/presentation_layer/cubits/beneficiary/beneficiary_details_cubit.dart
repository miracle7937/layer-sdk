import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data_layer/network.dart';
import '../../../domain_layer/use_cases.dart';
import '../../cubits.dart';
import '../../extensions.dart';

/// TODO: cubit_issue | I think we should also have a method here for retrieving
/// the beneficiary details. We are assuming that we have the beneficiary
/// object before opening the details.
///
/// But maybe we can have use cases where this is not true (example: opening
/// the beneficiary details from a deeplink or a notification).
///
/// For me, checking the name for this cubit, makes me think that I will have
/// all the available actions that can be done to a beneficiary on the
/// details screen.
///
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
    } on Exception catch (e, st) {
      logException(e, st);
      final standingOrder = e is NetException
          ? e.code == CubitErrorCode.beneficiaryHasStandingOrder.value
          : false;

      emit(
        state.copyWith(
          actions: state.actions.difference({
            BeneficiaryDetailsAction.delete,
          }),
          error: standingOrder
              ? BeneficiaryDetailsError.beneficiaryHasStandingOrder
              : BeneficiaryDetailsError.generic,
        ),
      );
    }
  }
}
