import '../../dtos.dart';
import '../../helpers.dart';

/// User Preferences
class PreferencesDTO {
  /// Whether the user has hidden the access level container or not
  bool? hideAccessLevelContainer;

  /// This user's preferred language.
  String? language;

  /// This user's preferred currency.
  String? currency;

  /// The preferred theme.
  String? theme;

  /// The preferred way to order cards.
  bool? orderCard;

  /// The preferred way to order accounts.
  bool? orderAccount;

  /// The preferred account id to show on the overview tab.
  String? overviewAccountId;

  /// The user's pref accounts
  List<AccountPreferencesDTO>? account;

  /// The user's pref cards
  List<CardPreferencesDTO>? cards;

  /// Creates a new [PreferencesDTO]
  PreferencesDTO({
    this.hideAccessLevelContainer,
    this.language,
    this.currency,
    this.theme,
    this.orderCard,
    this.orderAccount,
    this.overviewAccountId,
    this.account,
    this.cards,
  });

  /// Creates a [PreferencesDTO] from a JSON
  factory PreferencesDTO.fromJson(Map<String, dynamic> json) {
    return PreferencesDTO(
      hideAccessLevelContainer:
          JsonParser.jsonLookup(json['pref'], ['hide_access_level_container']),
      language: JsonParser.jsonLookup(json['pref'], ['language']),
      currency: JsonParser.jsonLookup(json['pref'], ['currency']),
      theme: JsonParser.jsonLookup(json['pref'], ['pref_theme']),
      orderCard: JsonParser.jsonLookup(json, ['pref', 'order_card']) ==
              "pref_nickname ASC"
          ? true
          : false,
      orderAccount: JsonParser.jsonLookup(json, ['pref', 'order_account']) ==
              "pref_nickname ASC"
          ? true
          : false,
      overviewAccountId:
          JsonParser.jsonLookup(json['pref'], ['overview_pref_account']),
      account: AccountPreferencesDTO.fromJsonMap(
          JsonParser.jsonLookup(json, ['pref', 'customer_account']) != null
              ? json['pref']['customer_account']
              : {}),
      cards: CardPreferencesDTO.fromJsonMap(
          JsonParser.jsonLookup(json, ['pref', 'card']) != null
              ? json['pref']['card']
              : {}),
    );
  }
}
