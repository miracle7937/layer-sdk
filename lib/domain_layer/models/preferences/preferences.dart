import 'package:equatable/equatable.dart';

/// Preferences
class Preferences extends Equatable {
  /// Whether the user has hidden the access level container or not
  final bool? hideAccessLevelContainer;

  /// This user's preferred language.
  final String? language;

  /// This user's preferred currency.
  final String? currency;

  /// The preferred theme.
  final String? theme;

  /// The preferred way to order cards.
  final bool orderCard;

  /// The preferred way to order accounts.
  final bool orderAccount;

  /// The preferred account id to show on the overview tab.
  final String? overviewAccountId;

  /// Creates a new immutable [Preferences]
  const Preferences({
    this.hideAccessLevelContainer,
    this.language,
    this.currency,
    this.theme,
    this.orderCard = false,
    this.orderAccount = false,
    this.overviewAccountId,
  });

  /// Returns a copy of the perferences modified by the provided data.
  Preferences copyWith({
    bool? hideAccessLevelContainer,
    String? language,
    String? currency,
    String? theme,
    bool? orderCard,
    bool? orderAccount,
    String? overviewAccountId,
  }) =>
      Preferences(
        hideAccessLevelContainer:
            hideAccessLevelContainer ?? this.hideAccessLevelContainer,
        language: language ?? this.language,
        currency: currency ?? this.currency,
        theme: theme ?? this.theme,
        orderCard: orderCard ?? this.orderCard,
        orderAccount: orderAccount ?? this.orderAccount,
        overviewAccountId: overviewAccountId ?? this.overviewAccountId,
      );

  @override
  List<Object?> get props => [
        hideAccessLevelContainer,
        language,
        currency,
        theme,
        orderCard,
        orderAccount,
        overviewAccountId,
      ];
}
