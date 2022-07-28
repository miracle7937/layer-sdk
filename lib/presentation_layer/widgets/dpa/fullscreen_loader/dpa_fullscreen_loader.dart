import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../../../layer_sdk.dart';

/// Creates the fullscreen loader for the dpa flow.
class DPAFullscreenLoader extends StatelessWidget {
  /// Creates a new [DPAFullscreenLoader].

  final String? asset;

  /// constuctor of [DPAFullscreenLoader]
  const DPAFullscreenLoader({
    Key? key,
    this.asset,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final design = DesignSystem.of(context);

    final translation = Translation.of(context);
    return Scaffold(
      body: Container(
        color: DesignSystem.of(context).surfaceOctonary1,
        child: SafeArea(
          child: Stack(
            children: [
              if (asset != null)
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
    );
  }
}
