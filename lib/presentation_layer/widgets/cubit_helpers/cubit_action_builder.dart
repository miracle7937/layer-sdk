import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubits.dart';
import 'cubit_helper_types.dart';

/// A helper widget for the actions on the cubits.
///
/// The set of [actions] belongs to the actions that will be monitored
/// in order to get the loading state of these actions on the [builder].
///
/// The [builder] easily allows you to access the set of actions that are
/// currently loading.
class CubitActionBuilder<LayerCubit extends Cubit<BaseState>, CubitAction>
    extends StatelessWidget {
  /// The set of actions to listen to.
  final Set<CubitAction> actions;

  /// The widget builder.
  final CubitActionWidgetBuider<CubitAction> builder;

  /// Creates a new [CubitActionBuilder].
  const CubitActionBuilder({
    Key? key,
    required this.actions,
    required this.builder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loadingActions = context.select<LayerCubit, Set<CubitAction>>(
      (cubit) => Set<CubitAction>.from(
        cubit.state.actions.where(actions.contains),
      ),
    );

    return builder(context, loadingActions);
  }
}
