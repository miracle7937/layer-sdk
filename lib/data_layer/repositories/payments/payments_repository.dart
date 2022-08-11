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
  Future<Payment> payBill({
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
  Future<Payment> patchBill({
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
