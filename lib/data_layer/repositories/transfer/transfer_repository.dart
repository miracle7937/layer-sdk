import '../../../domain_layer/abstract_repositories.dart';
import '../../../domain_layer/models.dart';
import '../../dtos.dart';
import '../../mappings.dart';
import '../../providers.dart';

/// Handles all the transfers data
class TransferRepository implements TransferRepositoryInterface {
  final TransferProvider _provider;

  /// Creates a new repository with the supplied [TransferProvider]
  TransferRepository({
    required TransferProvider provider,
  }) : _provider = provider;

  /// Lists the transfers from a customer.
  ///
  /// Use [limit] and [offset] to paginate.
  @override
  Future<List<Transfer>> list({
    required String customerId,
    int limit = 50,
    int offset = 0,
    bool includeDetails = true,
    bool recurring = false,
    bool forceRefresh = false,
  }) async {
    final transferDTOs = await _provider.list(
      customerId: customerId,
      limit: limit,
      offset: offset,
      includeDetails: includeDetails,
      recurring: recurring,
      forceRefresh: forceRefresh,
    );

    return transferDTOs.map((e) => e.toTransfer()).toList(growable: false);
  }

  /// Lists the frequent transfers from [User].
  ///
  /// Use [limit] and [offset] to paginate.
  @override
  Future<List<Transfer>> loadFrequentTransfers({
    int? limit,
    int? offset,
    bool includeDetails = true,
    TransferStatus? status,
    List<TransferType>? types,
  }) async {
    final frequentTransfersDTOs = await _provider.loadFrequentTransfers(
      limit: limit,
      offset: offset,
      includeDetails: includeDetails,
      status: status,
      types: types,
    );

    return frequentTransfersDTOs.map((e) => e.toTransfer()).toList();
  }

  /// Evaluates a transfer.
  @override
  Future<TransferEvaluation> evaluate({
    required NewTransferPayloadDTO newTransferPayloadDTO,
  }) async {
    final transferEvaluationDTO = await _provider.evaluate(
      newTransferPayloadDTO: newTransferPayloadDTO,
    );

    return transferEvaluationDTO.toTransferEvaluation();
  }

  /// Submits a transfer.
  @override
  Future<Transfer> submit({
    required NewTransfer transfer,
  }) async {
    final transferDTO = await _provider.submit(
      newTransferPayloadDTO: transfer.toNewTransferPayloadDTO(),
    );

    return transferDTO.toTransfer();
  }

  /// Verifies the second factor for the passed transfer id.
  @override
  Future<Transfer> verifySecondFactor({
    required int transferId,
    required String otpValue,
    required SecondFactorType secondFactorType,
  }) async {
    final transferDTO = await _provider.verifySecondFactor(
      transferId: transferId,
      otpValue: otpValue,
      secondFactorTypeDTO: secondFactorType.toSecondFactorTypeDTO(),
    );

    return transferDTO.toTransfer();
  }

  /// Resends the second factor for the passed transfer id.
  @override
  Future<Transfer> resendSecondFactor({
    required NewTransfer transfer,
  }) async {
    final transferDTO = await _provider.resendSecondFactor(
      newTransferPayloadDTO: transfer.toNewTransferPayloadDTO(),
    );

    return transferDTO.toTransfer();
  }
}
