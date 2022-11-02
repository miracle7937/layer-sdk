import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:location/location.dart' as loc;
import 'package:path_provider/path_provider.dart';

import '../../_migration/flutter_layer/src/cubits.dart';
import '../../_migration/flutter_layer/src/widgets/text_fields/auto_padding_keyboard_view.dart';
import '../../data_layer/environment.dart';
import '../../data_layer/interfaces.dart';
import '../../data_layer/network.dart';
import '../../data_layer/providers.dart';
import '../../data_layer/repositories.dart';
import '../../domain_layer/use_cases.dart';
import '../app.dart';
import '../creators.dart';
import '../cubits.dart';
import '../design.dart';
import '../utils.dart';
import '../widgets.dart';

/// The builder invoked in the [MaterialApp.builder] callback.
typedef NavigatorBuilder = Widget Function(
  BuildContext context,
  Widget child,
  GlobalKey<NavigatorState> navigatorKey,
);

/// The main application widget.
///
/// The application widget provides basic functionality
/// to all bank applications:
/// - switching [ThemeMode] and [AppTheme] for light and dark modes at runtime,
/// - switching app [Locale],
/// - loading and configuring the app [Experience],
/// - requesting device permissions.
///
/// The application widget provides the following cubits for its subtree:
/// - [AppThemeCubit]
/// - [AuthenticationCubit]
/// - [CurrencyCubit]
/// - [DevicePermissionsCubit]
/// - [ExperienceCubit]
/// - [GlobalSettingCubit]
/// - [LocationCubit]
/// - [LocalizationCubit]
/// - [RootCheckCubit]
/// - [UnreadAlertsCountCubit]
/// - [GeofencingCubit]
///
/// The application widget provides cubit creators supplied in the
/// [appConfiguration] for its subtree.
class BankApp extends StatefulWidget {
  /// An object containing all the necessary
  /// parameters for [BankApp] configuration.
  final AppConfiguration appConfiguration;

  /// The storage solution to be used to store non sensitive data.
  ///
  /// This field is optional, if no value is provided
  /// [PreferencesStorage] will be used.
  final GenericStorage preferencesStorage;

  /// The storage solution to be used to store sensitive data.
  ///
  /// This field is optional, if no value is provided
  /// [SecureStorage] will be used.
  final GenericStorage secureStorage;

  /// The [NetClient] to be used for API requests.
  final NetClient netClient;

  /// An optional builder to be passed to the [MaterialApp].
  final NavigatorBuilder? builder;

  /// The home widget to be passed to the `MaterialApp`, added for x-app
  /// compatibility.
  @Deprecated('Use `initialRoute` in `AppNavigationConfiguration` instead.')
  final Widget? home;

  /// In case the [AppConfiguration] sets the app to be design aware, this
  /// lists the design size definitions to use.
  ///
  /// If empty (the default), the [DesignAware] widget defaults to the Figma
  /// default design sizes.
  ///
  /// Note that the sizes should be presented from smallest to biggest, or else
  /// the code will not be able to select the size correctly.
  final Map<DesignStyle, List<DesignAwareData>> designAvailableSizes;

  /// An objects that holds all the app necessary
  /// SSL configurations
  final AppSSLConfiguration? appSSLConfiguration;

  /// If true, an inherited MediaQuery will be used. If one is not available, or
  /// this is false, one will be built from the window.
  ///
  /// Cannot be null, defaults to false.
  final bool useInheritedMediaQuery;

  /// Creates [BankApp].
  BankApp({
    Key? key,
    required this.appConfiguration,
    GenericStorage? preferencesStorage,
    GenericStorage? secureStorage,
    required this.netClient,
    this.builder,
    this.home,
    this.designAvailableSizes = const <DesignStyle, List<DesignAwareData>>{},
    this.appSSLConfiguration,
    this.useInheritedMediaQuery = false,
  })  : preferencesStorage = preferencesStorage ?? PreferencesStorage(),
        secureStorage = secureStorage ?? SecureStorage(),
        super(key: key);

  @override
  BankAppState createState() => BankAppState();

  /// Restarts the applications.
  static void restart(BuildContext context) {
    final state = context.findAncestorStateOfType<BankAppState>();
    state?.restart();
  }
}

/// The state of the [BankApp] widget.
class BankAppState extends State<BankApp> {
  Key _appKey = UniqueKey();
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  /// Resets the [Key] passed to the [MaterialApp] to restart the application.
  void restart() {
    setState(() {
      _appKey = UniqueKey();
    });
  }

  @override
  void initState() {
    _initializeFileLogger();
    super.initState();
  }

  void _initializeFileLogger() async {
    final directory = await getApplicationDocumentsDirectory();
    try {
      FileLogger.getInstant()
          .initializeLogger(logFilesLocation: directory.path);
      debugPrint(
          'Initialized file logger Successfully on path: ${directory.path}');
    } on Exception catch (exception) {
      print('Error initializing the file logger: ${(exception)}');
    }
  }

  /// The creators that are injected by the layer SDK.
  List<CreatorSingleChildWidget> get layerSDKCreators => [
        CreatorProvider<BiometricsCreator>(
          create: (_) => BiometricsCreator(
            getBiometricsEnabledUseCase: GetBiometricsEnabledUseCase(
              loadGlobalSettingsUseCase: LoadGlobalSettingsUseCase(
                repository: GlobalSettingRepository(
                  provider: GlobalSettingProvider(
                    netClient: widget.netClient,
                  ),
                ),
              ),
              getDeviceModelUseCase: GetDeviceModelUseCase(),
            ),
          ),
        ),
        CreatorProvider<OcraAuthenticationCreator>(
          create: (_) => OcraAuthenticationCreator(
            ocraSuite: EnvironmentConfiguration.current.ocraSuite ?? '',
            clientChallengeOcraUseCase: ClientOcraChallengeUseCase(
              ocraRepository: OcraRepository(
                provider: OcraProvider(
                  netClient: widget.netClient,
                ),
              ),
            ),
            verifyOcraResultUseCase: VerifyOcraResultUseCase(
              ocraRepository: OcraRepository(
                provider: OcraProvider(
                  netClient: widget.netClient,
                ),
              ),
            ),
          ),
        ),
        CreatorProvider<SetPinScreenCreator>(
          create: (_) => SetPinScreenCreator(
            setAccessPinForUserUseCase: SetAccessPinForUserUseCase(
              repository: UserRepository(
                userProvider: UserProvider(
                  netClient: widget.netClient,
                ),
              ),
            ),
          ),
        ),
        CreatorProvider<StorageCreator>(
          create: (_) => StorageCreator(
            loadLoggedInUsersUseCase: LoadLoggedInUsersUseCase(
              secureStorage: widget.secureStorage,
            ),
            loadLastLoggedUserUseCase: LoadLastLoggedUserUseCase(
              secureStorage: widget.secureStorage,
            ),
            saveUserUseCase: SaveUserUseCase(
              secureStorage: widget.secureStorage,
            ),
            removeUserUseCase: RemoveUserUseCase(
              secureStorage: widget.secureStorage,
            ),
            loadAuthenticationSettingsUseCase:
                LoadAuthenticationSettingsUseCase(
              secureStorage: widget.secureStorage,
            ),
            saveAuthenticationSettingUseCase: SaveAuthenticationSettingUseCase(
              secureStorage: widget.secureStorage,
            ),
            loadOcraSecretKeyUseCase: LoadOcraSecretKeyUseCase(
              secureStorage: widget.secureStorage,
            ),
            saveOcraSecretKeyUseCase: SaveOcraSecretKeyUseCase(
              secureStorage: widget.secureStorage,
            ),
            setBrightnessUseCase: SetBrightnessUseCase(
              secureStorage: widget.secureStorage,
            ),
            loadBrightnessUseCase: LoadBrightnessUseCase(
              secureStorage: widget.secureStorage,
            ),
            toggleBiometricsUseCase: ToggleBiometricsUseCase(
              secureStorage: widget.secureStorage,
            ),
          ),
        ),
      ];

  @override
  Widget build(BuildContext context) {
    final app = MultiBlocProvider(
      providers: _blocProviders(
        themeConfiguration: widget.appConfiguration.appThemeConfiguration,
      ),
      child: _appBuilder(),
    );

    return MultiCreatorProvider(
      creators: [
        ...layerSDKCreators,
        ...widget.appConfiguration.creators,
      ],
      child: app,
    );
  }

  /// Returns a list of bloc providers for the scope of an entire application.
  List<BlocProvider> _blocProviders({
    required AppThemeConfiguration themeConfiguration,
  }) {
    return [
      BlocProvider<AppThemeCubit>(
        create: (context) => AppThemeCubit(
          defaultState: AppThemeState(
            availableLightThemes: themeConfiguration.availableLightThemes,
            availableDarkThemes: themeConfiguration.availableDarkThemes,
            selectedLightTheme: themeConfiguration.defaultTheme,
            selectedDarkTheme: themeConfiguration.defaultDarkTheme,
            mode: themeConfiguration.defaultThemeMode,
          ),
          storage: widget.preferencesStorage,
        )..loadSelectedThemes(),
      ),
      BlocProvider<LocalizationCubit>(
        create: (context) => LocalizationCubit(
          storage: widget.preferencesStorage,
          defaultLocaleName: widget.netClient.defaultLanguage,
        )..loadSavedLocale(),
      ),
      BlocProvider<ExperienceCubit>(
        create: (context) => ExperienceCubit(
          configureUserExperienceByExperiencePreferencesUseCase:
              ConfigureUserExperienceWithPreferencesUseCase(),
          getExperienceAndConfigureItUseCase:
              GetExperienceAndConfigureItUseCase(
            repository: ExperienceRepository(
              experienceProvider: ExperienceProvider(
                netClient: widget.netClient,
              ),
              userProvider: UserProvider(
                netClient: widget.netClient,
              ),
            ),
          ),
          saveExperiencePreferencesUseCase: SaveExperiencePreferencesUseCase(
            repository: ExperiencePreferencesRepository(
              experienceProvider: ExperiencePreferencesProvider(
                netClient: widget.netClient,
              ),
            ),
          ),
        ),
      ),
      BlocProvider<DevicePermissionsCubit>(
        create: (context) => DevicePermissionsCubit(
          wrapper: DevicePermissionsWrapper(),
        ),
      ),
      BlocProvider<AuthenticationCubit>(
        create: (context) => AuthenticationCubit(
          getDeviceModelUseCase: GetDeviceModelUseCase(),
          shouldGetCustomerObject:
              widget.appConfiguration.shouldFetchCustomerObject,
          updateUserTokenUseCase: UpdateUserTokenUseCase(
            repository: AuthenticationRepository(
              AuthenticationProvider(
                netClient: widget.netClient,
              ),
            ),
          ),
          loginUseCase: LoginUseCase(
            repository: AuthenticationRepository(
              AuthenticationProvider(
                netClient: widget.netClient,
              ),
            ),
          ),
          logoutUseCase: LogoutUseCase(
            repository: AuthenticationRepository(
              AuthenticationProvider(
                netClient: widget.netClient,
              ),
            ),
          ),
          recoverPasswordUseCase: RecoverPasswordUseCase(
              repository: AuthenticationRepository(
            AuthenticationProvider(
              netClient: widget.netClient,
            ),
          )),
          resetPasswordUseCase: ResetPasswordUseCase(
              repository: AuthenticationRepository(
            AuthenticationProvider(
              netClient: widget.netClient,
            ),
          )),
          changePasswordUseCase: ChangePasswordUseCase(
              repository: AuthenticationRepository(
            AuthenticationProvider(
              netClient: widget.netClient,
            ),
          )),
          verifyAccessPinUseCase: VerifyAccessPinUseCase(
            repository: AuthenticationRepository(
              AuthenticationProvider(
                netClient: widget.netClient,
              ),
            ),
          ),
          customerUseCase: LoadCurrentCustomerUseCase(
            repository: CustomerRepository(CustomerProvider(widget.netClient)),
          ),
          loadDeveloperUserDetailsFromTokenUseCase:
              LoadDeveloperUserDetailsFromTokenUseCase(
            repository: UserRepository(
              userProvider: UserProvider(
                netClient: widget.netClient,
              ),
            ),
          ),
          loadUserDetailsFromTokenUseCase: LoadUserDetailsFromTokenUseCase(
            repository: UserRepository(
              userProvider: UserProvider(
                netClient: widget.netClient,
              ),
            ),
          ),
        ),
      ),
      BlocProvider<CurrencyCubit>(
        create: (_) => CurrencyCubit(
          loadAllCurrenciesUseCase: LoadAllCurrenciesUseCase(
            repository: CurrencyRepository(
              provider: CurrencyProvider(
                netClient: widget.netClient,
              ),
            ),
          ),
          loadCurrencyByCodeUseCase: LoadCurrencyByCodeUseCase(
            repository: CurrencyRepository(
              provider: CurrencyProvider(
                netClient: widget.netClient,
              ),
            ),
          ),
        ),
      ),
      BlocProvider<LocationCubit>(
        create: (_) => LocationCubit(
          location: loc.Location(),
        ),
      ),
      BlocProvider<GlobalSettingCubit>(
        create: (_) => GlobalSettingCubit(
          getGlobalSettingUseCase: LoadGlobalSettingsUseCase(
            repository: GlobalSettingRepository(
              provider: GlobalSettingProvider(
                netClient: widget.netClient,
              ),
            ),
          ),
        ),
      ),
      BlocProvider<UnreadAlertsCountCubit>(
        create: (_) => UnreadAlertsCountCubit(
          loadUnreadAlertsUseCase: LoadUnreadAlertsUseCase(
            repository: AlertRepository(
              AlertProvider(
                widget.netClient,
              ),
            ),
          ),
        ),
      ),
      BlocProvider<RootCheckCubit>(
        create: (_) => RootCheckCubit(
          globalSettingRepository: GlobalSettingRepository(
            provider: GlobalSettingProvider(
              netClient: widget.netClient,
            ),
          ),
        ),
      ),
    ];
  }

  Widget _appBuilder() => AppBuilder(
        key: _appKey,
        netClient: widget.netClient,
        navigatorKey: _navigatorKey,
        interceptors: widget.appConfiguration.interceptors,
        builder: (context) {
          final themeState = context.watch<AppThemeCubit>().state;
          final selectedLocale = context.select<LocalizationCubit, Locale>(
            (cubit) => cubit.state.locale,
          );
          final languageCode = selectedLocale.languageCode.split('_').first;

          Widget app = AutoLock(
            enabled: false,
            child: MaterialApp(
              navigatorKey: _navigatorKey,
              title: widget.appConfiguration.title ?? '',
              theme: themeState.selectedLightTheme.toThemeData(),
              darkTheme: themeState.selectedDarkTheme?.toThemeData(),
              themeMode: themeState.mode,
              useInheritedMediaQuery: widget.useInheritedMediaQuery,
              locale: Locale(languageCode),
              navigatorObservers: [
                if (widget.appConfiguration.firebaseAnalyticsEnabled)
                  FirebaseAnalyticsObserver(
                    analytics: FirebaseAnalytics.instance,
                  ),
              ],
              builder: (context, child) {
                // `child` can't be null, because the `initialRoute` is always
                // specified
                final app = widget.appConfiguration.autoKeyboardPaddingEnabled
                    ? AutoPaddingKeyboard(child: child!)
                    : child!;
                return SSLConfigurationBankAppWrapper(
                  appSSLConfiguration: widget.appSSLConfiguration,
                  navigatorKey: _navigatorKey,
                  child: widget.builder != null
                      ? widget.builder!(context, app, _navigatorKey)
                      : app,
                );
              },
              // ignore: deprecated_member_use_from_same_package
              home: widget.home,
              initialRoute: widget
                  .appConfiguration.appNavigationConfiguration.initialRoute,
              onGenerateRoute: widget
                  .appConfiguration.appNavigationConfiguration.onGenerateRoute,
              supportedLocales: widget.appConfiguration
                  .appLocalizationConfiguration.supportedLocales,
              localizationsDelegates: [
                widget.appConfiguration.appLocalizationConfiguration
                    .localizationDelegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              localeResolutionCallback: widget.appConfiguration
                  .appLocalizationConfiguration.localeResolutionCallback,
            ),
          );

          if (widget.appConfiguration.designAware) {
            // Conditional needed to not overwrite the default
            // [DesignAware] sizes
            app = widget.designAvailableSizes.isEmpty
                ? DesignAware(child: app)
                : DesignAware(
                    availableSizes: widget.designAvailableSizes,
                    child: app,
                  );
          }

          if (widget.appConfiguration.listeners.isNotEmpty) {
            return MultiBlocListener(
              listeners: widget.appConfiguration.listeners,
              child: app,
            );
          }

          return app;
        },
      );
}
