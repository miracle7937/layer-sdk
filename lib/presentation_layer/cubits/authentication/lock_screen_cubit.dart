import 'package:flutter_bloc/flutter_bloc.dart';

import '../../cubits.dart';

/// Cubit that holds the state for the [LockScreen].
class LockScreenCubit extends Cubit<LockScreenState> {
  /// Creates a new [LockScreenCubit].
  LockScreenCubit() : super(LockScreenState());
}
