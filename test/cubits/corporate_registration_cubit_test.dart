import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:layer_sdk/data_layer/network.dart';
import 'package:layer_sdk/domain_layer/models.dart';
import 'package:layer_sdk/domain_layer/use_cases.dart';
import 'package:layer_sdk/presentation_layer/cubits.dart';
import 'package:mocktail/mocktail.dart';

class MockRegisterCorporationUseCase extends Mock
    implements RegisterCorporationUseCase {}

class MockLoadCustomerByIdUseCase extends Mock
    implements LoadCustomerByIdUseCase {}

final _registerCorporationUseCase = MockRegisterCorporationUseCase();
final _loadCustomerByIdUseCase = MockLoadCustomerByIdUseCase();

final _successId = '1';
final _name = 'name';
final _branch = 'branch';
final _existingId = '2';
final _customerFailureId = '3';
final _registrationFailureId = '4';

final _nonExistingIdException = NetException(statusCode: 404);
final _generalException = NetException(message: 'Some error message');

final _mockProfile = Profile(
  customerID: _successId,
  employerName: _name,
  managingBranch: _branch,
  firstName: 'Mock',
  lastName: 'Profile',
);

final _mockCustomerFailureProfile = Profile(
  customerID: _customerFailureId,
  employerName: _name,
  managingBranch: _branch,
  firstName: 'Mock',
  lastName: 'Profile',
);

final _mockRegistrationFailureProfile = Profile(
  customerID: _registrationFailureId,
  employerName: _name,
  managingBranch: _branch,
  firstName: 'Mock',
  lastName: 'Profile',
);

final _mockExistingCorporateCustomerProfile = Profile(
  customerID: _existingId,
  employerName: _name,
  managingBranch: _branch,
  firstName: 'Mock',
  lastName: 'Profile',
);

final _mockCustomer = Customer(
  id: '123',
  firstName: 'Mock',
  lastName: 'User',
);

final _successResponseId = '1';

final _mockResponse = [
  QueueRequest(
    id: _successResponseId,
  )
];

void main() {
  setUpAll(() {
    when(
      () => _loadCustomerByIdUseCase(customerId: _successId),
    ).thenThrow(_nonExistingIdException);

    when(
      () => _loadCustomerByIdUseCase(customerId: _registrationFailureId),
    ).thenThrow(_nonExistingIdException);

    when(
      () => _loadCustomerByIdUseCase(customerId: _existingId),
    ).thenAnswer(
      (_) async => _mockCustomer,
    );

    when(
      () {
        return _registerCorporationUseCase(
          customerId: _successId,
          name: _name,
          managingBranch: _branch,
        );
      },
    ).thenAnswer(
      (_) async => _mockResponse,
    );

    when(
      () => _loadCustomerByIdUseCase(
        customerId: _customerFailureId,
      ),
    ).thenThrow(_generalException);

    when(
      () => _registerCorporationUseCase(
        customerId: _registrationFailureId,
        name: _name,
        managingBranch: _branch,
      ),
    ).thenThrow(_generalException);
  });

  blocTest<CorporateRegistrationCubit, CorporateRegistrationState>(
    'Starts with empty state',
    build: () => CorporateRegistrationCubit(
      registerCorporationUseCase: _registerCorporationUseCase,
      loadCustomerByIdUseCase: _loadCustomerByIdUseCase,
    ),
    expect: () => [],
  );

  blocTest<CorporateRegistrationCubit, CorporateRegistrationState>(
    'Registering when corporate customer is already exist',
    build: () => CorporateRegistrationCubit(
      loadCustomerByIdUseCase: _loadCustomerByIdUseCase,
      registerCorporationUseCase: _registerCorporationUseCase,
    ),
    act: (cubit) => cubit.register(_mockExistingCorporateCustomerProfile),
    expect: () => [
      CorporateRegistrationState(
        busy: true,
        error: CorporateRegistrationStateError.none,
      ),
      CorporateRegistrationState(
        busy: false,
        error: CorporateRegistrationStateError.customerRegistered,
      ),
    ],
    verify: (_) => verify(
      () => _loadCustomerByIdUseCase(
        customerId: _existingId,
      ),
    ).called(1),
  );

  blocTest<CorporateRegistrationCubit, CorporateRegistrationState>(
    'Register new corporate customer',
    build: () => CorporateRegistrationCubit(
      loadCustomerByIdUseCase: _loadCustomerByIdUseCase,
      registerCorporationUseCase: _registerCorporationUseCase,
    ),
    act: (cubit) => cubit.register(_mockProfile),
    expect: () => [
      CorporateRegistrationState(
        busy: true,
        error: CorporateRegistrationStateError.none,
      ),
      CorporateRegistrationState(
        busy: false,
        error: CorporateRegistrationStateError.none,
        action: CorporateRegistrationActions.registrationComplete,
      ),
    ],
    verify: (_) => verifyInOrder(
      [
        () => _loadCustomerByIdUseCase(customerId: _successId),
        () => _registerCorporationUseCase(
              customerId: _successId,
              name: _name,
              managingBranch: _branch,
            ),
      ],
    ),
  );

  blocTest<CorporateRegistrationCubit, CorporateRegistrationState>(
    'Register new corporate customer '
    'with failure while checking customer existence',
    build: () => CorporateRegistrationCubit(
      loadCustomerByIdUseCase: _loadCustomerByIdUseCase,
      registerCorporationUseCase: _registerCorporationUseCase,
    ),
    act: (cubit) => cubit.register(_mockCustomerFailureProfile),
    expect: () => [
      CorporateRegistrationState(
        busy: true,
        error: CorporateRegistrationStateError.none,
      ),
      CorporateRegistrationState(
        busy: false,
        error: CorporateRegistrationStateError.generic,
      ),
    ],
    verify: (_) => verify(
      () => _loadCustomerByIdUseCase(customerId: _customerFailureId),
    ).called(1),
  );

  blocTest<CorporateRegistrationCubit, CorporateRegistrationState>(
    'Register new corporate customer with failure while registration',
    build: () => CorporateRegistrationCubit(
      loadCustomerByIdUseCase: _loadCustomerByIdUseCase,
      registerCorporationUseCase: _registerCorporationUseCase,
    ),
    act: (cubit) => cubit.register(_mockRegistrationFailureProfile),
    expect: () => [
      CorporateRegistrationState(
        busy: true,
        error: CorporateRegistrationStateError.none,
      ),
      CorporateRegistrationState(
        busy: false,
        error: CorporateRegistrationStateError.generic,
      ),
    ],
    verify: (_) => verifyInOrder(
      [
        () => _loadCustomerByIdUseCase(
              customerId: _registrationFailureId,
            ),
        () => _registerCorporationUseCase(
              customerId: _registrationFailureId,
              name: _name,
              managingBranch: _branch,
            ),
      ],
    ),
  );
}
