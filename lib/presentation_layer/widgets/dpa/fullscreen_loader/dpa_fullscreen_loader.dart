import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../layer_sdk.dart';

/// Creates the fullscreen loader for the dpa flow.
class DPAFullscreenLoader extends StatelessWidget {
  /// The logo path
  final String? asset;

  /// Creates a new [DPAFullscreenLoader].
  const DPAFullscreenLoader({
    Key? key,
    this.asset,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final translation = Translation.of(context);
    final design = DesignSystem.of(context);
    return asset != null
        ? LayerScaffold(
            body: Container(
              color: DesignSystem.of(context).surfaceOctonary1,
              child: SafeArea(
                child: Stack(
                  children: [
                    Positioned(
                        top: 81.0,
                        left: (MediaQuery.of(context).size.width / 2) - 60.5,
                        right: (MediaQuery.of(context).size.width / 2) - 60.5,
                        child: SvgPicture.asset(asset!)),
                    Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          DKLoader(),
                          SizedBox(height: 42.0),
                          Text(
                            translation.translate('please_wait'),
                          ),
                          SizedBox(height: 10.0),
                          Text(
                            translation
                                .translate('we_are_verifying_your_information'),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        : Container(
            // TODO: Add this color to the design system (modal/overlay)
            color: Color(0xFF191A19).withOpacity(0.64),
            child: Center(
                child: DKLoader(
                    size: 72,
                    startColor: design.basePrimaryWhite,
                    endColor: design.basePrimaryWhite.withOpacity(0))));
  }
}
