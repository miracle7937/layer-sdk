import 'package:bloc/bloc.dart';

import '../../../../../../data_layer/network.dart';
import '../../../domain_layer/models.dart';
import '../../../domain_layer/use_cases.dart';
import '../../cubits.dart';

/// A cubit that handles loading and sharing receipt.
class ReceiptCubit extends Cubit<ReceiptState> {
  final LoadReceiptUseCase _loadReceiptUseCase;
  final ShareReceiptUseCase _shareReceiptUseCase;

  /// Creates a new [ReceiptCubit].
  ReceiptCubit({
    required LoadReceiptUseCase loadReceiptUseCase,
    required ShareReceiptUseCase shareReceiptUseCase,
  })  : _loadReceiptUseCase = loadReceiptUseCase,
        _shareReceiptUseCase = shareReceiptUseCase,
        super(
          ReceiptState(),
        );

  /// Returns an error list that includes the passed action and error status.
  Set<ReceiptError> _addError({
    required ReceiptAction action,
    required ReceiptErrorStatus errorStatus,
    String? code,
    String? message,
  }) =>
      state.errors.union({
        ReceiptError(
          action: action,
          errorStatus: errorStatus,
          code: code,
          message: message,
        )
      });

  /// Loads the receipt.
  Future<void> loadReceipt({
    required String objectId,
    required ReceiptActionType actionType,
    ReceiptType type = ReceiptType.image,
  }) async {
    final isImage = type == ReceiptType.image;
    final action =
        isImage ? ReceiptAction.receiptImage : ReceiptAction.receiptPdf;

    emit(state.copyWith(
      action: action,
      errors: _addError(
        action: ReceiptAction.none,
        errorStatus: ReceiptErrorStatus.none,
      ),
    ));

    try {
      final receipt = await _loadReceiptUseCase(
        objectId: objectId,
        actionType: actionType,
        type: type,
      );
      emit(state.copyWith(
        imageBytes: isImage ? receipt : state.imageBytes,
        pdfBytes: isImage ? state.pdfBytes : receipt,
        action: ReceiptAction.none,
      ));
    } on Exception catch (e) {
      emit(
        state.copyWith(
          action: ReceiptAction.none,
          errors: _addError(
            action: action,
            errorStatus: e is NetException
                ? ReceiptErrorStatus.network
                : ReceiptErrorStatus.generic,
            code: e is NetException ? e.code : null,
            message: e is NetException ? e.message : e.toString(),
          ),
        ),
      );
    }
  }

  /// Share receipt.
  void shareReceipt(
    String filename, {
    bool isImage = true,
  }) {
    _shareReceiptUseCase(
      filename: '${filename}_receipt.'
          '${isImage ? 'jpeg' : 'pdf'}',
      bytes: isImage ? state.imageBytes : state.pdfBytes,
    );
  }
}
