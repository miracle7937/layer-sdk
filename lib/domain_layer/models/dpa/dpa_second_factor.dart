import 'dpa_variable.dart';

/// DPA Second Factor
class DPASecondFactor {
  /// Type of second factor (PIN, HW Token, OTP)
  String type;

  static const _validTypes = ['pin', 'hw_token', 'otp'];

  /// Creates a new [DPASecondFactor]
  DPASecondFactor({required this.type});

  /// Creates a new [DPASecondFactor] from a list of [DPAVariable]
  factory DPASecondFactor.fromVariables(List<DPAVariable> variables) {
    if (variables.isEmpty) {
      return DPASecondFactor(type: '');
    }
    final sortedList = variables..sort((a, b) => a.order!.compareTo(b.order!));
    var type = '';
    type = sortedList[0].key;
    for (var i = 1; i < sortedList.length; i++) {
      final item = sortedList[i];
      if (_validTypes.contains(item.key.toLowerCase())) {
        type += '${item.constraints.required ? '+' : ','}${item.key}';
      }
    }

    return DPASecondFactor(type: type.toUpperCase());
  }
}
