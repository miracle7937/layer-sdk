import 'package:design_kit_layer/design_kit_layer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../resources.dart';
import '../../utils.dart';

/// Available bottomsheet types.
enum BottomSheetType {
  /// Error
  error,

  /// Warning
  warning,

  /// Sucess
  success,
}

// ignore: avoid_classes_with_only_static_members
/// Helper class that displays bottomsheets
class BottomSheetHelper {
  /// Private constructor.
  BottomSheetHelper._();

  /// Shows a modal BottomSheet with the provided `context` and `builder`.
  ///
  /// Use the `customShape` parameter to change the created BottomSheet shape.
  /// If none is provided, the `topLeft` and `topRight` radius will
  /// be set to `24.0`, following the design kit.
  static Future<T?> show<T>({
    required BuildContext context,
    required WidgetBuilder builder,
    ShapeBorder? customShape,
    bool dismissible = true,
    bool enableDrag = true,
    bool isScrollControlled = true,
  }) =>
      showModalBottomSheet<T>(
        context: context,
        isDismissible: dismissible,
        enableDrag: enableDrag,
        isScrollControlled: isScrollControlled,
        shape: customShape ??
            const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(
                  24.0,
                ),
                topRight: Radius.circular(
                  24.0,
                ),
              ),
            ),
        builder: builder,
      );

  /// Shows an error bottomsheet with the provided params.
  static Future<void> showError({
    required BuildContext context,
    required String titleKey,
    String? descriptionKey,
    String dismissKey = 'ok',
    bool isScrollControlled = true,
    bool iconWithBackground = false,
  }) async =>
      showModalBottomSheet(
        context: context,
        isScrollControlled: isScrollControlled,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(
              24.0,
            ),
            topRight: Radius.circular(
              24.0,
            ),
          ),
        ),
        builder: (context) => _ErrorBottomSheet(
          titleKey: titleKey,
          dismissKey: dismissKey,
          descriptionKey: descriptionKey,
          type: BottomSheetType.error,
          iconWithBackground: iconWithBackground,
        ),
      );

  /// Shows a confirmation bottomsheet with the provided params
  ///
  /// Returns true or false based on the user action.
  static Future<bool> showConfirmation({
    required BuildContext context,
    required String titleKey,
    required BottomSheetType type,
    bool iconWithBackground = false,
    String? descriptionKey,
    String confirmKey = 'yes',
    String denyKey = 'no',
    bool isScrollControlled = true,
  }) async {
    final result = await showModalBottomSheet(
      context: context,
      isScrollControlled: isScrollControlled,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(
            24.0,
          ),
          topRight: Radius.circular(
            24.0,
          ),
        ),
      ),
      builder: (context) => _ConfirmationBottomSheet(
        titleKey: titleKey,
        confirmKey: confirmKey,
        dismissKey: denyKey,
        type: type,
        descriptionKey: descriptionKey,
        iconWithBackground: iconWithBackground,
      ),
    );

    return result ?? false;
  }
}

class _ErrorBottomSheet extends StatelessWidget {
  final String titleKey;
  final String? descriptionKey;
  final String dismissKey;
  final BottomSheetType type;
  final bool? iconWithBackground;
  const _ErrorBottomSheet({
    Key? key,
    required this.titleKey,
    required this.dismissKey,
    required this.type,
    this.descriptionKey,
    this.iconWithBackground = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final design = DesignSystem.of(context);
    final translation = Translation.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 36.0,
        horizontal: 16.0,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            type.toAsset(iconWithBackground: iconWithBackground),
          ),
          const SizedBox(
            height: 20.0,
          ),
          Text(
            translation.translate(titleKey),
            style: design.titleXXL(),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: descriptionKey == null ? 32.0 : 8.0,
          ),
          if (descriptionKey != null) ...[
            Text(
              translation.translate(descriptionKey!),
              style: design.bodyM(),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 32.0,
            ),
          ],
          DKButton(
            title: translation.translate(dismissKey),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}

class _ConfirmationBottomSheet extends StatelessWidget {
  final String titleKey;
  final String? descriptionKey;
  final String confirmKey;
  final String dismissKey;
  final BottomSheetType type;
  final bool iconWithBackground;
  const _ConfirmationBottomSheet({
    Key? key,
    required this.titleKey,
    required this.confirmKey,
    required this.dismissKey,
    required this.type,
    required this.iconWithBackground,
    this.descriptionKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final design = DesignSystem.of(context);
    final translation = Translation.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 36.0,
        horizontal: 16.0,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgPicture.asset(
            type.toAsset(),
          ),
          const SizedBox(
            height: 20.0,
          ),
          Text(
            translation.translate(titleKey),
            style: design.titleXXL(),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: descriptionKey == null ? 32.0 : 8.0,
          ),
          if (descriptionKey != null) ...[
            Text(
              translation.translate(descriptionKey!),
              style: design.bodyM(),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 32.0,
            ),
          ],
          DKButton(
            title: translation.translate(confirmKey),
            onPressed: () => Navigator.pop(context, true),
          ),
          const SizedBox(height: 12.0),
          DKButton(
            title: translation.translate(dismissKey),
            type: DKButtonType.baseSecondary,
            onPressed: () => Navigator.pop(context, false),
          ),
        ],
      ),
    );
  }
}

/// Extension that provides mapping for [BottomSheetType].
extension BottomSheetTypeUIExtension on BottomSheetType {
  /// Maps into a asset path.
  String toAsset({bool? iconWithBackground}) {
    switch (this) {
      case BottomSheetType.error:
        return (iconWithBackground ?? false)
            ? FLImages.errorWithBackground
            : FLImages.error;

      case BottomSheetType.warning:
        return (iconWithBackground ?? false)
            ? FLImages.warningWithBackground
            : FLImages.warning;

      case BottomSheetType.success:
        return (iconWithBackground ?? false)
            ? FLImages.successWithBackground
            : FLImages.success;
    }
  }
}
