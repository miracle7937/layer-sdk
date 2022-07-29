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

  /// Returns the beneficiary dto resulting on verifying the second factor for
  /// the passed transfer id.
  /// True should be passed in [isEditing]
  /// in case of existing beneficiary is being edited.
  Future<Beneficiary> verifySecondFactor({
    required Beneficiary beneficiary,
    required String otpValue,
    bool isEditing = false,
  });

  /// Resends the second factor for the passed [Beneficiary].
  /// True should be passed in [isEditing]
  /// in case of existing beneficiary is being edited.
  Future<Beneficiary> resendSecondFactor({
    required Beneficiary beneficiary,
    bool isEditing = false,
  });
}
