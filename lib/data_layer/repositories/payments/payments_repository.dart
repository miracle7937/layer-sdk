import '../../../domain_layer/abstract_repositories.dart';
import '../../../domain_layer/models.dart';
import '../../mappings.dart';
import '../../providers.dart';

/// Handles all the payments data
class PaymentRepository implements PaymentsRepositoryInterface {
  final PaymentProvider _provider;

  /// Creates a new repository with the supplied [PaymentProvider]
  PaymentRepository(
    PaymentProvider provider,
  ) : _provider = provider;

  /// Lists the payments of a customer using the provided `customerId`.
  ///
  /// Use the `limit` and `offset` params to paginate.
  Future<List<Payment>> list({
    required String customerId,
    int limit = 50,
    int offset = 0,
    bool forceRefresh = false,
    bool recurring = false,
  }) async {
    final paymentDTOs = await _provider.list(
      customerId: customerId,
      offset: offset,
      limit: limit,
      forceRefresh: forceRefresh,
      recurring: recurring,
    );

    return paymentDTOs.map((e) => e.toPayment()).toList(growable: false);
  }

  @override
  Future<Payment> postPayment({
    required Payment payment,
  }) async {
    final paymentDTO = await _provider.postPayment(
      payment: payment.toPaymentDTO(),
    );

    return paymentDTO.toPayment();
  }

  @override
  Future<Payment> patchPayment({
    required Payment payment,
  }) async {
    final paymentDTO = await _provider.patchPayment(
      payment: payment.toPaymentDTO(),
    );

    return paymentDTO.toPayment();
  }

  /// Sends the OTP code for the passed payment.
  @override
  Future<Payment> sendOTPCode({
    required Payment payment,
    required bool editMode,
  }) async {
    final paymentDTO = await _provider.sendOTPCode(
      payment: payment.toPaymentDTO(),
      editMode: editMode,
    );

    return paymentDTO.toPayment();
  }

  /// Verifies the second factor for the passed payment.
  @override
  Future<Payment> verifySecondFactor({
    required Payment payment,
    required String value,
    required SecondFactorType secondFactorType,
    required bool editMode,
  }) async {
    final paymentDTO = await _provider.verifySecondFactor(
      payment: payment.toPaymentDTO(),
      value: value,
      secondFactorTypeDTO: secondFactorType.toSecondFactorTypeDTO(),
      editMode: editMode,
    );

    return paymentDTO.toPayment();
  }

  /// Resends second factor for the passed payment.
  @override
  Future<Payment> resendSecondFactor({
    required Payment payment,
    required bool editMode,
  }) async {
    final paymentDTO = await _provider.resendSecondFactor(
      payment: payment.toPaymentDTO(),
      editMode: editMode,
    );

    return paymentDTO.toPayment();
  }

  @override
  Future<Payment> deletePayment(
    String id, {
    String? otpValue,
    bool resendOTP = false,
  }) async {
    final paymentDTO = await _provider.deletePaymentV2(
      id,
      otpValue: otpValue,
      resendOTP: resendOTP,
    );

    return paymentDTO.toPayment();
  }
}
