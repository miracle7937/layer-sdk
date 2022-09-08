import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../layer_sdk.dart';
import '../cubits.dart';

///
mixin UserInactiveErrorMixin {
  ///
  Future<bool> presentUserInactiveError(
    BuildContext context,
    String? message,
  ) async {
    await BottomSheetHelper.showConfirmation(
      context: context,
      titleKey: 'device_deactivated',
      descriptionKey: 'device_inactive_default_error',
      type: BottomSheetType.warning,
      showDenyButton: false,
      enableDrag: false,
      isDismissible: false,
    );

    return true;
  }

  ///
  Future<void> logoutUser(BuildContext context) async {
    final authenticationCubit = context.read<AuthenticationCubit>();

    final storageCubit = context.read<StorageCreator>().create();
    await storageCubit.loadLastLoggedUser();

    final userId = storageCubit.state.currentUser?.id;
    final intUserId = int.tryParse(userId ?? '');

    if (userId == null || intUserId == null) return;

    await authenticationCubit.logout(
      deactivateDevice: false,
    );
    await storageCubit.removeUser(userId);

    BankApp.restart(context);
  }
}
