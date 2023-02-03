import '../../dtos.dart';

///The model used for patching the favorite offers prefs
class FavoriteOffersPreferenceDTO extends UserPreferenceDTO<List<int>> {
  ///Creates a new [FavoriteOffersPreferenceDTO]
  FavoriteOffersPreferenceDTO({
    required List<int> value,
  }) : super('favorite_offers', value);

  @override
  Map<String, dynamic> toJson() => {
        'favorite_offers': value,
      };
}
