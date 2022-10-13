import '../../../data_layer/dtos.dart';
import '../../models.dart';

/// An abstract repository for the [Transfer]
abstract class TransferRepositoryInterface {
  /// Lists the transfers from a customer.
  ///
  /// Use [limit] and [offset] to paginate.
  Future<List<Transfer>> list({
    required String customerId,
    int limit = 50,
    int offset = 0,
    bool includeDetails = true,
    bool recurring = false,
    bool forceRefresh = false,
  });

  /// List the frequent transfers from [User]
  ///
  /// Use [limit] and [offset] to paginate.
  Future<List<Transfer>> loadFrequentTransfers({
    int? limit,
    int? offset,
    bool includeDetails = true,
    TransferStatus? status,
    List<TransferType>? types,
  });

  /// Evaluates a transfer.
  Future<TransferEvaluation> evaluate({
    required NewTransferPayloadDTO newTransferPayloadDTO,
  });

  /// Submits a transfer.
  Future<Transfer> submit({
    required NewTransfer transfer,
    required bool editMode,
  });

  /// Sends the otp code for the passed transfer id.
  Future<Transfer> sendOTPCode({
    required int transferId,
    required bool editMode,
  });

  /// Verifies the second factor for the passed transfer id.
  Future<Transfer> verifySecondFactor({
    required int transferId,
    required String value,
    required SecondFactorType secondFactorType,
  });

  /// Resends the second factor for the passed transfer.
  Future<Transfer> resendSecondFactor({
    required NewTransfer transfer,
  });
}
