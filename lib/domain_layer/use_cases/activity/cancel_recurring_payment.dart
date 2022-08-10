import '../../abstract_repositories.dart';
import '../../models.dart';

/// Use case for canceling a payment
class CancelRecurringPaymentUseCase {
  final ActivityRepositoryInterface _repo;

  /// Creates a new [CancelPaymentUseCase]
  CancelRecurringPaymentUseCase({
    required ActivityRepositoryInterface activityRepository,
  }) : _repo = activityRepository;

  /// Callable method to cancel a payment
  Future<SecondFactorType?> call(
    String id, {
    String? otpValue,
    bool resendOTP = false,
  }) async {
    final result = await _repo.deletePayment(
      id,
      otpValue: otpValue,
      resendOTP: resendOTP,
    );

    return result['second_factor'] == 'O' ? SecondFactorType.otp : null;
  }
}
