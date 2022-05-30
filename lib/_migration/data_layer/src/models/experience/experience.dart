import 'dart:collection';

import 'package:equatable/equatable.dart';

import '../../../models.dart';

/// A model representing configuration created for the application
/// in the Experience Studio.
class Experience extends Equatable {
  /// Unique identifier of the experience.
  final String id;

  /// A type of the navigation menu to be used within the application.
  final ExperienceMenuType menuType;

  /// A list of application pages.
  final UnmodifiableListView<ExperiencePage> pages;

  /// Colors to be used within the application.
  final UnmodifiableMapView<String, String> colors;

  /// Fonts to be used within the application.
  final UnmodifiableMapView<String, String> fonts;

  /// Font sizes to be used within the application.
  final UnmodifiableMapView<String, int> fontSizes;

  /// Background image to be used within the application.
  final String? backgroundImageUrl;

  /// Main logo to be used within the application.
  final String? mainLogoUrl;

  /// Symbol logo to be used within the application.
  final String? symbolLogoUrl;

  /// Preferences for each experience defined by the user.
  final UnmodifiableListView<ExperiencePreferences> preferences;

  /// Creates [Experience].
  Experience({
    required this.id,
    required this.menuType,
    Iterable<ExperiencePage>? pages,
    Map<String, String>? colors,
    Map<String, String>? fonts,
    Map<String, int>? fontSizes,
    this.symbolLogoUrl,
    this.mainLogoUrl,
    this.backgroundImageUrl,
    Iterable<ExperiencePreferences>? preferences,
  })  : pages = UnmodifiableListView(pages ?? []),
        colors = UnmodifiableMapView(colors ?? {}),
        fonts = UnmodifiableMapView(fonts ?? {}),
        fontSizes = UnmodifiableMapView(fontSizes ?? {}),
        preferences = UnmodifiableListView(preferences ?? []);

  /// Creates a new instance of [Experience] based on this one.
  Experience copyWith({
    String? id,
    ExperienceMenuType? menuType,
    Iterable<ExperiencePage>? pages,
    Map<String, String>? colors,
    Map<String, String>? fonts,
    Map<String, int>? fontSizes,
    String? backgroundImageUrl,
    String? mainLogoUrl,
    String? symbolLogoUrl,
    Iterable<ExperiencePreferences>? preferences,
  }) {
    return Experience(
      id: id ?? this.id,
      menuType: menuType ?? this.menuType,
      pages: pages ?? this.pages,
      colors: colors ?? this.colors,
      fonts: fonts ?? this.fonts,
      fontSizes: fontSizes ?? this.fontSizes,
      backgroundImageUrl: backgroundImageUrl ?? this.backgroundImageUrl,
      mainLogoUrl: mainLogoUrl ?? this.mainLogoUrl,
      symbolLogoUrl: symbolLogoUrl ?? this.symbolLogoUrl,
      preferences: preferences ?? this.preferences,
    );
  }

  @override
  List<Object?> get props => [
        id,
        menuType,
        pages,
        colors,
        fonts,
        fontSizes,
        backgroundImageUrl,
        mainLogoUrl,
        symbolLogoUrl,
        preferences,
      ];
}

/// Possible types of the navigation menus to be used within the application.
enum ExperienceMenuType {
  /// Case for a tab bar navigation menu placed on the top of the screen.
  tabBarTop,

  /// Case for a tab bar navigation menu placed on the bottom of the screen.
  tabBarBottom,

  /// Case for a tab bar navigation menu with "focus" and "more"
  /// placed on the bottom of the screen.
  tabBarBottomWithFocusAndMore,

  /// Case for a drawer navigation menu placed on the side of the screen.
  sideDrawer,

  /// Case for a drawer navigation menu placed on the bottom of the screen.
  bottomDrawer,
}
