import '../../dtos.dart';
import '../../network.dart';

/// A provider that handles the API requests related to the shortcuts.
class ShortcutProvider {
  /// The net client to use.
  final NetClient netClient;

  /// Creates new [ShortcutProvider].
  ShortcutProvider({
    required this.netClient,
  });

  /// Creates a new shortcut.
  ///
  /// The data is being sent inside an array as per BE requirements.
  Future<void> submit({
    required ShortcutDTO shortcut,
  }) async {
    await netClient.request(
      netClient.netEndpoints.shortcut,
      method: NetRequestMethods.post,
      data: [shortcut.toJson()],
    );
  }
}
