import 'package:equatable/equatable.dart';

///An abstract class used for patching the user preferences
// `T extends Object` because it makes `T` non nullable.
abstract class UserPreference<T extends Object> extends Equatable {
  ///The key for the user prefs
  final String key;

  ///The value for the user prefs
  final T value;

  ///Creates a new [UserPreference]
  UserPreference(this.key, this.value);
}
