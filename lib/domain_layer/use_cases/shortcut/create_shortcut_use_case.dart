import '../../abstract_repositories.dart';
import '../../models/shortcut/new_shortcut.dart';

/// Use case responsible for creating a new shortcut.
class CreateShortcutUseCase {
  /// The repository to be used.
  final ShortcutRepositoryInterface _shortcutRepository;

  /// Creates the [CreateShortcutUseCase].
  CreateShortcutUseCase({
    required ShortcutRepositoryInterface shortcutRepository,
  }) : _shortcutRepository = shortcutRepository;

  /// Creates the provided shortcut.
  Future<void> call({
    required NewShortcut shortcut,
  }) =>
      _shortcutRepository.submit(
        shortcut: shortcut,
      );
}
