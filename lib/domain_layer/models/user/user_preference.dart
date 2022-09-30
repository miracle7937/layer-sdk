import 'package:equatable/equatable.dart';

///An abstract class used for patching the user preferences
// `T extends Object` because it makes `T` non nullable.
abstract class UserPreference<T extends Object> extends Equatable {
  ///The key for the user prefs
  final String key;

  ///The second key for the user prefs
  final String? secondKey;

  ///The value for the user prefs
  final T value;

  ///The second value for the user prefs
  final T? secondValue;

  ///Creates a new [UserPreference]
  UserPreference(this.key, this.value, this.secondKey, this.secondValue);

  ///Method for parsing this into a json format
  Map<String, dynamic> toJson();
}
