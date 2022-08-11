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

  /// Returns the beneficiary resulting on verifying the second factor for
  /// the passed [beneficiary].
  /// True should be passed in [isEditing]
  /// in case of existing beneficiary is being edited.
  Future<Beneficiary> verifySecondFactor({
    required Beneficiary beneficiary,
    required String otpValue,
    bool isEditing = false,
  });

  /// Resends the second factor for the passed [beneficiary].
  /// True should be passed in [isEditing]
  /// in case of existing beneficiary is being edited.
  Future<Beneficiary> resendSecondFactor({
    required Beneficiary beneficiary,
    bool isEditing = false,
  });

  /// Getting of the beneficiary receipt.
  ///
  /// Returning list of bytes that represents image if [isImage] is true
  /// or PDF if it's false.
  Future<List<int>> getReceipt(
    Beneficiary beneficiary, {
    bool isImage = true,
  });
}
