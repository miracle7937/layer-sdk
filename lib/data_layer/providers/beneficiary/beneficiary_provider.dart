import '../../../../data_layer/network.dart';
import '../../dtos.dart';

/// Provides data about the Beneficiaries
class BeneficiaryProvider {
  /// The NetClient to use for the network requests
  final NetClient netClient;

  /// Creates a new [BeneficiaryProvider] with the supplied netClient.
  BeneficiaryProvider(
    this.netClient,
  );

  /// Returns a list of beneficiaries.
  ///
  /// If the search text is supplied, will filter the results.
  Future<List<BeneficiaryDTO>> list({
    String? customerID,
    String? searchText,
    bool ascendingOrder = true,
    int? limit,
    int? offset,
    bool forceRefresh = false,
  }) async {
    final response = await netClient.request(
      netClient.netEndpoints.beneficiary,
      method: NetRequestMethods.get,
      queryParameters: {
        if (customerID?.isNotEmpty ?? false)
          'beneficiary.customer_id': customerID,
        'asc': ascendingOrder,
        if (limit != null) 'limit': limit,
        if (offset != null) 'offset': offset,
        if (searchText?.isNotEmpty ?? false) 'q': searchText,
      },
      forceRefresh: forceRefresh,
    );

    return BeneficiaryDTO.fromJsonList(
      List<Map<String, dynamic>>.from(
        response.data,
      ),
    );
  }

  /// Add a new beneficiary.
  Future<BeneficiaryDTO> add({
    required BeneficiaryDTO beneficiaryDTO,
    bool forceRefresh = false,
  }) =>
      _changeBeneficiary(
        beneficiaryDTO: beneficiaryDTO,
        forceRefresh: forceRefresh,
      );

  /// Edit the beneficiary.
  Future<BeneficiaryDTO> edit({
    required BeneficiaryDTO beneficiaryDTO,
    bool forceRefresh = false,
  }) =>
      _changeBeneficiary(
        beneficiaryDTO: beneficiaryDTO,
        forceRefresh: forceRefresh,
        isEditing: true,
      );

  Future<BeneficiaryDTO> _changeBeneficiary({
    required BeneficiaryDTO beneficiaryDTO,
    bool isEditing = false,
    bool forceRefresh = false,
  }) async {
    final response = await netClient.request(
      netClient.netEndpoints.beneficiary2,
      method: isEditing ? NetRequestMethods.patch : NetRequestMethods.post,
      data: beneficiaryDTO.toJson(isEditing: isEditing),
      forceRefresh: forceRefresh,
    );

    return BeneficiaryDTO.fromJson(
      Map<String, dynamic>.from(
        response.data,
      ),
    );
  }

  /// Returns the beneficiary dto resulting on verifying the second factor for
  /// the passed transfer id.
  /// True should be passed in [isEditing]
  /// in case of existing beneficiary is being edited.
  Future<BeneficiaryDTO> verifySecondFactor({
    required BeneficiaryDTO beneficiaryDTO,
    required String otpValue,
    bool isEditing = false,
  }) async {
    final response = await netClient.request(
      netClient.netEndpoints.submitTransfer,
      method: isEditing ? NetRequestMethods.patch : NetRequestMethods.post,
      queryParameters: {'otp_value': otpValue},
      data: beneficiaryDTO.toJson(isVerifyOtp: true),
    );

    return BeneficiaryDTO.fromJson(response.data);
  }

  /// Resends the second factor for the passed [BeneficiaryDTO].
  /// True should be passed in [isEditing]
  /// in case of existing beneficiary is being edited.
  Future<BeneficiaryDTO> resendSecondFactor({
    required BeneficiaryDTO beneficiaryDTO,
    bool isEditing = false,
  }) async {
    final response = await netClient.request(
      netClient.netEndpoints.submitTransfer,
      method: isEditing ? NetRequestMethods.patch : NetRequestMethods.post,
      queryParameters: {'resend_otp': true},
      data: beneficiaryDTO.toJson(isEditing: isEditing),
    );

    return BeneficiaryDTO.fromJson(response.data);
  }
}
