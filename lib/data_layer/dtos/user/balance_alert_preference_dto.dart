import '../../dtos.dart';

///The model used for patching the low balance aler prefs
class BalanceAlertPreferenceDTO extends UserPreferenceDTO<Object> {
  ///Creates a new [BalanceAlertPreference]
  BalanceAlertPreferenceDTO({
    required var preferenceKey,
    required var preferenceValue,
  }) : super(preferenceKey, preferenceValue);

  @override
  Map<String, dynamic> toJson() => {
        key: value,
      };
}
