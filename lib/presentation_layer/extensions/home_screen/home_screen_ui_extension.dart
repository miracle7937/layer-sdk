import 'dart:collection';

import 'package:design_kit_layer/design_kit_layer.dart';
import 'package:flutter/material.dart';

import '../../../domain_layer/models.dart';
import '../../utils.dart';

/// UI Extension for the [HomeScreen].
extension HomeScreenUIExtension on Experience {
  /// TODO: Add the top bar menu when ready on the dk layer.
  /// Returns the top bar menu in case the experience menu type equals
  /// [ExperienceMenuType.tabBarTop]. Otherwise, it will be null.
  PreferredSizeWidget? get topBarMenu =>
      menuType == ExperienceMenuType.tabBarTop ? AppBar() : null;

  /// TODO: Add the sid drawer menu when ready on the dk layer.
  /// Returns the side drawer menu in case the experience menu type equals
  /// [ExperienceMenuType.sideDrawer]. Otherwise, it will be null.
  Widget? get sideDrawerMenu =>
      menuType == ExperienceMenuType.sideDrawer ? Container() : null;

  /// Returns the bottom bar menu if the menu type is one of the following:
  ///
  /// - [ExperienceMenuType.tabBarBottom]
  Widget bottomBarMenu(
    BuildContext context, {
    required ExperiencePage initialPage,
    required UnmodifiableListView<ExperiencePage> visiblePages,
    required ValueSetter<ExperiencePage> onSinglePageChanged,
    required ValueSetter<Set<ExperiencePage>> onMorePageChanged,
    String? moreMenuItemTitle,
  }) {
    final translation = Translation.of(context);

    final initialSelectedItem = DKMenuItem<ExperiencePage>(
      title: translation.translate(initialPage.title ?? ''),
      iconPath: initialPage.icon,
      sourceItem: initialPage,
    );

    final moreItem = DKMenuItem<ExperiencePage>(
      title: moreMenuItemTitle ?? translation.translate('more'),
      iconPath: 'more_horiz',
    );

    switch (menuType) {
      case ExperienceMenuType.tabBarBottom:
        final shouldShowMoreItem = visiblePages.length > 4;

        return DKBottomBarMenu<ExperiencePage>(
          initialSelectedItem: initialSelectedItem,
          items: visiblePages
              .take(4)
              .map(
                (page) => DKMenuItem<ExperiencePage>(
                  title: translation.translate(page.title ?? ''),
                  iconPath: page.icon,
                  sourceItem: page,
                ),
              )
              .toSet(),
          onItemPressed: (item) => onSinglePageChanged(item.sourceItem!),
          moreItem: !shouldShowMoreItem ? null : moreItem,
          onMoreItemPressed: !shouldShowMoreItem
              ? null
              : (_) => onMorePageChanged(
                    visiblePages
                        .where((page) => page.title != 'dashboard')
                        .skip(4)
                        .toSet(),
                  ),
        );

      case ExperienceMenuType.tabBarBottomWithFocusAndMore:
        final shouldShowMoreItem = visiblePages.length > 3;
        final homePage = visiblePages.singleWhere(
          (page) => page.title == 'dashboard',
        );

        return DKBottomBarMenuWithHomeAndMore<ExperiencePage>(
          initialSelectedItem: initialSelectedItem,
          items: visiblePages
              .where((page) => page.title != 'dashboard')
              .take(3)
              .map(
                (page) => DKMenuItem<ExperiencePage>(
                  title: translation.translate(page.title ?? ''),
                  iconPath: page.icon,
                  sourceItem: page,
                ),
              )
              .toSet(),
          onItemPressed: (item) => onSinglePageChanged(item.sourceItem!),
          homeItem: DKMenuItem<ExperiencePage>(
            title: translation.translate(homePage.title ?? ''),
            iconPath: homePage.icon,
            sourceItem: homePage,
          ),
          moreItem: !shouldShowMoreItem ? null : moreItem,
          onMoreItemPressed: !shouldShowMoreItem
              ? null
              : (_) => onMorePageChanged(
                    visiblePages
                        .where((page) => page.title != 'dashboard')
                        .skip(3)
                        .toSet(),
                  ),
        );

      default:
        return const SizedBox.shrink();
    }
  }
}
