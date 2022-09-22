import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubits.dart';
import 'cubit_helper_types.dart';

/// A helper widget for the events on the cubits.
///
/// The set of [events] are used for monitoring whenever any of these are
/// emitted by the cubit. You can get such event using the [onEvent] callback,
/// which exposes the cubit state and the cubit event.
class CubitEventListener<LayerCubit extends Cubit<CubitState>,
    CubitState extends BaseState, CubitEvent> extends StatelessWidget {
  /// The set of events to listen to.
  final Set<CubitEvent> events;

  /// Callback called whenever the [CubitEvent] is emitted by the [LayerCubit].
  final CubitEventCallback<CubitState, CubitEvent> onEvent;

  /// The child.
  final Widget? child;

  /// Creates a new [CubitEventListener].
  const CubitEventListener({
    Key? key,
    required this.events,
    required this.onEvent,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => MultiBlocListener(
        listeners: events
            .map(
              (event) => BlocListener<LayerCubit, CubitState>(
                listenWhen: (previous, current) {
                  final previousEvents =
                      previous.events.where((e) => e == event).toSet();
                  final currentEvents =
                      current.events.where((e) => e == event).toSet();

                  final newEvents = currentEvents.difference(previousEvents);

                  return newEvents.isNotEmpty;
                },
                listener: (context, state) {
                  final lastEvent = state.events.where((e) => e == event).last;

                  onEvent(
                    context,
                    state,
                    lastEvent,
                  );
                },
              ),
            )
            .toList(),
        child: child ?? const SizedBox.shrink(),
      );
}
