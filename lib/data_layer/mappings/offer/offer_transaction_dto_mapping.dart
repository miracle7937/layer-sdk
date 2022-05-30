import '../../../domain_layer/models.dart';
import '../../dtos.dart';
import '../../errors.dart';

/// An extension that provides mapping for [OfferTransactionDTO].
extension OfferTransactionDTOMapping on OfferTransactionDTO {
  /// Returns [OfferTransaction] created from this [OfferTransactionDTO].
  OfferTransaction toOfferTransaction() {
    if ([
      created,
      transactionAmount,
      rewardAmount,
      currency,
    ].contains(null)) {
      throw MappingException(
        from: OfferTransactionDTO,
        to: OfferTransaction,
        value: this,
        details: 'One of the required parameters is null',
      );
    }
    return OfferTransaction(
      description: description,
      date: created!,
      transactionAmount: transactionAmount!,
      rewardAmount: rewardAmount!,
      currency: currency!,
    );
  }
}
