import 'dart:typed_data';

import '../../abstract_repositories.dart';

/// Use case for fetching rendered payment receipt
class LoadPaymentReceiptUseCase {
  final PaymentsRepositoryInterface _repository;

  /// Creates a new [LoadPaymentReceiptUseCase]
  LoadPaymentReceiptUseCase({
    required PaymentsRepositoryInterface repository,
  }) : _repository = repository;

  /// Callable that fetches the file
  Future<Uint8List> call({
    required int paymentID,
  }) {
    return _repository.fetchRenderedFile(paymentID: paymentID);
  }
}
