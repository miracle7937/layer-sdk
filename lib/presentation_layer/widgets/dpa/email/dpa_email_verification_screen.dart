import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:open_mail_app/open_mail_app.dart';

import '../../../../layer_sdk.dart';

/// DPA Email screen to handle the [DPAScreenType.email]
/// Used for verifying the email.
class DPAEmailVerificationScreen extends StatelessWidget {
  /// Custom `DPAHeader` widget
  final Widget? customDPAHeader;

  /// Creates a new [DPAEmailVerificationScreen] instance
  const DPAEmailVerificationScreen({
    Key? key,
    this.customDPAHeader,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final design = DesignSystem.of(context);
    final translation = Translation.of(context);

    final state = context.watch<DPAProcessCubit>().state;
    final process = state.process;
    final variables = process.variables.first;

    final isRequestingManualVerification = state.actions.contains(
      DPAProcessBusyAction.requestingManualVerification,
    );

    final isRequestingEmailChange = state.actions.contains(
      DPAProcessBusyAction.requestingEmailChange,
    );

    final header = customDPAHeader ?? DPAHeader(process: process);
    final imageUrl = process.stepProperties?.image;
    final email = process.stepProperties?.email;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        header,
        if (imageUrl != null)
          NetworkImageContainer(
            imageURL: imageUrl,
          ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            variables.value.replaceAll('{email}', email),
            textAlign: TextAlign.center,
            style: design.bodyM(),
          ),
        ),
        const SizedBox(height: 24.0),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: DKButton(
            title: translation.translate('go_to_mail_app'),
            onPressed: () => _openMailApp(context),
          ),
        ),
        const SizedBox(height: 34.0),
        DKButton(
          title: translation.translate('enter_verification_code').toLowerCase(),
          type: DKButtonType.brandPlain,
          expands: false,
          status: isRequestingManualVerification
              ? DKButtonStatus.loading
              : DKButtonStatus.idle,
          onPressed: context.read<DPAProcessCubit>().requestManualVerification,
        ),
        const SizedBox(height: 44.0),
        DKButton(
          title: translation.translate('change_email_address'),
          type: DKButtonType.basePlain,
          expands: false,
          status: isRequestingEmailChange
              ? DKButtonStatus.loading
              : DKButtonStatus.idle,
          onPressed: context.read<DPAProcessCubit>().requestEmailAddressChange,
        ),
      ],
    );
  }

  /// Method to handle available mail apps installed
  Future<void> _openMailApp(BuildContext context) async {
    final result = await OpenMailApp.openMailApp();

    // iOS: if multiple mail apps found, show dialog to select.
    // There is no native intent/default app system in iOS so
    // you have to do it yourself.
    if (!result.didOpen && result.canOpen) {
      showDialog(
        context: context,
        //TODO: Check the design for the mail picker
        builder: (_) => MailAppPickerDialog(
          mailApps: result.options,
        ),
      );
    }
  }
}
