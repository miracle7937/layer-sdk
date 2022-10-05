import '../../models.dart';

///The model used for patching the low balance aler prefs
class BalanceAlertPreference extends UserPreference<Object> {
  ///Creates a new [BalanceAlertPreference]
  BalanceAlertPreference({
    required var preferenceKey,
    required var preferenceValue,
  }) : super(preferenceKey, preferenceValue);

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
