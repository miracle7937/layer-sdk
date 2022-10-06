import 'package:design_kit_layer/design_kit_layer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

/// A header widget that shows a title and prefix and
/// suffix icons if indicated.
class SDKHeader extends StatelessWidget implements PreferredSizeWidget {
  /// The title for the header.
  final String title;

  /// Optional prefix icon.
  final String? prefixSvgIcon;

  /// Callback called when the [prefixSvgIcon] is pressed.
  /// Only indicate this if [prefixSvgIcon] is not null.
  final VoidCallback? onPrefixIconPressed;

  /// Optional suffix icon.
  final String? suffixSvgIcon;

  /// Callback called when the [suffixSvgIcon] is pressed.
  /// Only indicate this if [suffixSvgIcon] is not null.
  final VoidCallback? onSuffixIconPressed;

  /// Optional suffix widget.
  final Widget? customSuffix;

  /// Creates a new [SDKHeader].
  const SDKHeader({
    Key? key,
    required this.title,
    this.preferredSize = const Size.fromHeight(kToolbarHeight),
    this.prefixSvgIcon,
    this.onPrefixIconPressed,
    this.suffixSvgIcon,
    this.onSuffixIconPressed,
    this.customSuffix,
  })  : assert(prefixSvgIcon == null || onPrefixIconPressed != null),
        assert(suffixSvgIcon == null || onSuffixIconPressed != null),
        assert(suffixSvgIcon == null || customSuffix == null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final layerDesign = DesignSystem.of(context);

    return DKShadowedContainer(
      /// TODO: change when the shadow is ready on the dk layer.
      shadow: DKShadow(
        outer: [
          BoxShadow(
            offset: Offset(0.0, 4.0),
            blurRadius: 6.0,
            color: Color(0xFF000000).withOpacity(0.03),
          ),
        ],
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24.0),
          bottomRight: Radius.circular(24.0),
        ),
        color: layerDesign.surfaceNonary3,
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              if (prefixSvgIcon != null) ...[
                GestureDetector(
                  onTap: onPrefixIconPressed,
                  child: SvgPicture.asset(
                    prefixSvgIcon!,
                    height: 24.0,
                    width: 24.0,
                  ),
                ),
                const SizedBox(width: 10.0),
              ],
              if (prefixSvgIcon == null && suffixSvgIcon != null)
                const SizedBox(width: 34.0),
              Expanded(
                child: Text(
                  title,
                  style: layerDesign.titleM(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
              ),
              if (prefixSvgIcon != null &&
                  suffixSvgIcon == null &&
                  customSuffix == null)
                const SizedBox(width: 34.0),
              if (suffixSvgIcon != null) ...[
                const SizedBox(width: 10.0),
                GestureDetector(
                  onTap: onSuffixIconPressed,
                  child: SvgPicture.asset(
                    suffixSvgIcon!,
                    height: 24.0,
                    width: 24.0,
                  ),
                ),
              ],
              if (customSuffix != null) ...[
                customSuffix!,
              ]
            ],
          ),
        ),
      ),
    );
  }

  @override
  final Size preferredSize;
}
