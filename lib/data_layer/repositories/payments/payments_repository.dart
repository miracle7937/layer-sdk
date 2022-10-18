import '../../../domain_layer/abstract_repositories.dart';
import '../../../domain_layer/models.dart';
import '../../dtos/payment/payment_dto.dart';
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
    String? otp,
  }) async {
    final paymentDTO = await _provider.postPayment(
      payment: payment.toPaymentDTO(),
      otp: otp,
    );

    return paymentDTO.toPayment();
  }

  @override
  Future<Payment> patchPayment({
    required Payment payment,
    String? otp,
    bool resendOtp = false,
  }) async {
    final paymentDTO = await _provider.patchPayment(
      payment: payment.toPaymentDTO(),
      otp: otp,
      resendOtp: resendOtp,
    );

    return paymentDTO.toPayment();
  }

  /// Sends the OTP code for the passed payment id.
  @override
  Future<Payment> sendOTPCode({
    required int paymentId,
    required bool editMode,
  }) async {
    final paymentDTO = await _provider.sendOTPCode(
      paymentId: paymentId,
      editMode: editMode,
    );

    return paymentDTO.toPayment();
  }

  /// Verifies the second factor for the passed payment id.
  @override
  Future<Payment> verifySecondFactor({
    required int paymentId,
    required String value,
    required SecondFactorType secondFactorType,
  }) async {
    final paymentDTO = await _provider.verifySecondFactor(
      paymentId: paymentId,
      value: value,
      secondFactorTypeDTO: secondFactorType.toSecondFactorTypeDTO(),
    );

    return paymentDTO.toPayment();
  }

  @override
  Future<Payment> resendOTP({
    required Payment payment,
  }) async {
    final paymentDTO = await _provider.resendOTP(
      payment: payment.toPaymentDTO(),
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
