import '../../models.dart';

///The model used for patching the low balance aler prefs
class BalanceAlertPreference extends UserPreference<double> {
  ///Creates a new [BalanceAlertPreference]
  BalanceAlertPreference({
    required double value,
  }) : super('pref_lowbal', value);

  @override
  Map<String, dynamic> toJson() => {
        'pref_lowbal': value,
      };

  @override
  List<Object?> get props => [
        value,
      ];
}
