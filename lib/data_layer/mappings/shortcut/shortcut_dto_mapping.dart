import '../../../domain_layer/models.dart';
import '../../dtos.dart';

/// The shortcut payload builder.
///
/// Returns the json representation of the payload based on the type.
typedef ShortcutPayloadBuilder = Map<String, dynamic> Function({
  required ShortcutType type,
  required dynamic payload,
});

/// Provides DTO mapping for shortcuts.
extension ShortcutDTOMapping on NewShortcut {
  /// Returns a [ShortcutDTO] based on this [NewShortcut].
  ShortcutDTO toDTO(ShortcutPayloadBuilder payloadBuilder) => ShortcutDTO(
        nickname: name,
        type: type.toDTO(),
        data: payloadBuilder(
          type: type,
          payload: payload,
        ),
      );
}

/// Provides DTO mapping for shortcut types.
extension ShortcutTypeDTOMapping on ShortcutType {
  /// Returns a [ShortcutTypeDTOMapping] based on this [ShortcutType].
  ShortcutTypeDTO toDTO() {
    switch (this) {
      case ShortcutType.transfer:
        return ShortcutTypeDTO.transfer;

      case ShortcutType.payment:
        return ShortcutTypeDTO.bill;

      case ShortcutType.payToMobile:
        return ShortcutTypeDTO.payToMobile;
    }
  }
}
