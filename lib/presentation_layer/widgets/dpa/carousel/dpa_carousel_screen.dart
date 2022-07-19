import 'package:design_kit_layer/design_kit_layer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../data_layer/environment.dart';
import '../../../../features/dpa.dart';
import '../../../extensions.dart';
import '../../../resources.dart';
import '../../../widgets.dart';

/// DPA Screen that handles all `DPAVariableType.swipe` variables
/// in a [DPAProcess].
class DPACarouselScreen extends StatelessWidget {
  /// Creates a new [DPACarouselScreen] instance.
  const DPACarouselScreen({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final design = DesignSystem.of(context);

    final state = context.watch<DPAProcessCubit>().state;

    final content = state.process.variables
        .map(
          (variable) => Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 24.0),
                if (variable.property.image != null) ...[
                  NetworkImageContainer(
                    imageURL: variable.property.image!,
                    customToken: EnvironmentConfiguration.current.defaultToken,
                    placeholder: const SizedBox(
                      height: 200,
                      width: 200,
                    ),
                  ),
                  const SizedBox(height: 24.0),
                ],
                Text(
                  variable.label ?? '',
                  textAlign: TextAlign.center,
                  style: design.titleM(),
                ),
                const SizedBox(height: 24.0),
                Text(
                  variable.value?.replaceAll('\\n', '\n'),
                  textAlign: TextAlign.center,
                  style: design.bodyM(),
                ),
              ],
            ),
          ),
        )
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: DKButton.icon(
            padding: const EdgeInsets.all(16.0),
            iconPath: FLImages.back,
            onPressed: () => _showSkipBottomSheet(context),
            type: DKButtonType.basePlain,
          ),
        ),
        Expanded(
          child: CarouselPageView(
            children: content,
            onFinished: () => context.read<DPAProcessCubit>().stepOrFinish(),
            onSkip: () => _showSkipBottomSheet(context),
            busy: state.busy,
          ),
        ),
      ],
    );
  }

  void _showSkipBottomSheet(
    BuildContext context,
  ) async {
    final result = await BottomSheetHelper.showConfirmation(
      context: context,
      titleKey: 'cancel_process',
      type: BottomSheetType.warning,
      denyKey: 'cancel',
    );

    if (result) {
      context.read<DPAProcessCubit>().cancelProcess();
    }
  }
}
