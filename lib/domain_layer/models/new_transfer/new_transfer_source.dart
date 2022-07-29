import 'package:equatable/equatable.dart';

import '../../models.dart';

/// The enum used for identifying the type for this [NewTransferSource].
enum NewTransferSourceType {
  /// Account.
  account,

  /// Wallet.
  wallet,

  /// Mobile.
  mobile,

  /// Provider.
  provider,

  /// Card.
  card,
}

/// A class that represents the source from a transfer.
///
/// Only one of these items should be indicated, the other ones must remain
/// null.
class NewTransferSource extends Equatable {
  /// The source account.
  final Account? account;

  /// The source wallet.
  //final Wallet? wallet;

  /// The source mobile.
  final String? mobile;

  /// The source provider.
  final String? provider;

  /// The source card.
  //final Card? card;

  /// Creates a new [NewTransferSource].
  /// TODO: Implement comented parameters.
  NewTransferSource({
    this.account,
    //this.wallet,
    this.mobile,
    this.provider,
    //this.card,
  }) : assert(
          (account != null && mobile == null && provider == null) ||
              (account == null && mobile != null && provider == null) ||
              (account == null && mobile == null && provider != null),
          'Only one source item can be indicated.',
        );

  /// Returns the type of this [NewTransferSource].
  NewTransferSourceType get type => account != null
      ? NewTransferSourceType.account
      : mobile != null
          ? NewTransferSourceType.mobile
          : NewTransferSourceType.provider;

  /// Whether if the source is empty.
  bool get isEmpty => account == null && mobile == null && provider == null;

  @override
  List<Object?> get props => [
        account,
        //wallet,
        mobile,
        provider,
        //card,
      ];
}
