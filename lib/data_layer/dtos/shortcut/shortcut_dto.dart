import 'package:collection/collection.dart';

import '../../helpers.dart';

/// A data transfer object representing a shortcut.
class ShortcutDTO {
  /// The shortcut identifier.
  String? id;

  /// The identifier of the user who owns the shortcut.
  int? userId;

  /// The first name of the user who owns the shortcut.
  String? firstName;

  /// The last name of the user who owns the shortcut.
  String? lastName;

  /// The name of the shortcut.
  String? nickname;

  /// The type of the shortcut.
  ShortcutTypeDTO? type;

  /// The shortcut payload.
  Map<String, dynamic>? data;

  /// Creates new [ShortcutDTO].
  ShortcutDTO({
    this.id,
    this.userId,
    this.firstName,
    this.lastName,
    this.nickname,
    this.type,
    this.data,
  });

  /// Returns the json representation of the DTO.
  Map<String, dynamic> toJson() => {
        'shortcut_id': id,
        'a_user_id': userId,
        'nickname': nickname,
        'type': type?.value,
        'data': data,
      };
}

/// The available shortcut types
class ShortcutTypeDTO extends EnumDTO {
  /// A shortcut for bill payments.
  static const bill = ShortcutTypeDTO._internal('Bill');

  /// A shortcut for transfers.
  static const transfer = ShortcutTypeDTO._internal('Transfer');

  /// A shortcut for wallet transfers.
  static const walletTransfer = ShortcutTypeDTO._internal('WT');

  /// A shortcut for paying a merchant.
  static const paymerchant = ShortcutTypeDTO._internal('P');

  /// A shortcut for sending money.
  static const sendmoney = ShortcutTypeDTO._internal('SM');

  /// A shortcut for transfers.
  static const defaultTransfer = ShortcutTypeDTO._internal('DT');

  /// A shortcut for wallets.
  static const defaultWallet = ShortcutTypeDTO._internal('DW');

  /// A shortcut for .
  static const defaultSendmoney = ShortcutTypeDTO._internal('DS');

  /// A shortcut for topups.
  static const defaultTopup = ShortcutTypeDTO._internal('DTP');

  /// A shortcut for bills.
  static const defaultBill = ShortcutTypeDTO._internal('DB');

  /// A shortcut for benefit pay.
  static const benefitPay = ShortcutTypeDTO._internal('benefit_pay');

  /// A shortcut for benefit gateway.
  static const benefitGateway = ShortcutTypeDTO._internal('benefit_gw');

  /// A shortcut for card topup.
  static const cardTopup = ShortcutTypeDTO._internal('cardTopup');

  /// A shortcut for pay to mobile.
  static const payToMobile = ShortcutTypeDTO._internal('payToMobile');

  const ShortcutTypeDTO._internal(String value) : super.internal(value);

  /// All the available values.
  static const values = [
    bill,
    transfer,
    walletTransfer,
    paymerchant,
    sendmoney,
    defaultTransfer,
    defaultWallet,
    defaultSendmoney,
    defaultTopup,
    defaultBill,
    benefitPay,
    benefitGateway,
    cardTopup,
    payToMobile,
  ];

  /// Creates [ShortcutTypeDTO] from raw value.
  static ShortcutTypeDTO? fromRaw(String? raw) => values.firstWhereOrNull(
        (element) => element.value == raw,
      );
}
