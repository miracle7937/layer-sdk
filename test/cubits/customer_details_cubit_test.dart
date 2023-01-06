import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:layer_sdk/features/customer.dart';
import 'package:mocktail/mocktail.dart';

class MockLoadCustomerByIdUseCase extends Mock
    implements LoadCustomerByIdUseCase {}

class MockForceCustomerUpdateUseCase extends Mock
    implements ForceCustomerUpdateUseCase {}

class MockUpdateCustomerGracePeriodUseCase extends Mock
    implements UpdateCustomerGracePeriodUseCase {}

class MockUpdateCustomerEStatementUseCase extends Mock
    implements UpdateCustomerEStatementUseCase {}

late MockLoadCustomerByIdUseCase _loadCustomerByIdUseCase;
late MockForceCustomerUpdateUseCase _forceCustomerUpdateUseCase;
late MockUpdateCustomerGracePeriodUseCase _updateCustomerGracePeriodUseCase;
late MockUpdateCustomerEStatementUseCase _updateCustomerEStatementUseCase;
late Customer _successCustomer;
late Customer _failureCustomer;
late String _successId;
late String _failureId;

CustomerDetailsCubit create({
  Customer? customer,
}) =>
    CustomerDetailsCubit(
      loadCustomerByIdUseCase: _loadCustomerByIdUseCase,
      forceCustomerUpdateUseCase: _forceCustomerUpdateUseCase,
      updateCustomerGracePeriodUseCase: _updateCustomerGracePeriodUseCase,
      updateCustomerEStatementUseCase: _updateCustomerEStatementUseCase,
      customer: customer,
    );

void main() {
  setUp(() {
    _loadCustomerByIdUseCase = MockLoadCustomerByIdUseCase();
    _forceCustomerUpdateUseCase = MockForceCustomerUpdateUseCase();
    _updateCustomerGracePeriodUseCase = MockUpdateCustomerGracePeriodUseCase();
    _updateCustomerEStatementUseCase = MockUpdateCustomerEStatementUseCase();

    _successId = 'success!';
    _failureId = 'failure!';

    _successCustomer = Customer(id: _successId);
    _failureCustomer = Customer(id: _failureId);

    when(
      () => _loadCustomerByIdUseCase(
        customerId: _successId,
        forceRefresh: true,
      ),
    ).thenAnswer(
      (_) async => _successCustomer,
    );

    when(
      () => _loadCustomerByIdUseCase(
        customerId: _failureId,
        forceRefresh: true,
      ),
    ).thenThrow(
      Exception('Some error'),
    );

    when(
      () => _forceCustomerUpdateUseCase(
        customerId: _successId,
      ),
    ).thenAnswer(
      (_) async => true,
    );

    when(
      () => _forceCustomerUpdateUseCase(
        customerId: _failureId,
      ),
    ).thenThrow(
      Exception('Some error'),
    );

    when(
      () => _updateCustomerGracePeriodUseCase(
        customerId: _successId,
        type: KYCGracePeriodType.id,
        value: any(named: 'value'),
      ),
    ).thenAnswer(
      (_) async => true,
    );

    when(
      () => _updateCustomerGracePeriodUseCase(
        customerId: _failureId,
        type: KYCGracePeriodType.id,
        value: any(named: 'value'),
      ),
    ).thenThrow(
      Exception('Something went really wrong...'),
    );

    when(
      () => _updateCustomerEStatementUseCase(
        customerId: _successId,
        value: any(named: 'value'),
      ),
    ).thenAnswer(
      (_) async => true,
    );

    when(
      () => _updateCustomerEStatementUseCase(
        customerId: _failureId,
        value: any(named: 'value'),
      ),
    ).thenThrow(
      Exception('Something went really wrong...'),
    );
  });

  blocTest<CustomerDetailsCubit, CustomerDetailsState>(
    'Starts with empty state',
    build: create,
    verify: (c) => [
      expect(c.state, CustomerDetailsState()),
    ],
  );

  blocTest<CustomerDetailsCubit, CustomerDetailsState>(
    'Keeps preloaded customer',
    build: () => create(
      customer: _successCustomer,
    ),
    verify: (c) => [
      expect(c.state, CustomerDetailsState(customer: _successCustomer)),
    ],
  );

  blocTest<CustomerDetailsCubit, CustomerDetailsState>(
    'Loads customer successfully',
    build: create,
    act: (c) => c.load(
      customerId: _successId,
    ),
    expect: () => [
      CustomerDetailsState(
        actions: {
          CustomerDetailsAction.load,
        },
      ),
      CustomerDetailsState(
        customer: _successCustomer,
      ),
    ],
  );

  blocTest<CustomerDetailsCubit, CustomerDetailsState>(
    'Handles exceptions gracefully when loading',
    build: create,
    act: (c) => c.load(
      customerId: _failureId,
    ),
    expect: () => [
      CustomerDetailsState(
        actions: {
          CustomerDetailsAction.load,
        },
      ),
      CustomerDetailsState(
        error: CustomerDetailsError.loadFailed,
      ),
    ],
    errors: () => [
      isA<Exception>(),
    ],
  );

  blocTest<CustomerDetailsCubit, CustomerDetailsState>(
    'Force updates successfully',
    build: create,
    act: (c) => c.forceUpdate(),
    seed: () => CustomerDetailsState(customer: _successCustomer),
    expect: () => [
      CustomerDetailsState(
        customer: _successCustomer,
        actions: {
          CustomerDetailsAction.forceUpdate,
        },
      ),
      CustomerDetailsState(
        customer: _successCustomer,
      ),
      CustomerDetailsState(
        customer: _successCustomer,
        actions: {
          CustomerDetailsAction.load,
        },
      ),
      CustomerDetailsState(
        customer: _successCustomer,
      ),
    ],
  );

  blocTest<CustomerDetailsCubit, CustomerDetailsState>(
    'Handles exceptions gracefully when forcing update',
    build: create,
    act: (c) => c.forceUpdate(),
    seed: () => CustomerDetailsState(
      customer: _failureCustomer,
    ),
    expect: () => [
      CustomerDetailsState(
        customer: _failureCustomer,
        actions: {
          CustomerDetailsAction.forceUpdate,
        },
      ),
      CustomerDetailsState(
        customer: _failureCustomer,
        error: CustomerDetailsError.forceUpdateFailed,
      ),
    ],
    errors: () => [
      isA<Exception>(),
    ],
  );

  blocTest<CustomerDetailsCubit, CustomerDetailsState>(
    'Updates customer grace period successfully',
    build: create,
    act: (c) => c.updateCustomerGracePeriod(
      type: KYCGracePeriodType.id,
      value: 5,
    ),
    seed: () => CustomerDetailsState(customer: _successCustomer),
    expect: () => [
      CustomerDetailsState(
        customer: _successCustomer,
        actions: {
          CustomerDetailsAction.updatingCustomerGracePeriod,
        },
      ),
      CustomerDetailsState(
        customer: _successCustomer,
      ),
    ],
  );

  blocTest<CustomerDetailsCubit, CustomerDetailsState>(
    'Handles exception gracefully when updating customer grace period',
    build: create,
    act: (c) => c.updateCustomerGracePeriod(
      type: KYCGracePeriodType.id,
      value: 5,
    ),
    seed: () => CustomerDetailsState(customer: _failureCustomer),
    expect: () => [
      CustomerDetailsState(
        customer: _failureCustomer,
        actions: {
          CustomerDetailsAction.updatingCustomerGracePeriod,
        },
      ),
      CustomerDetailsState(
        customer: _failureCustomer,
        error: CustomerDetailsError.updatingCustomerGracePeriodFailed,
      ),
    ],
  );

  blocTest<CustomerDetailsCubit, CustomerDetailsState>(
    'Updates customer E Statement successfully',
    build: create,
    act: (c) => c.updateCustomerEStatement(
      value: true,
    ),
    seed: () => CustomerDetailsState(customer: _successCustomer),
    expect: () => [
      CustomerDetailsState(
        customer: _successCustomer,
        actions: {
          CustomerDetailsAction.updatingCustomerEStatement,
        },
      ),
      CustomerDetailsState(
        customer: _successCustomer,
      ),
    ],
  );

  blocTest<CustomerDetailsCubit, CustomerDetailsState>(
    'Handles exception gracefully when updating customer E Statement',
    build: create,
    act: (c) => c.updateCustomerEStatement(
      value: true,
    ),
    seed: () => CustomerDetailsState(customer: _failureCustomer),
    expect: () => [
      CustomerDetailsState(
        customer: _failureCustomer,
        actions: {
          CustomerDetailsAction.updatingCustomerEStatement,
        },
      ),
      CustomerDetailsState(
        customer: _failureCustomer,
        error: CustomerDetailsError.updatingCustomerEStatementFailed,
      ),
    ],
  );
}
