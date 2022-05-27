import 'package:flutter_bloc/flutter_bloc.dart';

import '../../utils.dart';

/// Observes unhandled cubit errors and redirects them to an [ErrorConcentrator]
class CubitConcentratedErrorObserver extends BlocObserver {
  /// Where to send the errors to.
  final ErrorConcentrator errorConcentrator;

  /// Creates a new [CubitConcentratedErrorObserver].
  CubitConcentratedErrorObserver({
    required this.errorConcentrator,
  });

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    errorConcentrator.onError(
      error,
      source: ErrorSource.cubit,
      stackTrace: stackTrace,
    );

    super.onError(bloc, error, stackTrace);
  }
}
