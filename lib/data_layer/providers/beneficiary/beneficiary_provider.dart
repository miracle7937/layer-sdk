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
    int? limit,
    int? offset,
    bool forceRefresh = false,
    bool activeOnly = false,
  }) async {
    final response = await netClient.request(
      netClient.netEndpoints.beneficiary,
      method: NetRequestMethods.get,
      queryParameters: {
        if (customerID?.isNotEmpty ?? false)
          'beneficiary.customer_id': customerID,
        'asc': true,
        'sortby': 'nickname',
        if (limit != null) 'limit': limit,
        if (offset != null) 'offset': offset,
        if (searchText?.isNotEmpty ?? false) 'q': searchText,
        if (activeOnly) 'status': 'A',
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
      data: beneficiaryDTO.toJson(),
      forceRefresh: forceRefresh,
    );

    return BeneficiaryDTO.fromJson(
      Map<String, dynamic>.from(
        response.data,
      ),
    );
  }

  /// Returns the beneficiary dto resulting on sending the OTP code for the
  /// passed beneficiary id.
  Future<BeneficiaryDTO> sendOTPCode({
    required int beneficiaryId,
    required bool editMode,
  }) async {
    final response = await netClient.request(
      netClient.netEndpoints.beneficiary2,
      method: editMode ? NetRequestMethods.patch : NetRequestMethods.post,
      data: {
        'beneficiary_id': beneficiaryId,
        'second_factor': SecondFactorTypeDTO.otp.value,
      },
    );

    return BeneficiaryDTO.fromJson(response.data);
  }

  /// Returns the beneficiary dto resulting on verifying the second factor for
  /// the passed [beneficiaryDTO].
  /// True should be passed in [isEditing]
  /// in case of existing beneficiary is being edited.
  Future<BeneficiaryDTO> verifySecondFactor({
    required BeneficiaryDTO beneficiaryDTO,
    required String value,
    required SecondFactorTypeDTO secondFactorTypeDTO,
    bool isEditing = false,
  }) async {
    final data = beneficiaryDTO.toJson();

    data.addAll({
      'second_factor': secondFactorTypeDTO.value,
      if (secondFactorTypeDTO == SecondFactorTypeDTO.ocra)
        'client_response': value,
      if (secondFactorTypeDTO == SecondFactorTypeDTO.otp) 'otp_value': value,
    });

    final response = await netClient.request(
      netClient.netEndpoints.beneficiary2,
      method: isEditing ? NetRequestMethods.patch : NetRequestMethods.post,
      queryParameters: data,
      data: beneficiaryDTO.toJson(),
    );

    return BeneficiaryDTO.fromJson(response.data);
  }

  /// Resends the second factor for the passed [beneficiaryDTO].
  /// True should be passed in [isEditing]
  /// in case of existing beneficiary is being edited.
  Future<BeneficiaryDTO> resendSecondFactor({
    required BeneficiaryDTO beneficiaryDTO,
    bool isEditing = false,
  }) async {
    final response = await netClient.request(
      netClient.netEndpoints.beneficiary2,
      method: isEditing ? NetRequestMethods.patch : NetRequestMethods.post,
      queryParameters: {'resend_otp': true},
      data: beneficiaryDTO.toJson(),
    );

    return BeneficiaryDTO.fromJson(response.data);
  }

  /// Deletes the beneficiary with the provided id.
  Future<BeneficiaryDTO> delete({
    required int id,
  }) async {
    final response = await netClient.request(
      '${netClient.netEndpoints.beneficiary}/$id',
      method: NetRequestMethods.delete,
    );

    return BeneficiaryDTO.fromJson(response.data);
  }
}
