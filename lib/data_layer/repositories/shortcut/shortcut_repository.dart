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

  /// Creates a new shortcut.
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
        if (payload is NewTransfer) {
          return payload.toNewTransferPayloadDTO().toJson();
        }

        return (payload as Transfer).toTransferShortcutPayloadDTO().toJson();

      case ShortcutType.payment:
        return (payload as Payment).toPaymentShortcutPayloadDTO().toJson();

      case ShortcutType.payToMobile:
        if (payload is NewPayToMobile) {
          return payload.toDTO().toJson();
        }

        return (payload as PayToMobile).toPayToMobileDTO().toJson();
    }
  }
}
