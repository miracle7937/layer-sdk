import '../../models.dart';

/// Repository responsible for handling all the beneficiaries data.
abstract class BeneficiaryRepositoryInterface {
  /// Lists the beneficiaries.
  /// Of the provided `customerId`, if passed.
  /// Optionally filtering by searchText.
  ///
  /// Use [limit] and [offset] to paginate.
  Future<List<Beneficiary>> list({
    String? customerId,
    String? searchText,
    int limit = 50,
    int offset = 0,
    bool forceRefresh = false,
    bool activeOnly = false,
  });

  /// Deletes the beneficiary with the provided id.
  Future<Beneficiary> delete({
    required int id,
  });

  /// Add a new beneficiary.
  Future<Beneficiary> add({
    required Beneficiary beneficiary,
    bool forceRefresh = false,
  });

  /// Edit the beneficiary.
  Future<Beneficiary> edit({
    required Beneficiary beneficiary,
    bool forceRefresh = false,
  });

  /// Sends the otp code for the passed [beneficiary].
  /// True should be passed in [isEditing]
  /// in case of existing beneficiary is being edited.
  Future<Beneficiary> sendOTPCode({
    required Beneficiary beneficiary,
    required bool isEditing,
  });

  /// Returns the beneficiary resulting on verifying the second factor for
  /// the passed [beneficiary].
  /// True should be passed in [isEditing]
  /// in case of existing beneficiary is being edited.
  Future<Beneficiary> verifySecondFactor({
    required Beneficiary beneficiary,
    required String value,
    required SecondFactorType secondFactorType,
    bool isEditing = false,
  });

  /// Resends the second factor for the passed [beneficiary].
  /// True should be passed in [isEditing]
  /// in case of existing beneficiary is being edited.
  Future<Beneficiary> resendSecondFactor({
    required Beneficiary beneficiary,
    bool isEditing = false,
  });
}
