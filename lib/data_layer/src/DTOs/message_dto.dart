/// Global message
class MessageDTO {
  /// Message id
  String? id;

  /// Message module
  String? module;

  /// Message's message
  String? message;

  /// Creates a new [MessageDTO]
  MessageDTO({
    this.id,
    this.module,
    this.message,
  });

  /// Creates a [Message] from a JSON
  factory MessageDTO.fromJson(Map<String, dynamic> json) {
    return MessageDTO(
      id: json['string_id'],
      module: json['module'],
      message: json['string_local'],
    );
  }

  /// Creates a list of [Message] from a JSON list
  static List<MessageDTO> fromJsonList(List<Map<String, dynamic>> json) =>
      json.map(MessageDTO.fromJson).toList();
}
