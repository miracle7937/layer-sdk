import 'package:collection/collection.dart';

import '../../helpers.dart';

///Data transfer object representing the share type of a transfer
class ShareTypeDTO extends EnumDTO {
  ///Share type is our
  static const our = ShareTypeDTO._internal('O');

  ///Share type is beneficiary
  static const beneficiary = ShareTypeDTO._internal('B');

  ///Share type is shared
  static const shared = ShareTypeDTO._internal('S');

  ///All possible share types
  static const List<ShareTypeDTO> values = [our, beneficiary, shared];

  const ShareTypeDTO._internal(String value) : super.internal(value);

  /// Creates a [ShareTypeDTO] from a [String]
  static ShareTypeDTO? fromRaw(String? raw) => values.firstWhereOrNull(
        (val) => val.value == raw,
      );
}
