import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain_layer/models.dart';
import '../../cubits.dart';
import '../../extensions.dart';
import '../../utils/translation.dart';
import '../../widgets.dart';

/// Custom callback called when a [PullToRefresh] gets triggered on a
/// page with multiple containers.
typedef CustomOnRefreshMultiContainerPageCallback = Function(
  ExperiencePage page,
  bool isDashboard,
);

/// Custom type created for building an [ExperiencePage].
///
/// When a single DK menu item is selected, the corresponding [ExperiencePage]
/// gets returned and the page is passed to this builder.
///
/// {@tool snippet}
///
/// For example, the user presses the menu item related to the accounts so,
/// when the builder gets called with the accounts [ExperiencePage], you will
/// check the page and show the corresponding view.
///
/// This example uses the [HomeScreen.pageBuilder] parameter:
///
/// ```dart
/// HomeScreen(
///   pageBuilder: (experiencePage, context) {
///     final containers = experiencePage.containers;
///     return ScreenFactory.generate(containers: containers);
///   },
/// );
/// ```
/// {@end-tool}
typedef ExperiencePageBuilder = Widget Function(
  BuildContext context,
  ExperiencePage page,
);

/// Custom type created for building a set of [ExperiencePage].
///
/// When a more menu item gets pressed on a DK menu, a set of pages will be
/// returned to the app. Usually this is used for building a tile page where
/// the user can access each page pressing its tile.
///
/// {@tool snippet}
///
/// This example uses the [HomeScreen.morePageBuilder] parameter:
///
/// ```dart
/// HomeScreen(
///   morePageBuilder: (pages, context) => MoreScreen(pages: pages),
/// );
/// ```
///
/// The MoreScreen will be a view that requires a set of pages and uses that
/// parameter for displaying a list tile with them.
/// {@end-tool}
typedef MorePageBuilder = Widget Function(
  BuildContext context,
  Set<ExperiencePage> pages,
  ValueSetter<ExperiencePage> onSingleMorePageSelected,
  Widget Function(ExperiencePage experiencePage),
);

/// Custom type created for building the app bar for the currently selected page
///
/// This example uses the [HomeScreen.appBarBuilder] parameter:
///
/// ```dart
/// HomeScreen(
///   appBarBuilder: (context, page) => AppBar(
///     title: Text(page.title),
///   ),
/// );
/// ```
typedef AppBarBuilder = PreferredSizeWidget? Function(
  BuildContext context,
  ExperiencePage currenctPage,
);

/// A screen that fetches the authenticated experience and builds the
/// corresponding menu and their available pages with the result.
///
/// A [fullscreenLoader] is required and it will be displayed while the
/// experience is being fetched.
///
/// Once the experience has been successfully retrieved you will be able to
/// decide which page from the experience is the first to get displayed. Use
/// the [initialPageCallback] for getting the retrieved pages in the
/// experience and return the page that you want to be initially selected.
/// When not indicating the callback, the first visible page will be
/// selected by default.
///
/// After that, the the DK menu type that the
/// retrieved experience uses will be built and the initial page will be built
/// using the required [pageBuilder] parameter.
/// See more on the [ExperiencePageBuilder].
///
/// Usually, the DK menus uses a more item menu since the visible pages length
/// is too high for the menu to show all the available pages. On the home screen
/// the [morePageBuilder] is required, and is usually used for showing a
/// list tile with all the pages that did not fit in the DK menu type that
/// belongs to the retrieved experience.
/// See more on the [MorePageBuilder].
///
/// The DK menu item titles are retrieved from the [ExperiencePage.title]
/// parameter, but when there are too many items to be displayed, as explained
/// above, the more item menu will show. Use the [moreMenuItemTitle] for
/// passing the a custom localized title for this menu item. When not indicated,
/// the localization key [more] will be used by default, so please, make sure
/// this key exists on the app drive localization file.
///
/// {@tool snippet}
/// ```dart
/// TODO: Update docs
/// HomeScreen(
///   pageBuilder: (experiencePage, context) {
///     /// Check which view corresponds to the experience page.
///     return Container();
///   },
///   morePageBuilder: (pages, context) {
///     /// Return the list tile for the pages that did not fit the menu.
///     return Container();
///   },
///   initialPageCallbak: (pages) {
///     /// Return the page that you whish to be initially selected.
///     return pages.first;
///   },
///   fullscreenLoader: Text('Loading...'),
///   moreMenuItemTitle: Translation.of(context).translate('customMore'),
/// );
/// ```
/// {@end-tool}
class HomeScreen extends StatefulWidget {
  /// The [ExperiencePageBuilder] for when the menu [ExperiencePage] changes.
  final ExperiencePageBuilder pageBuilder;

  /// The container builder for the cards
  final ContainerBuilder cardsBuilder;

  /// The extra card builder in addition the other cards
  final ExtraCardBuilder? extraCardsBuilder;

  /// The extra container list to put the page with position
  final List<ExtraCard> extraContainers;

  /// The [MorePageBuilder] for when the more page get's pressed.
  final MorePageBuilder morePageBuilder;

  /// The [AppBarBuilder] for building the app bar of the selected page.
  final AppBarBuilder? appBarBuilder;

  /// The [AppBarBuilder] for building the app bar of the selected page
  /// for more page items.
  final AppBarBuilder? morePageAppBarBuilder;

  /// A [Future] method for deciding the initial page based on the
  /// retrieved [ExperiencePage] list.
  ///
  /// If not indicated, the first visible page will be used.
  final Future<ExperiencePage> Function(List<ExperiencePage> pages)?
      initialPageCallback;

  /// The fullscreen loader for when the experience is being retrieved.
  final Widget fullscreenLoader;

  /// The more menu item title. In case that it's not indicated, the key 'more'
  /// will be used by default by the [Translation] class.
  final String? moreMenuItemTitle;

  /// The background color to be aplied by the `Scaffold`
  final Color? backgroundColor;

  /// The style of the system overlays, like the status bar, applied to the
  /// multiple cards pages.
  final SystemUiOverlayStyle cardsPageUIOverlayStyle;

  /// Callback called when a page with multiple containes gets refreshed by
  /// the [PullToRefresh] widget.
  final CustomOnRefreshMultiContainerPageCallback
      onRefreshMultiContainerPageCallback;

  /// Indicates if the more menu should be forced to be rendered
  final bool forceMoreMenuVisibility;

  /// Creates a new [HomeScreen]
  const HomeScreen({
    Key? key,
    required this.pageBuilder,
    required this.cardsBuilder,
    required this.morePageBuilder,
    this.morePageAppBarBuilder,
    this.appBarBuilder,
    this.extraCardsBuilder,
    this.extraContainers = const [],
    this.initialPageCallback,
    required this.fullscreenLoader,
    this.moreMenuItemTitle,
    this.backgroundColor,
    this.cardsPageUIOverlayStyle = SystemUiOverlayStyle.light,
    this.forceMoreMenuVisibility = false,
    required this.onRefreshMultiContainerPageCallback,
  })  : assert(extraContainers.length == 0 || extraCardsBuilder != null),
        super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  /// The current page widget.
  Widget? _pageWidget;

  Widget? get pageWidget => _pageWidget;

  set pageWidget(Widget? pageWidget) =>
      setState(() => _pageWidget = pageWidget);

  /// The initial page index.
  late ExperiencePage _initialPage;

  ExperiencePage? _selectedPage;

  /// The key used to repain the multi container page in case
  /// the [PullToRefresh] widget gets triggered.
  Key _multiContainerPageKey = UniqueKey();
  Key get multiContainerPageKey => _multiContainerPageKey;
  set multiContainerPageKey(Key key) => setState(
        () => _multiContainerPageKey = key,
      );

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback(
      (_) => context.read<ExperienceCubit>().load(public: false),
    );
  }

  void _updatePageWidget(ExperiencePage page) {
    _selectedPage = page;
    final containers = page.containers;
    final extraContainersForPage = widget.extraContainers
        .where((element) => element.visible(page))
        .toList();
    final containerCount = containers.length + extraContainersForPage.length;
    if (containers.isEmpty) {
      pageWidget = SizedBox.shrink();
    } else if (containerCount == 1) {
      pageWidget = widget.pageBuilder(
        context,
        page,
      );
    } else {
      pageWidget = PullToRefresh(
        onRefresh: () async {
          final isDashboard =
              context.read<ExperienceCubit>().state.visiblePages.first == page;

          if (isDashboard) {
            context.read<ExperienceCubit>().load(
                  public: false,
                  clearExperience: false,
                );
          }

          widget.onRefreshMultiContainerPageCallback(page, isDashboard);
          _multiContainerPageKey = UniqueKey();
        },
        child: LayerPageBuilder(
          key: _multiContainerPageKey,
          page: page,
          containerBuilder: widget.cardsBuilder,
          extraCardBuilder: widget.extraCardsBuilder,
          extraCards: widget.extraContainers,
          uiOverlayStyle: widget.cardsPageUIOverlayStyle,
        ),
      );
    }
  }

  /// Getting widget representing current experience page for displaying
  /// as an items for More menu
  Widget _getMorePageWidget(ExperiencePage page) {
    _selectedPage = page;
    final containers = page.containers;
    final extraContainersForPage = widget.extraContainers
        .where((element) => element.visible(page))
        .toList();
    final containerCount = containers.length + extraContainersForPage.length;
    if (containers.isEmpty) {
      return SizedBox.shrink();
    } else if (containerCount == 1) {
      return widget.pageBuilder(
        context,
        page,
      );
    } else {
      final experience = context.read<ExperienceCubit>().state.experience;
      return _getContent(
        appBar: (experience?.pages != null && experience!.pages.isNotEmpty)
            ? (widget.morePageAppBarBuilder != null && _selectedPage != null)
                ? widget.morePageAppBarBuilder!(context, _selectedPage!)
                : experience.topBarMenu
            : null,
        pageWidget: LayerPageBuilder(
          key: _multiContainerPageKey,
          page: page,
          containerBuilder: widget.cardsBuilder,
          extraCardBuilder: widget.extraCardsBuilder,
          extraCards: widget.extraContainers,
          uiOverlayStyle: widget.cardsPageUIOverlayStyle,
        ),
        withBottomBar: false,
        experience: experience,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final busy = context.select<ExperienceCubit, bool>(
      (cubit) => cubit.state.busy,
    );

    final experience = context.select<ExperienceCubit, Experience?>(
      (cubit) => cubit.state.experience,
    );

    return MultiBlocListener(
      listeners: [
        BlocListener<ExperienceCubit, ExperienceState>(
          listenWhen: (previous, current) =>
              previous.experience == null && current.experience != null,
          listener: (context, state) async {
            _initialPage = widget.initialPageCallback != null
                ? await widget.initialPageCallback!(state.visiblePages)
                : state.visiblePages.first;

            _updatePageWidget(_initialPage);
          },
        ),
        BlocListener<ExperienceCubit, ExperienceState>(
          listenWhen: (previous, current) =>
              previous.error == ExperienceStateError.none &&
              current.error != ExperienceStateError.none,
          listener: (context, state) async {
            await BottomSheetHelper.showError(
              context: context,
              titleKey: state.error.toTitleKey(),
              descriptionKey: state.errorMessage,
              dismissKey: 'retry',
            );

            context.read<ExperienceCubit>().load(public: false);
          },
        ),
      ],
      child: _getContent(
        appBar: (experience?.pages != null && experience!.pages.isNotEmpty)
            ? (widget.appBarBuilder != null && _selectedPage != null)
                ? widget.appBarBuilder!(context, _selectedPage!)
                : experience.topBarMenu
            : null,
        pageWidget: pageWidget,
        experience: experience,
        busy: busy,
      ),
    );
  }

  Widget _getContent({
    PreferredSizeWidget? appBar,
    Widget? pageWidget,
    bool withBottomBar = true,
    Experience? experience,
    bool busy = false,
  }) {
    return LayerScaffold(
      drawer: experience?.sideDrawerMenu,
      appBar: appBar,
      backgroundColor: widget.backgroundColor,
      body: Stack(
        children: [
          SizedBox(
            height: double.maxFinite,
            width: double.maxFinite,
            child: Column(
              children: [
                if (experience != null && pageWidget != null) ...[
                  Expanded(
                    child: pageWidget,
                  ),
                  if (withBottomBar)
                    experience.bottomBarMenu(
                      context,
                      initialPage: _initialPage,
                      visiblePages:
                          context.watch<ExperienceCubit>().state.visiblePages,
                      moreMenuItemTitle: widget.moreMenuItemTitle,
                      onSinglePageChanged: _updatePageWidget,
                      onMorePageChanged: (morePages) {
                        _selectedPage = null;
                        this.pageWidget = widget.morePageBuilder(
                          context,
                          morePages,
                          _updatePageWidget,
                          _getMorePageWidget,
                        );
                      },
                      forceMoreMenuVisibility: widget.forceMoreMenuVisibility,
                    ),
                ],
              ],
            ),
          ),
          if (busy)
            Positioned.fill(
              child: widget.fullscreenLoader,
            ),
        ],
      ),
    );
  }
}
