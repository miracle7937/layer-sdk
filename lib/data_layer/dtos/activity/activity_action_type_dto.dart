import 'package:collection/collection.dart';

import '../../helpers.dart';

class ActivityActionTypeDTO extends EnumDTO {
  static const unknown = ActivityActionTypeDTO._internal('unknown');
  static const approve = ActivityActionTypeDTO._internal('A');
  static const reject = ActivityActionTypeDTO._internal('R');
  static const delete = ActivityActionTypeDTO._internal('D');
  static const cancel = ActivityActionTypeDTO._internal('C');
  static const cancelAppointment = ActivityActionTypeDTO._internal('CA');
  static const continueProcess = ActivityActionTypeDTO._internal('N');
  static const patchTransfer = ActivityActionTypeDTO._internal('PT');
  static const cancelRecurringTransfer = ActivityActionTypeDTO._internal('DT');
  static const cancelRecurringPayment = ActivityActionTypeDTO._internal('DP');
  static const deleteAlert = ActivityActionTypeDTO._internal('DA');
  static const collectToOwn = ActivityActionTypeDTO._internal('CO');
  static const sendToBeneficiary = ActivityActionTypeDTO._internal('SB');
  static const cancelSendMoney = ActivityActionTypeDTO._internal('DS');
  static const repeatAction = ActivityActionTypeDTO._internal('REP');
  static const addToShortcut = ActivityActionTypeDTO._internal('SH');
  static const patchPayment = ActivityActionTypeDTO._internal('PP');
  static const editAppointment = ActivityActionTypeDTO._internal('EA');
  static const renewal = ActivityActionTypeDTO._internal('RN');

  static const List<ActivityActionTypeDTO> values = [
    unknown,
    approve,
    reject,
    delete,
    cancel,
    cancelAppointment,
    continueProcess,
    patchTransfer,
    cancelRecurringTransfer,
    cancelRecurringPayment,
    deleteAlert,
    collectToOwn,
    sendToBeneficiary,
    cancelSendMoney,
    repeatAction,
    addToShortcut,
    patchPayment,
    editAppointment,
    renewal,
  ];

  const ActivityActionTypeDTO._internal(String value) : super.internal(value);

  /// Creates a [ActivityActionTypeDTO] from a [String]
  static ActivityActionTypeDTO? fromRaw(String? raw) => values.firstWhereOrNull(
        (val) => val.value == raw,
      );
}
