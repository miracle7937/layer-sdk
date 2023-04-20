import 'dart:collection';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../app.dart';
import '../../utils.dart';
import '../../widgets.dart';
import 'authentication_method_configuration.dart';

/// A class containing all the necessary
/// parameters for [BankApp] configuration.
class AppConfiguration {
  /// An object containing all the necessary configuration for the app theme.
  final AppThemeConfiguration appThemeConfiguration;

  /// An object containing all the necessary configuration
  /// for the app navigation.
  final AppNavigationConfiguration appNavigationConfiguration;

  /// An object containing all the necessary configuration for the app
  /// localization.
  final AppLocalizationConfiguration appLocalizationConfiguration;

  /// A list of creators to be provided for the [BankApp] subtree.
  final UnmodifiableListView<CreatorProvider> creators;

  /// A list of bloc listeners to be put on [BankApp] level.
  final UnmodifiableListView<BlocListener> listeners;

  /// True if the application should use the default [AutoLock] solution.
  ///
  /// Defaults to `true`.
  final bool autoLockEnabled;

  /// True if the application should fetch the customer object
  ///
  /// Defaults to `false`.
  final bool shouldFetchCustomerObject;

  /// True if the application should be aware of the design sizes -- in other
  /// words, the [BankApp] will provide a [DesignAware] for the tree.
  ///
  /// Defaults to `true`.
  final bool designAware;

  /// The application title to be passed to [MaterialApp.title]
  final String? title;

  /// True if the application should wrap the routes with
  /// the [AutoPaddingKeyboardView]
  ///
  /// If your app is using the [DoneActionKeyboard] on the widget tree to
  /// show the `Done` action on the iOS keyboard, every [TextField] and
  /// [TextFormField] will be overlapped by the keyboard if the input is close
  /// to the bottom of the view.
  ///
  /// For fixing that, set `autoKeyboardPaddingEnabled` to true to add a view
  /// that adds/removes a padding to the generated route in case the
  /// keyboard is shown/hidden
  ///
  /// You will also have to change the `scrollPadding` value of every
  /// [TextField] and [TextFormField] to match the
  /// [InputDoneView.doneViewHeight] when the `Platform` is `iOS` so the
  /// input does not get overlapped by the keyboard
  ///
  /// Defaults to `true`.
  final bool autoKeyboardPaddingEnabled;

  /// True if the application should automatically hide the keyboard on tap.
  final bool autoHideKeyboard;

  /// A list of [FLInterceptor] for the [NetClient].
  final UnmodifiableListView<FLInterceptor> interceptors;

  /// Whether the `FirebaseAnalyticsObserver` should be added to the
  /// `navigatorObservers` of the `MaterialApp`.
  ///
  /// Defaults to `false`.
  final bool firebaseAnalyticsEnabled;

  /// Whether if the [ExperiencePage]s containers should be filtered by
  /// the [UserPermissions].
  ///
  /// Set this as `false` in case you want to handle the case where the
  /// pages don't have any container with user permissions.
  ///
  /// Default is `true`.
  final bool shouldFilterExperiencePageContainersByUserPermissions;

  /// The authentication method used by the application.
  ///
  /// The value specified here is used to determine the use case that will save
  /// and load the credentials for usage with biometrics.
  final AuthenticationMethodConfiguration authenticationMethod;

  /// Creates the [AppConfiguration] object.
  AppConfiguration({
    required this.appThemeConfiguration,
    required this.appNavigationConfiguration,
    required this.appLocalizationConfiguration,
    Iterable<CreatorProvider>? creators,
    Iterable<BlocListener>? listeners,
    this.autoLockEnabled = true,
    this.shouldFetchCustomerObject = false,
    this.designAware = true,
    this.autoKeyboardPaddingEnabled = true,
    this.title,
    this.firebaseAnalyticsEnabled = false,
    Iterable<FLInterceptor>? interceptors,
    this.shouldFilterExperiencePageContainersByUserPermissions = true,
    this.autoHideKeyboard = true,
    this.authenticationMethod = AuthenticationMethodConfiguration.accessPin,
  })  : creators = UnmodifiableListView(creators ?? []),
        listeners = UnmodifiableListView(listeners ?? []),
        interceptors = UnmodifiableListView(interceptors ?? []);
}
