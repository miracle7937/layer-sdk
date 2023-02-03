import '../../dtos.dart';

/// The model used for adding/patching a custom
/// user preference
class CustomUserPreferenceDTO extends UserPreferenceDTO<Object> {
  ///Creates a new [CustomUserPreferenceDTO]
  CustomUserPreferenceDTO({
    required var key,
    required var value,
  }) : super(key, value);

  @override
  Map<String, dynamic> toJson() => {
        key: value,
      };
}
