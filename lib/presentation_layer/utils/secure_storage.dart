import '../../data_layer/interfaces.dart';
import 'platform/secure_storage_mobile.dart'
    if (dart.library.html) 'platform/secure_storage_web.dart';

/// Wrapper over the platform-specific secure storages.
///
/// It selects the correct secure storage based on the platform.
///
/// If your app does not need any secure storage, please use [NoStorage] that is
/// a dummy class that only logs accesses to the storage.
abstract class SecureStorage implements GenericStorage {
  /// Creates a new [SecureStorage] based on the current platform.
  factory SecureStorage() => PlatformSecureStorage();
}
