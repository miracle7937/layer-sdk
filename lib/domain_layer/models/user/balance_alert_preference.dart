import '../../models.dart';

///The model used for patching the low balance aler prefs
class BalanceAlertPreference extends UserPreference<double> {
  ///Creates a new [BalanceAlertPreference]
  BalanceAlertPreference({
    required double value,
    required String key,
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
