import 'package:equatable/equatable.dart';

/// A simple response object that returns if the request was a success and
/// a message in case of no success.
class MessageResponse extends Equatable {
  /// If the request was a success.
  final bool success;

  /// The message returned from the backend that can be shown to the user.
  final String message;

  /// Creates a new [MessageResponse].
  const MessageResponse({
    required this.success,
    this.message = '',
  });

  @override
  List<Object?> get props => [
        success,
        message,
      ];
}
