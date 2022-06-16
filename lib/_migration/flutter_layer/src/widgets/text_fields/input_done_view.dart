import 'package:flutter/cupertino.dart';

import '../../../../../presentation_layer/utils.dart';
import '../../../flutter_layer.dart';

/// View that appears when the keyboard is shown and
/// that shows a button that will close the keyboard when pressed
class InputDoneView extends StatelessWidget {
  /// The [InputDoneView] height
  static const double doneViewHeight = 52.0;

  /// Custom [String] for the button.
  /// If not provided the default localization will be the one for key `done`
  final String? customButtonTitle;

  /// Creates a new [InputDoneView]
  const InputDoneView({
    Key? key,
    this.customButtonTitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        color:
            AppTheme.of(context).toThemeData().backgroundColor.withOpacity(0.8),
        child: Align(
          alignment: Alignment.topRight,
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 4.0),
            child: CupertinoButton(
              padding: EdgeInsets.only(right: 24.0, top: 8.0, bottom: 8.0),
              onPressed: () => FocusScope.of(context).unfocus(),
              child: Text(
                customButtonTitle ?? Translation.of(context).translate('done'),
              ),
            ),
          ),
        ),
      );
}
