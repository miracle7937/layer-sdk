import '../../models.dart';

///The model used for patching the low balance aler prefs
class BalanceAlertPreference extends UserPreference<Object> {
  ///Creates a new [BalanceAlertPreference]
  BalanceAlertPreference({
    required double valueLowBalance,
    required String keyLowBalance,
    required bool valueAlerted,
    required String keyAlerted,
  }) : super(keyLowBalance, valueLowBalance, keyAlerted, valueAlerted);

  @override
  Map<String, dynamic> toJson() => {
        key: value,
        secondKey!: secondValue,
      };

  @override
  List<Object?> get props => [
        key,
        value,
        secondKey,
        secondValue,
      ];
}
