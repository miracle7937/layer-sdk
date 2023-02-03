import 'package:flutter/foundation.dart';

import '../../../domain_layer/abstract_repositories.dart';
import '../../../domain_layer/models.dart';
import '../../mappings.dart';
import '../../providers.dart';

/// Handles all the payments data
class PaymentRepository implements PaymentsRepositoryInterface {
  /// Provider used for interacting with the API.
  @protected
  final PaymentProvider provider;

  /// Creates a new repository with the supplied [PaymentProvider]
  PaymentRepository(
    this.provider,
  );

  @override
  Future<Payment> postPayment({
    required Payment payment,
  }) async {
    final paymentDTO = await provider.postPayment(
      payment: payment.toPaymentDTO(),
    );

    return paymentDTO.toPayment();
  }

  @override
  Future<Payment> patchPayment({
    required Payment payment,
  }) async {
    final paymentDTO = await provider.patchPayment(
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
    final paymentDTO = await provider.sendOTPCode(
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
    final paymentDTO = await provider.verifySecondFactor(
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
    final paymentDTO = await provider.resendSecondFactor(
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
    final paymentDTO = await provider.deletePaymentV2(
      id,
      otpValue: otpValue,
      resendOTP: resendOTP,
    );

    return paymentDTO.toPayment();
  }
}
