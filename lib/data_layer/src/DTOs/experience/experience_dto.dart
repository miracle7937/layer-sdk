import 'experience_page_dto.dart';

/// Data transfer object representing experience
/// configured in the Experience Studio.
class ExperienceDTO {
  /// A type of the navigation menu to be used within the application.
  ExperienceMenuTypeDTO? menu;

  /// A list of application pages.
  List<ExperiencePageDTO>? pages;

  /// Colors to be used within the application.
  Map? colors;

  /// Fonts to be used within the application.
  Map? fonts;

  /// Font sizes to be used within the application.
  Map? fontSizes;

  /// Unique identifier of the experience.
  String? experienceId;

  /// Background image to be used within the application.
  String? imageUrl;

  /// Main logo to be used within the application.
  String? mainLogoUrl;

  /// Symbol logo to be used within the application.
  String? symbolLogoUrl;

  /// Creates [ExperienceDTO] from json.
  ExperienceDTO.fromJson(Map<String, dynamic> json) {
    if (json['menu'] is int &&
        json['menu'] < ExperienceMenuTypeDTO.values.length) {
      menu = ExperienceMenuTypeDTO.values[json['menu']];
    }
    experienceId = json['experience_id'];
    final pageList = json['pages'] as List<Map<String, dynamic>>;
    pages = pageList.map(ExperiencePageDTO.fromJson).toList();
    colors = json['colors'];
    fonts = json['fonts'];
    // TODO: Make sure the BE is returning `font_sizes` field
    // and remove the second mapping.
    fontSizes = json['font_sizes'] ?? json['fonts_sizes'];
    imageUrl = json['image_url'];
    mainLogoUrl = json['main_logo_url'];
    symbolLogoUrl = json['symbol_logo_url'];
  }
}

/// Possible types of the navigation menus to be used within the application.
///
/// Do not reorder the enum cases - the order is used for json mapping.
enum ExperienceMenuTypeDTO {
  /// Case for a tab bar navigation menu placed on the top of the screen.
  tabBarTop,

  /// Case for a drawer navigation menu placed on the bottom of the screen.
  bottomDrawer,

  /// Case for a drawer navigation menu placed on the side of the screen.
  sideDrawer,

  /// Case for a tab bar navigation menu placed on the bottom of the screen.
  tabBarBottom,

  /// Case for a tab bar navigation menu with "focus" and "more"
  /// placed on the bottom of the screen.
  tabBarBottomWithFocusAndMore
}
