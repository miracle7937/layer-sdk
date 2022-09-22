import 'package:equatable/equatable.dart';

import '../../models.dart';

/// The enum used for identifying the type for this [NewTransferDestination].
enum NewTransferDestinationType {
  /// Account.
  account,

  /// Beneficiary.
  beneficiary,

  /// Mobile.
  mobile,

  /// Provider.
  provider,

  /// Card.
  card,
}

/// A class that represents the destination from a transfer.
///
/// Only one of these items should be indicated, the other ones must remain
/// null.
class NewTransferDestination extends Equatable {
  /// The source account.
  final Account? account;

  /// The source wallet.
  final Beneficiary? beneficiary;

  /// The source mobile.
  final String? mobile;

  /// The source provider.
  final String? provider;

  /// The source card.
  //final Card? card;

  /// Creates a new [NewTransferDestination].
  /// TODO: Implement comented parameters.
  const NewTransferDestination({
    this.account,
    this.beneficiary,
    this.mobile,
    this.provider,
    //this.card,
  }) : assert(
          (account != null &&
                  beneficiary == null &&
                  mobile == null &&
                  provider == null) ||
              (account == null &&
                  beneficiary != null &&
                  mobile == null &&
                  provider == null) ||
              (account == null &&
                  beneficiary == null &&
                  mobile != null &&
                  provider == null) ||
              (account == null &&
                  beneficiary == null &&
                  mobile == null &&
                  provider != null),
          'Only one destination item can be indicated.',
        );

  /// Returns the type of this [NewTransferDestination].
  NewTransferDestinationType get type => account != null
      ? NewTransferDestinationType.account
      : beneficiary != null
          ? NewTransferDestinationType.beneficiary
          : mobile != null
              ? NewTransferDestinationType.mobile
              : NewTransferDestinationType.provider;

  /// Whether if the destination is empty.
  bool get isEmpty =>
      account == null &&
      beneficiary == null &&
      mobile == null &&
      provider == null;

  @override
  List<Object?> get props => [
        account,
        beneficiary,
        mobile,
        provider,
        //card,
      ];
}
