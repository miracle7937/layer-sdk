import '../../models.dart';

/// Abstract definition of the repository that handles all the payments data.
abstract class PaymentsRepositoryInterface {
  /// Lists the payments of a customer using the provided `customerId`.
  ///
  /// Use the `limit` and `offset` params to paginate.
  Future<List<Payment>> list({
    required String customerId,
    int limit = 50,
    int offset = 0,
    bool forceRefresh = false,
    bool recurring = false,
  });

  /// Submits the provided payment
  Future<Payment> payBill({
    required Payment payment,
    String? otp,
  });

  /// Resend a second factor request
  Future<Payment> resendSecondFactor({
    required Payment payment,
  });
}
