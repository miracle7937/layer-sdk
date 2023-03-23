import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';

import '../../../data_layer/network.dart';
import '../../../domain_layer/models.dart';
import '../../../domain_layer/use_cases.dart';
import 'mandate_create_state.dart';

/// Cubit for handling the creation of Debit Mandates
class MandateCreateCubit extends Cubit<MandateCreateState> {
  final LoadInfoRenderedFileUseCase _mandateFileUseCase;

  /// Creates a new instance of [MandateCreateCubit]
  MandateCreateCubit({
    required LoadInfoRenderedFileUseCase renderedFileUseCase,
  })  : _mandateFileUseCase = renderedFileUseCase,
        super(MandateCreateState());

  /// TODO: cubit_issue | This seems to be UI only logic. Should not be placed
  /// on the cubit state.
  ///
  /// Set the account that can be charged
  void setAccount(Account account) {
    emit(
      state.copyWith(
        account: account,
      ),
    );
  }

  /// TODO: cubit_issue | This seems to be UI only logic. Should not be placed
  /// on the cubit state.
  ///
  /// set if the user marked the checkbox
  void setHasAccepted({
    required bool accepted,
  }) {
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
        errorStatus: MandateCreateErrorStatus.none,
      ),
    );

    try {
      final mandateFile = await _mandateFileUseCase(infoFields: infoFields);

      emit(
        state.copyWith(
          busy: false,
          mandatePDFFile: mandateFile,
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          busy: false,
          errorMessage: e is NetException ? e.message : null,
          errorStatus: e is NetException
              ? MandateCreateErrorStatus.network
              : MandateCreateErrorStatus.generic,
        ),
      );

      rethrow;
    }
  }

  /// TODO: cubit_issue | This does not seem to be something that the cubit
  /// should handle. Looks more like a method that could be converted into a
  /// mixin for opening files and being used directly by the UI.
  ///
  /// Opens the more info pdf
  Future<void> getMoreInfoPdf(
    List<int> bytes,
    String? id, {
    bool isImage = false,
  }) async {
    final appDocDir = await getApplicationDocumentsDirectory();
    final appPath = appDocDir.path;
    final fileFormat = isImage ? "png" : "pdf";
    final path =
        '$appPath/direct_debit_more_info${id != null ? "_$id" : ""}.$fileFormat';
    final file = File(path);
    await file.writeAsBytes(bytes);

    OpenFilex.open(
      file.path,
      uti: isImage ? 'public.jpeg' : 'com.adobe.pdf',
      type: isImage ? 'image/jpeg' : 'application/pdf',
    );
  }
}
