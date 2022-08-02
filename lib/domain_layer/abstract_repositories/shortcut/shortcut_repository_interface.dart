import '../../models/shortcut/new_shortcut.dart';

/// Provides the functionality to manage shortcuts.
abstract class ShortcutRepositoryInterface {
  /// Creates a new shortcut.
  Future<void> submit({
    required NewShortcut shortcut,
  });
}
