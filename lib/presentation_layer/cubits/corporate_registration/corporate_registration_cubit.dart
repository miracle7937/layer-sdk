import 'package:bloc/bloc.dart';

import '../../../data_layer/mappings.dart';
import '../../../data_layer/network.dart';
import '../../../domain_layer/models.dart';
import '../../../domain_layer/use_cases.dart';
import '../../cubits.dart';

/// A cubit that encapsulates the logic related to the corporate registration.
class CorporateRegistrationCubit extends Cubit<CorporateRegistrationState> {
  final RegisterCorporationUseCase _registerCorporationUseCase;
  final LoadCustomerByIdUseCase _loadCustomerByIdUseCase;

  /// Creates [CorporateRegistrationCubit].
  CorporateRegistrationCubit({
    required RegisterCorporationUseCase registerCorporationUseCase,
    required LoadCustomerByIdUseCase loadCustomerByIdUseCase,
  })  : _registerCorporationUseCase = registerCorporationUseCase,
        _loadCustomerByIdUseCase = loadCustomerByIdUseCase,
        super(CorporateRegistrationState());

  /// Checks if corporate for [profile] is already exists and if it's not
  /// then calls the corporate registration for passed [profile].
  ///
  /// Emits a busy state to indicate that some work is being done.
  Future<void> register(Profile profile) async {
    emit(
      state.copyWith(
        busy: true,
        error: CorporateRegistrationStateError.none,
        action: CorporateRegistrationActions.none,
      ),
    );

    try {
      // Checking if there is already registered customer.
      // If customer doesn't exist we are getting 404 error.
      await _loadCustomerByIdUseCase(
        customerId: profile.customerID,
      );
      emit(
        state.copyWith(
          busy: false,
          error: CorporateRegistrationStateError.customerRegistered,
        ),
      );
    } on Exception catch (e) {
      if (e is NetException && e.statusCode == 404) {
        await _registerCustomer(profile);
      } else {
        emit(
          state.copyWith(
            busy: false,
            error: CorporateRegistrationStateError.generic,
          ),
        );
      }
    }
  }

  Future<void> _registerCustomer(Profile profile) async {
    try {
      await _registerCorporationUseCase(
        customerId: profile.customerID,
        accountCreationDate: profile.accountCreationDate,
        name: profile.employerName,
        customerType: profile.customerType?.toCustomerDTOType() ?? '',
        managingBranch: profile.managingBranch,
        country: profile.country,
        dob: profile.dateOfBirth,
        mobileNumber: profile.mobileNumber,
        email: profile.email,
        address1: profile.address1,
        address2: profile.address2,
        nationalIdNumber: profile.nationalIdNumber,
      );
      emit(
        state.copyWith(
          busy: false,
          action: CorporateRegistrationActions.registrationComplete,
        ),
      );
    } on Exception {
      emit(
        state.copyWith(
          busy: false,
          error: CorporateRegistrationStateError.generic,
        ),
      );
    }
  }
}
