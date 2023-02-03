/// Base DTO class used for patching the user preferences
// `T extends Object` because it makes `T` non nullable.
abstract class UserPreferenceDTO<T extends Object> {
  ///The key for the user prefs
  String key;

  ///The value for the user prefs
  T value;

  ///Creates a new [UserPreferenceDTO]
  UserPreferenceDTO(this.key, this.value);

  ///Method for parsing this into a json format
  Map<String, dynamic> toJson();
}
