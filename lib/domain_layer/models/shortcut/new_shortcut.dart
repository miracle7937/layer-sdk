import 'package:equatable/equatable.dart';

/// The available shortcut types
enum ShortcutType {
  /// The shortcut for making a transfer.
  transfer,

  /// The shortcut for making a payment.
  payment,

  /// The shortcut for making a pay to mobile.
  payToMobile,
}

/// A model representing a new shortcut data.
///
/// This class should be extended to provide the shortcut payload object.
class NewShortcut extends Equatable {
  /// The name of the shortcut.
  final String name;

  /// The type of the shortcut.
  final ShortcutType type;

  /// The shortcut payload.
  ///
  /// This should be a model depending on the [type].
  final Equatable payload;

  /// Creates new [NewShortcut].
  const NewShortcut({
    required this.name,
    required this.type,
    required this.payload,
  });

  @override
  List<Object> get props => [
        name,
        type,
        payload,
      ];
}
