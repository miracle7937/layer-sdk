import 'dart:ui';

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

  /// Info
  info,
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
    Color? backgroundColor,
  }) =>
      showModalBottomSheet<T>(
        context: context,
        barrierColor: DesignSystem.of(context).basePrimary.withOpacity(0.64),
        isDismissible: dismissible,
        enableDrag: enableDrag,
        isScrollControlled: isScrollControlled,
        backgroundColor: backgroundColor,
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
        builder: (context) => Padding(
          padding: MediaQuery.of(context).viewInsets,
          child: builder(context),
        ),
      );

  /// Shows an error bottomsheet with the provided params.
  ///
  /// Use the `blurBackground` parameter to blur the background of the
  /// bottomsheet. Defaults to `false`.
  static Future<void> showError({
    required BuildContext context,
    required String titleKey,
    String? descriptionKey,
    String dismissKey = 'ok',
    bool isScrollControlled = true,
    Color? backgroundColor,
    BottomSheetType type = BottomSheetType.error,
    bool blurBackground = false,
  }) async {
    final translation = Translation.of(context);
    final design = DesignSystem.of(context);

    final content = _ErrorBottomSheet(
      title: translation.translate(titleKey),
      dismiss: translation.translate(dismissKey),
      description:
          descriptionKey != null ? translation.translate(descriptionKey) : null,
      type: type,
    );

    final radius = BorderRadius.only(
      topLeft: Radius.circular(
        24.0,
      ),
      topRight: Radius.circular(
        24.0,
      ),
    );

    return showModalBottomSheet(
      context: context,
      barrierColor: DesignSystem.of(context).basePrimary.withOpacity(0.64),
      isScrollControlled: isScrollControlled,
      backgroundColor: blurBackground
          ? Colors.transparent
          : (backgroundColor ?? design.surfaceNonary2),
      shape: RoundedRectangleBorder(
        borderRadius: radius,
      ),
      builder: (context) => blurBackground
          ? BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 2.0,
                sigmaY: 2.0,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: backgroundColor ?? design.surfaceNonary2,
                  borderRadius: radius,
                ),
                child: content,
              ),
            )
          : content,
    );
  }

  /// Shows an error bottomsheet with the provided params.
  ///
  /// Use the `blurBackground` parameter to blur the background of the
  /// bottomsheet. Defaults to `false`.
  static Future<void> showLocalizedError({
    required BuildContext context,
    required String title,
    String? description,
    required String dismiss,
    bool isScrollControlled = true,
    Color? backgroundColor,
    bool blurBackground = false,
  }) async {
    final design = DesignSystem.of(context);

    final content = _ErrorBottomSheet(
      title: title,
      dismiss: dismiss,
      description: description,
      type: BottomSheetType.error,
    );

    final radius = BorderRadius.only(
      topLeft: Radius.circular(
        24.0,
      ),
      topRight: Radius.circular(
        24.0,
      ),
    );

    return showModalBottomSheet(
      barrierColor: design.basePrimary.withOpacity(0.64),
      context: context,
      backgroundColor: blurBackground
          ? Colors.transparent
          : (backgroundColor ?? design.surfaceNonary2),
      isScrollControlled: isScrollControlled,
      shape: RoundedRectangleBorder(
        borderRadius: radius,
      ),
      builder: (context) => blurBackground
          ? BackdropFilter(
              filter: ImageFilter.blur(
                sigmaX: 2.0,
                sigmaY: 2.0,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: backgroundColor ?? design.surfaceNonary2,
                  borderRadius: radius,
                ),
                child: content,
              ),
            )
          : content,
    );
  }

  /// Shows a confirmation bottomsheet with the provided params
  ///
  /// Returns true or false based on the user action.
  static Future<bool?> showConfirmation({
    required BuildContext context,
    required BottomSheetType type,
    String? titleKey,
    String? title,
    String? descriptionKey,
    String confirmKey = 'yes',
    String denyKey = 'no',
    bool isScrollControlled = true,
    bool showDenyButton = true,
    bool isDismissible = true,
    Color? backgroundColor,
    bool blurBackground = false,
    bool enableDrag = true,
    DKButtonType denyButtonType = DKButtonType.baseSecondary,
  }) async {
    final design = DesignSystem.of(context);

    final radius = BorderRadius.only(
      topLeft: Radius.circular(
        24.0,
      ),
      topRight: Radius.circular(
        24.0,
      ),
    );

    final result = await showModalBottomSheet(
      enableDrag: enableDrag,
      isDismissible: isDismissible,
      context: context,
      barrierColor: DesignSystem.of(context).basePrimary.withOpacity(0.64),
      backgroundColor: blurBackground
          ? Colors.transparent
          : (backgroundColor ?? design.surfaceNonary2),
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
      builder: (context) {
        final content = _ConfirmationBottomSheet(
          titleKey: titleKey,
          title: title,
          confirmKey: confirmKey,
          dismissKey: denyKey,
          type: type,
          descriptionKey: descriptionKey,
          showDenyButton: showDenyButton,
          denyButtonType: denyButtonType,
        );

        return blurBackground
            ? BackdropFilter(
                filter: ImageFilter.blur(
                  sigmaX: 2.0,
                  sigmaY: 2.0,
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: backgroundColor ?? design.surfaceNonary2,
                    borderRadius: radius,
                  ),
                  child: content,
                ),
              )
            : content;
      },
    );

    return result;
  }
}

class _ErrorBottomSheet extends StatelessWidget {
  final String title;
  final String? description;
  final String dismiss;
  final BottomSheetType type;

  const _ErrorBottomSheet({
    Key? key,
    required this.title,
    required this.dismiss,
    required this.type,
    this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final design = DesignSystem.of(context);

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
            title,
            style: design.titleXXL(),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            height: description == null ? 32.0 : 8.0,
          ),
          if (description != null) ...[
            Text(
              description!,
              style: design.bodyM(),
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 32.0,
            ),
          ],
          DKButton(
            title: dismiss,
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}

class _ConfirmationBottomSheet extends StatelessWidget {
  final String? titleKey;
  final String? title;
  final String? descriptionKey;
  final String confirmKey;
  final String dismissKey;
  final BottomSheetType type;
  final bool showDenyButton;
  final DKButtonType denyButtonType;

  const _ConfirmationBottomSheet({
    Key? key,
    required this.confirmKey,
    required this.dismissKey,
    required this.type,
    required this.denyButtonType,
    this.titleKey,
    this.title,
    this.descriptionKey,
    this.showDenyButton = true,
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
            titleKey == null ? (title ?? '') : translation.translate(titleKey!),
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
          if (showDenyButton) ...[
            const SizedBox(height: 12.0),
            DKButton(
              title: translation.translate(dismissKey),
              type: denyButtonType,
              onPressed: () => Navigator.pop(context, false),
            ),
          ],
        ],
      ),
    );
  }
}

/// Extension that provides mapping for [BottomSheetType].
extension BottomSheetTypeUIExtension on BottomSheetType {
  /// Maps into a asset path.
  String toAsset() {
    switch (this) {
      case BottomSheetType.error:
        return FLImages.error;

      case BottomSheetType.warning:
        return FLImages.warning;

      case BottomSheetType.success:
        return FLImages.success;

      case BottomSheetType.info:
        return FLImages.info;
    }
  }
}
