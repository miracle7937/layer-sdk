import 'package:flutter/material.dart';

import '../../cubits.dart';

/// Custom widget builder for the [CubitAction]s.
///
/// Exposes the context and the set of actions that are
/// currently loading.
typedef CubitActionWidgetBuider<CubitAction> = Widget Function(
  BuildContext context,
  Set<CubitAction> loadingActions,
);

/// Custom callback for the [CubitEvent]s.
///
/// Exposes the context, the event that was emitted and the state at that time.
typedef CubitEventCallback<CubitState extends BaseState, CubitEvent> = void
    Function(
  BuildContext context,
  CubitState state,
  CubitEvent event,
);

/// Custom widget builder for the [CubitValidationErrorCode]s.
///
/// Exposes the context and the current set of validation error codese that
/// where emitted by the cubit.
typedef CubitValidationErrorWidgetBuider<CubitValidationErrorCode> = Widget
    Function(
  BuildContext context,
  Set<CubitValidationErrorCode> validationErrorCodes,
);
