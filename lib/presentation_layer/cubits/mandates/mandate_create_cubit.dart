import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

import '../../../data_layer/dtos/more_info/more_info_field_dto.dart';
import '../../../data_layer/mappings.dart';
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
      var fields = <MoreInfoFieldDTO>[];

      for (var f in infoFields) {
        fields.add(f.toMoreInfoFieldDTO());
      }

      final mandateFile = await _mandateFileUseCase(infoFields: fields);

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

    OpenFile.open(
      file.path,
      uti: isImage ? 'public.jpeg' : 'com.adobe.pdf',
      type: isImage ? 'image/jpeg' : 'application/pdf',
    );
  }
}
