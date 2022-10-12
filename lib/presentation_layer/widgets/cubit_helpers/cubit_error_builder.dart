import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubits.dart';
import 'cubit_helper_types.dart';

/// A helper widget for the errors on the cubits.
///
/// The set of [errors] belongs to the errors that will be monitored
/// in order to get the errors the will be emitted on the [builder].
///
/// The [builder] easily allows you to access the set of errors that are
/// were recently emitted.
class CubitErrorBuilder<LayerCubit extends Cubit<BaseState>>
    extends StatelessWidget {
  /// The widget builder.
  final CubitErrorWidgetBuilder builder;

  /// Creates a new [CubitErrorBuilder].
  const CubitErrorBuilder({
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    final cubitErrors = context.select<LayerCubit, Set<CubitError>>(
      (cubit) => Set<CubitError>.from(cubit.state.errors),
    );

    return builder(context, cubitErrors);
  }
}
