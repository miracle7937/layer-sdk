import '../../models.dart';

///The model used for patching the favorite offers prefs
class FavoriteOffersPreference extends UserPreference<List<int>> {
  ///Creates a new [FavoriteOffersPreference]
  FavoriteOffersPreference({
    required List<int> value,
  }) : super('favorite_offers', value, null, null);

  @override
  Map<String, dynamic> toJson() => {
        'favorite_offers': value,
      };

  @override
  List<Object?> get props => [
        value,
      ];
}
