import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../business_layer/business_layer.dart';

/// A widget that manages the user interaction inactivity.
///
/// The first time the widget gets rendered, the global settings for the
/// screen timeout and the session expiry gets retrieved using the
/// [GlobalSettingCubit].
///
/// These settings could be not defined on BE so in case this happens, the
/// [inactivityDuration] and [backgroundDuration] parameters will be used.
///
///   * The [inactivityDuration] parameter indicates the amount of time that can
///   elapse without user interaction when the app is on foreground.
///
///   * The [backgroundDuration] parameter indicates the amount of time that can
///   elapse with the app being in background before it resumes.
///
/// Use the [enabled] parameter for activating/deactivating this feature.
///
/// When [enabled] and the inactivity or background inactivity time is up,
/// the [AuthenticationCubit.setPinNeedsVerification] method will be called
/// and the app will have to listen for the change of this value for showing
/// an authentication flow.
///
/// A [child] widget is needed for using this feature.
///
/// {@tool snippet}
/// ```dart
/// AutoLock(
///   enabled: true,
///   inactivityDuration: const Duration(minutes: 3),
///   backgroundDuration: const Duration(minutes: 1),
///   child: HomeScreen(),
/// );
/// ```
/// {@end-tool}
///
/// {@tool snippet}
/// Then on you app, you can have a listener for the [AuthenticationCubit] for
/// showing the authentication flow in case of user inactivity:
///
/// ```dart
/// BlocListener<AuthenticationCubit, AuthenticationState>(
///   listener: (context, state) {
///     /// Show the authentication flow for the user to re-log.
///   },
///   listenWhen: (previous, current) => previous.verifyPinResponse.isVerified
///     != current.verifyPinResponse.isVerified
/// );
/// ```
/// {@end-tool}
class AutoLock extends StatefulWidget {
  /// Child widget.
  final Widget? child;

  /// The default span of time without activity that triggers the lock
  /// to be used when "screen_timeout" global setting is not defined.
  ///
  /// Defaults to 5 minutes.
  final Duration inactivityDuration;

  /// The default span of time the app has to be on the background to trigger
  /// a lock to be used when "session_expiry" global setting is not defined.
  ///
  /// Defaults to 10 seconds.
  final Duration backgroundDuration;

  /// When not enabled, the user will remain unlocked at all times.
  ///
  /// Defaults to true.
  final bool enabled;

  /// Creates an AutoLock with the inactivity duration default of 3 minutes.
  const AutoLock({
    Key? key,
    this.child,
    this.inactivityDuration = const Duration(minutes: 5),
    this.backgroundDuration = const Duration(seconds: 10),
    this.enabled = true,
  }) : super(key: key);

  @override
  _AutoLockState createState() => _AutoLockState();
}

// ignore: prefer_mixin
class _AutoLockState extends State<AutoLock> with WidgetsBindingObserver {
  Timer? _inactivityTimer;
  DateTime? _timeWentToBackground;

  Duration? inactivityDuration;
  Duration? backgroundDuration;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didUpdateWidget(AutoLock oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!oldWidget.enabled && widget.enabled) {
      loadSettings();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (widget.enabled) {
      loadSettings();
    }
  }

  void loadSettings() {
    context.read<GlobalSettingCubit>().load(
      codes: [
        'screen_timeout',
        'session_expiry',
      ],
    );
  }

  @override
  void dispose() {
    _inactivityTimer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: do this in a cleaner way
    inactivityDuration = Duration(
      seconds: context.select<GlobalSettingCubit, int?>(
            (c) => c.state.getSetting<int>(
              module: 'access_pin',
              code: 'screen_timeout',
            ),
          ) ??
          widget.inactivityDuration.inSeconds,
    );
    backgroundDuration = Duration(
      seconds: context.select<GlobalSettingCubit, int?>(
            (c) => c.state.getSetting<int>(
              module: 'access_pin',
              code: 'session_expiry',
            ),
          ) ??
          widget.backgroundDuration.inSeconds,
    );

    return BlocListener<AuthenticationCubit, AuthenticationState>(
      listenWhen: (oldState, newState) =>
          !oldState.verifyPinResponse.isVerified &&
          newState.verifyPinResponse.isVerified,
      listener: (context, state) => _initializeTimer(),
      child: GestureDetector(
        child: widget.child,
        onTapUp: (_) => _initializeTimer(),
        onTapDown: (_) => _initializeTimer(),
      ),
    );
  }

  void _dismissTimer() => _inactivityTimer?.cancel();

  void _initializeTimer() {
    if (!widget.enabled) return;

    _dismissTimer();
    if (inactivityDuration != null) {
      _inactivityTimer = Timer(inactivityDuration!, _onInactive);
    }
  }

  void _onInactive() async {
    context.read<AuthenticationCubit>().setPinNeedsVerification();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    if (!widget.enabled) return;

    _dismissTimer();

    // Saves the time the app went into the background.
    if (state == AppLifecycleState.paused) {
      _timeWentToBackground = DateTime.now();
    }

    // Upon returning to the foreground, check how long we were in the
    // background, and if long enough, call onInactive.
    // we reset _timeWentToBackground as this would cause issues on iOS
    // in case the biometrics dialog was opened for too long, it would cause
    // the lock screen to rebuild itself multiple times.
    final now = DateTime.now();
    if (state == AppLifecycleState.resumed &&
        _timeWentToBackground != null &&
        backgroundDuration != null &&
        now.difference(_timeWentToBackground!) >= backgroundDuration!) {
      _timeWentToBackground = null;
      _onInactive();
    }
  }
}
