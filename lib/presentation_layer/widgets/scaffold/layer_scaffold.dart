import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../app/app_configuration.dart';

/// Widget to be used instead of [Scaffold] in our screens.
///
/// It provides the functionality to automatically hide a keyboard based on the
/// [AppConfiguration.autoHideKeyboard].
class LayerScaffold extends Scaffold {
  /// Creates a new [LayerScaffold].
  LayerScaffold({
    super.key,
    super.appBar,
    super.body,
    super.floatingActionButton,
    super.floatingActionButtonLocation,
    super.floatingActionButtonAnimator,
    super.persistentFooterButtons,
    super.drawer,
    super.onDrawerChanged,
    super.endDrawer,
    super.onEndDrawerChanged,
    super.bottomNavigationBar,
    super.bottomSheet,
    super.backgroundColor,
    super.resizeToAvoidBottomInset,
    super.primary,
    super.drawerDragStartBehavior,
    super.extendBody,
    super.extendBodyBehindAppBar,
    super.drawerScrimColor,
    super.drawerEdgeDragWidth,
    super.drawerEnableOpenDragGesture,
    super.endDrawerEnableOpenDragGesture,
    super.restorationId,
  });

  @override
  ScaffoldState createState() => LayerScaffoldState();
}

/// The state of [LayerScaffold].
class LayerScaffoldState extends ScaffoldState {
  @override
  Widget build(BuildContext context) {
    final autoHideKeyboard = context.select<AppConfiguration, bool>(
      (configuration) => configuration.autoHideKeyboard,
    );

    final scaffold = super.build(context);

    if (autoHideKeyboard) {
      return GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: scaffold,
      );
    }
    return scaffold;
  }
}
