import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data_layer/network.dart';
import '../../../domain_layer/models.dart';
import '../../../domain_layer/use_cases.dart';
import 'mandate_create_state.dart';

/// Cubit for handling the creation of Debit Mandates
class MandateCreateCubit extends Cubit<MandateCreateState> {
  final LoadInfoRendedFileUseCase _mandateFileUseCase;

  /// Creates a new instance of [MandateCreateCubit]
  MandateCreateCubit({
    required LoadInfoRendedFileUseCase renderedFileUseCase,
  })  : _mandateFileUseCase = renderedFileUseCase,
        super(MandateCreateState());

  /// Set the account that can be charged
  void setAccount(Account account) {
    emit(
      state.copyWith(
        account: account,
      ),
    );
  }

  /// set if the user marked the checkbox
  void setHasAccepted({required bool accepted}) {
    emit(
      state.copyWith(hasAccepted: accepted),
    );
  }

  /// Fetches the Mandate pdf file
  Future<void> loadMandateImage({
    required List<MoreInfoField> infoFields,
  }) async {
    emit(
      state.copyWith(
        busy: true,
        errorMessage: '',
        errorStatus: MandateCreateErrorStatus.none,
      ),
    );

    try {
      final mandateFile = await _mandateFileUseCase(infoFields: infoFields);

      emit(
        state.copyWith(
          busy: false,
          errorMessage: '',
          errorStatus: MandateCreateErrorStatus.none,
          mandatePDFFile: mandateFile,
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          busy: false,
          errorMessage: e is NetException ? e.message : e.toString(),
          errorStatus: e is NetException
              ? MandateCreateErrorStatus.network
              : MandateCreateErrorStatus.generic,
        ),
      );

      rethrow;
    }
  }
}
