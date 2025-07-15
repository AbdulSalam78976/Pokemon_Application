// controller/pokemon_controller.dart

import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:pokemon_application/constants/constants.dart';
import 'package:pokemon_application/models/pokemon_model.dart';

class PokemonController extends GetxController {
  var pokemonList = <Pokemon>[].obs;
  var isLoading = true.obs;
  var error = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchPokemon(); // fetch on init
  }

  Future<void> fetchPokemon() async {
    try {
      isLoading(true);
      error('');
      final response = await http.get(Uri.parse(ApiKey));

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final pokedex = Pokedex.fromJson(jsonData);
        pokemonList.assignAll(pokedex.pokemon);
      } else {
        error('Failed to fetch data.');
      }
    } catch (e) {
      error(e.toString());
    } finally {
      isLoading(false);
    }
  }
}
