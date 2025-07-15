import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:pokemon_application/models/pokemon_model.dart';

class FavoriteModel extends GetxController {
  RxList<Pokemon> favoriteList = <Pokemon>[].obs;

  void addFavorite(Pokemon pokemon) {
    favoriteList.add(pokemon);
  }

  bool isFavorite(Pokemon pokemon) {
    return favoriteList.contains(pokemon);
  }

  void removeFavorite(Pokemon pokemon) {
    favoriteList.remove(pokemon);
  }
}
