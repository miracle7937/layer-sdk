import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:layer_sdk/business_layer/business_layer.dart';
import 'package:layer_sdk/data_layer/data_layer.dart';

import '../../../flutter_layer.dart';
import '../../extensions/home_screen_ui_extension.dart';

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

  /// The [MorePageBuilder] for when the more page get's pressed.
  final MorePageBuilder morePageBuilder;

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

  /// Creates a new [HomeScreen]
  const HomeScreen({
    Key? key,
    required this.pageBuilder,
    required this.morePageBuilder,
    this.initialPageCallback,
    required this.fullscreenLoader,
    this.moreMenuItemTitle,
  }) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  /// Wether if the widget has been initialized or not.
  bool _initialized = false;

  /// The current page widget.
  Widget? _pageWidget;
  Widget? get pageWidget => _pageWidget;
  set pageWidget(Widget? pageWidget) =>
      setState(() => _pageWidget = pageWidget);

  /// The initial page index.
  late ExperiencePage _initialPage;

  @override
  void didChangeDependencies() async {
    if (!_initialized) {
      _initialized = true;

      await context.read<ExperienceCubit>().load(public: false);

      _initialPage = widget.initialPageCallback != null
          ? await widget.initialPageCallback!(
              context.read<ExperienceCubit>().state.visiblePages,
            )
          : context.read<ExperienceCubit>().state.visiblePages.first;

      pageWidget = widget.pageBuilder(
        context,
        _initialPage,
      );
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final busy = context.select<ExperienceCubit, bool>(
      (cubit) => cubit.state.busy,
    );

    final experience = context.select<ExperienceCubit, Experience?>(
      (cubit) => cubit.state.experience,
    );

    return Scaffold(
      drawer: experience?.sideDrawerMenu,
      appBar: experience?.topBarMenu,
      body: Stack(
        children: [
          Column(
            children: [
              if (experience != null && pageWidget != null) ...[
                Expanded(
                  child: pageWidget!,
                ),
                experience.bottomBarMenu(
                  context,
                  initialPage: _initialPage,
                  visiblePages:
                      context.watch<ExperienceCubit>().state.visiblePages,
                  moreMenuItemTitle: widget.moreMenuItemTitle,
                  onSinglePageChanged: (page) =>
                      pageWidget = widget.pageBuilder(context, page),
                  onMorePageChanged: (morePages) =>
                      pageWidget = widget.morePageBuilder(context, morePages),
                ),
              ],
            ],
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
