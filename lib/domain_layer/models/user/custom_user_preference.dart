import '../../models.dart';

/// The model used for adding/patching a custom
/// user preference
class CustomUserPreference extends UserPreference<Object> {
  ///Creates a new [CustomUserPreference]
  CustomUserPreference({
    required var key,
    required var value,
  }) : super(key, value);

  @override
  Map<String, dynamic> toJson() => {
        key: value,
      };

  @override
  List<Object?> get props => [
        key,
        value,
      ];
}
