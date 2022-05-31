import 'package:bloc/bloc.dart';

import '../../../../../../data_layer/network.dart';
import '../../../../domain_layer/models.dart';
import '../../../data_layer/data_layer.dart';
import 'certificate_states.dart';

/// Cubit responsible for requesting customer certificates
class CertificateCubit extends Cubit<CertificateStates> {
  final CertificateRepository _repository;

  /// Creates a new [CertificateCubit] instance
  CertificateCubit({
    required CertificateRepository repository,
  })  : _repository = repository,
        super(CertificateStates());

  /// Sets the customer to be used by the request
  void setCustomer(Customer? customer) {
    emit(
      state.copyWith(customer: customer),
    );
  }

  /// Sets the customer account to be used by the request
  void setAccount(Account? account) {
    emit(
      state.copyWith(account: account),
    );
  }

  /// Sets the date range for the desired certificate
  void setDateRange({
    DateTime? startDate,
    DateTime? endDate,
  }) =>
      emit(
        state.copyWith(
          startDate: startDate,
          endDate: endDate,
        ),
      );

  /// Requests a new certificate of deposit
  /// Emits the file list of bytes when done
  Future<void> requestCertificateOfDeposit() async {
    if (state.account?.id == null || state.customer?.id == null) {
      throw ArgumentError('Account and customer ids are required');
    }

    emit(
      state.copyWith(
        busy: true,
        action: CertificateStatesActions.none,
      ),
    );

    try {
      final bytes = await _repository.requestCertificateOfDeposit(
        accountId: state.account!.id!,
        customerId: state.customer!.id,
      );

      emit(
        state.copyWith(
          busy: false,
          certificateBytes: bytes,
          action: CertificateStatesActions.certificateRequestedSuccessfully,
        ),
      );
    } on Exception {
      emit(
        state.copyWith(
          busy: false,
          action: CertificateStatesActions.certificateRequestFailed,
        ),
      );
    }
  }

  /// Requests a new account certificate
  /// Emits the file list of bytes when done
  Future<void> requestAccountCertificate() async {
    if (state.account?.id == null || state.customer?.id == null) {
      throw ArgumentError('Account and customer ids are required');
    }

    emit(
      state.copyWith(
        busy: true,
        action: CertificateStatesActions.none,
      ),
    );

    try {
      final bytes = await _repository.requestAccountCertificate(
        accountId: state.account!.id!,
        customerId: state.customer!.id,
      );

      emit(
        state.copyWith(
          busy: false,
          certificateBytes: bytes,
          action: CertificateStatesActions.certificateRequestedSuccessfully,
        ),
      );
    } on Exception {
      emit(
        state.copyWith(
          busy: false,
          action: CertificateStatesActions.certificateRequestFailed,
        ),
      );
    }
  }

  /// Requests a new bank statement
  /// Emits the file list of bytes when done
  Future<void> requestBankStatement() async {
    if (state.account?.id == null ||
        state.customer?.id == null ||
        state.startDate == null ||
        state.endDate == null) {
      throw ArgumentError('Required data is missing');
    }

    emit(
      state.copyWith(busy: true, action: CertificateStatesActions.none),
    );

    try {
      final bytes = await _repository.requestBankStatement(
        accountId: state.account!.id!,
        customerId: state.customer!.id,
        fromDate: state.startDate!,
        toDate: state.endDate!,
      );
      emit(
        state.copyWith(
          busy: false,
          certificateBytes: bytes,
          action: CertificateStatesActions.certificateRequestedSuccessfully,
        ),
      );
    } on Exception catch (e) {
      emit(
        state.copyWith(
          busy: false,
          action: e is NetException && e.statusCode == 404
              ? CertificateStatesActions.noTransactionsFound
              : CertificateStatesActions.certificateRequestFailed,
        ),
      );
    }
  }

  /// Clears the state of the cubit
  void clear() {
    emit(CertificateStates());
  }
}
