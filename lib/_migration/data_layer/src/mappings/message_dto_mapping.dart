import '../../models.dart';
import '../dtos.dart';

/// Extension that provides mappings for [MessageDTO]
extension MessageDTOMapping on MessageDTO {
  /// Maps into a [Message]
  Message toMessage() => Message(
        id: id?.toString(),
        module: module,
        message: message,
      );
}
