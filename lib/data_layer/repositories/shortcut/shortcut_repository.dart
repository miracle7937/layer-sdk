import '../../../domain_layer/abstract_repositories.dart';
import '../../../domain_layer/models.dart';
import '../../mappings.dart';
import '../../providers.dart';

/// Provides the functionality to manage shortcuts.
class ShortcutRepository extends ShortcutRepositoryInterface {
  final ShortcutProvider _provider;

  /// Creates new [ShortcutRepository].
  ShortcutRepository({
    required ShortcutProvider provider,
  }) : _provider = provider;

  @override
  Future<void> submit({
    required NewShortcut shortcut,
  }) {
    return _provider.submit(
      shortcut: shortcut.toDTO(_payloadBuilder),
    );
  }

  /// Maps the dynamic payload to json based on the provided type.
  ///
  /// Any new shortcut types need to be handled here.
  Map<String, dynamic> _payloadBuilder({
    required ShortcutType type,
    required dynamic payload,
  }) {
    switch (type) {
      case ShortcutType.transfer:
        // TODO: Map into a transfer dto and call `toJson()` on it
        // return (payload as NewTransfer).toNewTransferPayloadDTO().toJson();
        throw UnimplementedError();
      case ShortcutType.payment:
        // TODO: Map into a payment dto and call `toJson()` on it
        throw UnimplementedError();
    }
  }
}
