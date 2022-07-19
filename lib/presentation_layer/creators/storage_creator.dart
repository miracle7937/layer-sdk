import '../../_migration/business_layer/src/cubits.dart';
import '../../data_layer/interfaces.dart';
import '../widgets.dart';

/// A creator responsible for creating the [StorageCubit].
class StorageCreator implements CubitCreator {
  /// The storage solution used to store the user preferences.
  final GenericStorage preferencesStorage;

  /// The storage solution used to store sensitive data.
  final GenericStorage secureStorage;

  /// Creates [StorageCreator].
  StorageCreator({
    required this.preferencesStorage,
    required this.secureStorage,
  });

  /// Creates the [StorageCubit].
  StorageCubit create() => StorageCubit(
        preferencesStorage: preferencesStorage,
        secureStorage: secureStorage,
      );
}
