import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubits.dart';
import 'cubit_helper_types.dart';

/// A helper widget for the actions on the cubits.
///
/// The set of [validationErrorCodes] belongs to the validation error codes
/// that will be monitored.
///
/// The [builder] easily allows you to access the current set of validation
/// error codes emitted by the cubit.
class CubitValidationErrorBuilder<LayerCubit extends Cubit<BaseState>,
    CubitValidationErrorCode> extends StatelessWidget {
  /// The set of validation error codes to listen to.
  final Set<CubitValidationErrorCode> validationErrorCodes;

  /// The widget builder.
  final CubitValidationErrorWidgetBuider<CubitValidationErrorCode> builder;

  /// Creates a new [CubitValidationErrorBuilder].
  const CubitValidationErrorBuilder({
    Key? key,
    required this.validationErrorCodes,
    required this.builder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentValidationErrorCodes =
        context.select<LayerCubit, Set<CubitValidationErrorCode>>(
      (cubit) => cubit.state.errors
          .whereType<CubitValidationError<CubitValidationErrorCode>>()
          .where((error) =>
              validationErrorCodes.contains(error.validationErrorCode))
          .map((e) => e.validationErrorCode)
          .toSet(),
    );

    return builder(context, currentValidationErrorCodes);
  }
}
