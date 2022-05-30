import 'package:collection/collection.dart';

import '../../helpers.dart';

/// The different transfer types
class TransferTypeDTO extends EnumDTO {
  /// transfer type is own
  static const own = TransferTypeDTO._internal('O');

  /// transfer type is within bank
  static const bank = TransferTypeDTO._internal('B');

  /// transfer type is domestic
  static const domestic = TransferTypeDTO._internal('D');

  /// transfer type is international
  static const international = TransferTypeDTO._internal('I');

  /// transfer type is bulk
  static const bulk = TransferTypeDTO._internal('K');

  /// transfer type is instant (card to card transfer)
  static const instant = TransferTypeDTO._internal('Q');

  /// transfer type is cash in
  static const cashin = TransferTypeDTO._internal('N');

  /// transfer type is cash out
  static const cashout = TransferTypeDTO._internal('U');

  /// transfer type is mobile to beneficiary
  static const mobileToBeneficiary = TransferTypeDTO._internal('M');

  /// transfer type is merchant transfer
  static const merchantTransfer = TransferTypeDTO._internal('T');

  /// All possible transfer type values
  static const List<TransferTypeDTO> values = [
    own,
    bank,
    domestic,
    international,
    bulk,
    instant,
    cashin,
    cashout,
    mobileToBeneficiary,
    merchantTransfer,
  ];

  const TransferTypeDTO._internal(String value) : super.internal(value);

  /// Creates a [TransferTypeDTO] from a [String]
  static TransferTypeDTO? fromRaw(String? raw) => values.firstWhereOrNull(
        (val) => val.value == raw,
      );
}
