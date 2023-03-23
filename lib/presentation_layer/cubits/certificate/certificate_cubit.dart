import 'package:bloc/bloc.dart';

import '../../../../../../data_layer/network.dart';
import '../../../../domain_layer/models.dart';
import '../../../domain_layer/use_cases.dart';
import '../../cubits.dart';

/// Cubit responsible for requesting customer certificates
class CertificateCubit extends Cubit<CertificateStates> {
  final RequestAccountCertificateUseCase _requestAccountCertificateUseCase;
  final RequestBankStatementUseCase _requestBankStatementUseCase;
  final RequestCertificateOfDepositUseCase _requestCertificateOfDepositUseCase;

  /// Creates a new [CertificateCubit] instance
  CertificateCubit({
    required RequestAccountCertificateUseCase requestAccountCertificateUseCase,
    required RequestBankStatementUseCase requestBankStatementUseCase,
    required RequestCertificateOfDepositUseCase
        requestCertificateOfDepositUseCase,
  })  : _requestAccountCertificateUseCase = requestAccountCertificateUseCase,
        _requestBankStatementUseCase = requestBankStatementUseCase,
        _requestCertificateOfDepositUseCase =
            requestCertificateOfDepositUseCase,
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
  Future<void> requestCertificateOfDeposit({
    FileType type = FileType.image,
  }) async {
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
      final bytes = await _requestCertificateOfDepositUseCase(
        accountId: state.account!.id!,
        customerId: state.customer!.id,
        type: type,
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
  Future<void> requestAccountCertificate({
    FileType type = FileType.image,
  }) async {
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
      final bytes = await _requestAccountCertificateUseCase(
        accountId: state.account!.id!,
        customerId: state.customer!.id,
        type: type,
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
  Future<void> requestBankStatement({
    FileType type = FileType.image,
  }) async {
    if (state.account?.id == null ||
        state.customer?.id == null ||
        state.startDate == null ||
        state.endDate == null) {
      throw ArgumentError('Required data is missing');
    }

    emit(
      state.copyWith(
        busy: true,
        action: CertificateStatesActions.none,
        fileType: type,
      ),
    );

    try {
      final bytes = await _requestBankStatementUseCase(
        accountId: state.account!.id!,
        customerId: state.customer!.id,
        fromDate: state.startDate!,
        toDate: state.endDate!,
        type: state.fileType,
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
