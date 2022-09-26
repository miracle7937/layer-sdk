import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../layer_sdk.dart';
import '../../cubits.dart';
import 'cubit_helper_types.dart';

/// A helper widget for the cubits.
///
/// It combines both the [CubitEventListener] and the [CubitActionBuilder].
class CubitActivityConsumer<
    LayerCubit extends Cubit<CubitState>,
    CubitState extends BaseState,
    CubitAction,
    CubitEvent> extends StatelessWidget {
  /// The set of actions for the builder.
  final Set<CubitAction> actions;

  /// The widget builder.
  final CubitActionWidgetBuider<CubitAction> builder;

  /// The set of events to listent to.
  final Set<CubitEvent> events;

  /// Callback called when the cubit emits an event.
  final CubitEventCallback<CubitState, CubitEvent> onEvent;

  /// Creates a new [CubitActivityConsumer].
  CubitActivityConsumer({
    Key? key,
    required this.actions,
    required this.builder,
    required this.events,
    required this.onEvent,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) =>
      CubitEventListener<LayerCubit, CubitState, CubitEvent>(
        events: events,
        onEvent: onEvent,
        child: CubitActionBuilder<LayerCubit, CubitAction>(
          actions: actions,
          builder: builder,
        ),
      );
}
