import 'package:collection/collection.dart';

import '../../helpers.dart';

/// The different activity action types
class ActivityActionTypeDTO extends EnumDTO {
  /// activity action type is unknown
  static const unknown = ActivityActionTypeDTO._internal('unknown');

  /// activity action type is approve
  static const approve = ActivityActionTypeDTO._internal('A');

  /// activity action type is reject
  static const reject = ActivityActionTypeDTO._internal('R');

  /// activity action type is delete
  static const delete = ActivityActionTypeDTO._internal('D');

  /// activity action type is cancel
  static const cancel = ActivityActionTypeDTO._internal('C');

  /// activity action type is Cancel Appointment
  static const cancelAppointment = ActivityActionTypeDTO._internal('CA');

  /// activity action type is Continue Process
  static const continueProcess = ActivityActionTypeDTO._internal('N');

  /// activity action type is Patch Transfer
  static const patchTransfer = ActivityActionTypeDTO._internal('PT');

  /// activity action type is Cancel Recurring Transfer
  static const cancelRecurringTransfer = ActivityActionTypeDTO._internal('DT');

  /// activity action type is Cancel Recurring Payment
  static const cancelRecurringPayment = ActivityActionTypeDTO._internal('DP');

  /// activity action type is Delete Alert
  static const deleteAlert = ActivityActionTypeDTO._internal('DA');

  /// activity action type is Collect To Own
  static const collectToOwn = ActivityActionTypeDTO._internal('CO');

  /// activity action type is Send To Beneficiary
  static const sendToBeneficiary = ActivityActionTypeDTO._internal('SB');

  /// activity action type is Cancel Send Money
  static const cancelSendMoney = ActivityActionTypeDTO._internal('DS');

  /// activity action type is Repeat Action
  static const repeatAction = ActivityActionTypeDTO._internal('REP');

  /// activity action type is Add To Shortcut
  static const addToShortcut = ActivityActionTypeDTO._internal('SH');

  /// activity action type is Patch Payment
  static const patchPayment = ActivityActionTypeDTO._internal('PP');

  /// activity action type is Edit Appointment
  static const editAppointment = ActivityActionTypeDTO._internal('EA');

  /// activity action type is renewal
  static const renewal = ActivityActionTypeDTO._internal('RN');

  /// All possible activity action type values
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
