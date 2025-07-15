import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/route_manager.dart';
import 'package:http/http.dart' as http;
import 'package:pokemon_application/constants/constants.dart';
import 'package:pokemon_application/models/favorite_model.dart';
import 'package:pokemon_application/models/pokemon_model.dart';
import 'package:pokemon_application/screens/favourites_screen.dart';
import 'package:pokemon_application/utils/responisve.dart';
import 'package:pokemon_application/screens/pokemon_detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Future<Pokedex> fetchData() async {
    final url = Uri.parse(ApiKey);

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return Pokedex.fromJson(jsonData);
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final FavoriteModel favoriteModel = Get.put(FavoriteModel());
    final isMobile = Responsive.isMobile(context);
    Responsive.isTablet(context);
    final isDesktop = Responsive.isDesktop(context);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              top: -50,
              right: -50,
              child: Image.asset(
                'assets/images/pokeball.png',
                width: 200,
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
            Positioned(
              top: 30,
              left: 20,
              child: Text(
                'Pokédex',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.redAccent.shade400,
                  letterSpacing: 1.2,
                ),
              ),
            ),
            Positioned(
              right: 30,
              top: 30,
              child: PopupMenuButton<String>(
                icon: const Icon(Icons.menu, color: Colors.grey),
                onSelected: (value) {
                  if (value == 'favorites') {
                    Get.to(
                      () => FavouritesScreen(
                        favourites: favoriteModel.favoriteList,
                      ),
                    );
                  } else if (value == 'Profile') {
                    // TODO: Navigate to Profile screen or show dialog
                    Get.snackbar(
                      'Profile',
                      'Profile screen coming soon!',
                      snackPosition: SnackPosition.BOTTOM,
                    );
                  }
                },
                itemBuilder: (context) => const [
                  PopupMenuItem<String>(
                    value: 'Profile',
                    child: Text('Profile'),
                  ),
                  PopupMenuItem<String>(
                    value: 'favorites',
                    child: Text('Favorites'),
                  ),
                ],
              ),
            ),

            Positioned.fill(
              top: 100,
              child: Column(
                children: [
                  Expanded(
                    child: Stack(
                      children: [
                        // Pokeball background watermark
                        Positioned(
                          top: -40,
                          right: -40,
                          child: Opacity(
                            opacity: 0.08,
                            child: Image.asset(
                              'assets/images/pokeball.png',
                              width: 200,
                              height: 200,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        FutureBuilder<Pokedex>(
                          future: fetchData(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            } else if (snapshot.hasError) {
                              return Center(
                                child: Text("Error: \\${snapshot.error}"),
                              );
                            } else if (!snapshot.hasData ||
                                snapshot.data!.pokemon.isEmpty) {
                              return const Center(
                                child: Text("No data found."),
                              );
                            } else {
                              final pokemons = snapshot.data!.pokemon;
                              return GridView.builder(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 8,
                                ),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: isMobile
                                          ? 2
                                          : isDesktop
                                          ? 4
                                          : 3,
                                      crossAxisSpacing: 10,
                                      mainAxisSpacing: 10,
                                      childAspectRatio: isMobile ? 0.85 : 1.5,
                                    ),
                                itemCount: pokemons.length,
                                itemBuilder: (context, index) {
                                  final pokemon = pokemons[index];
                                  return InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              PokemonDetailScreen(
                                                pokemon: pokemon,
                                                color: _getTypeColor(
                                                  pokemon.type.first,
                                                ),
                                              ),
                                        ),
                                      );
                                    },
                                    child: _PokemonCard(pokemon: pokemon),
                                  );
                                },
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PokemonCard extends StatelessWidget {
  final Pokemon pokemon;
  const _PokemonCard({required this.pokemon});

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final isTablet = Responsive.isTablet(context);
    final isDesktop = Responsive.isDesktop(context);
    final double imageSize = isDesktop
        ? 300
        : isTablet
        ? 300
        : 200;
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      color: _getTypeColor(pokemon.type.first),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          // Pokeball watermark as background, centered
          Positioned.fill(
            child: Align(
              alignment: Alignment.center,
              child: Image.asset(
                'assets/images/pokeball.png',
                width: isMobile ? imageSize : imageSize / 2,
                height: isMobile ? imageSize : imageSize / 2,
                fit: BoxFit.contain,
              ),
            ),
          ),
          // Pokémon number
          Positioned(
            top: 14,
            left: 16,
            child: Text(
              '#${pokemon.num}',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.white70,
              ),
            ),
          ),
          // Pokémon image, centered above pokeball
          Positioned.fill(
            child: Align(
              alignment: Alignment.center,
              child: Hero(
                tag: 'pokemon_image_${pokemon.id}',
                child: CachedNetworkImage(
                  imageUrl: pokemon.spriteUrl,
                  width: imageSize,
                  height: imageSize,
                  placeholder: (context, url) =>
                      const CircularProgressIndicator(),
                  errorWidget: (context, url, error) {
                    print(
                      'Image load error for URL: \\${pokemon.spriteUrl} - Error: \\${error.toString()}',
                    );
                    return const Icon(Icons.error);
                  },
                ),
              ),
            ),
          ),
          // Name and types
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.only(
                left: 16,
                right: 16,
                bottom: 18,
                top: 60,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    pokemon.name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 1.1,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Wrap(
                    spacing: 6,
                    children: pokemon.type
                        .map(
                          (type) => Chip(
                            label: Text(
                              type.name,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Colors.white,
                              ),
                            ),
                            backgroundColor: _getTypeColor(
                              type,
                            ).withOpacity(0.7),
                            padding: EdgeInsets.zero,
                            visualDensity: VisualDensity.compact,
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

Color _getTypeColor(Type type) {
  switch (type) {
    case Type.GRASS:
      return const Color(0xFF78C850); // vibrant green
    case Type.FIRE:
      return const Color(0xFFF08030); // bright orange
    case Type.WATER:
      return const Color(0xFF6890F0); // soft blue
    case Type.ELECTRIC:
      return const Color(0xFFF8D030); // rich yellow
    case Type.POISON:
      return const Color(0xFFA040A0); // magenta-purple
    case Type.BUG:
      return const Color(0xFFA8B820); // grassy olive
    case Type.NORMAL:
      return const Color(0xFFA8A878); // muted taupe
    case Type.FLYING:
      return const Color(0xFFA890F0); // lavender
    case Type.FAIRY:
      return const Color(0xFFEE99AC); // light pink
    case Type.PSYCHIC:
      return const Color(0xFFF85888); // soft red-pink
    case Type.ROCK:
      return const Color(0xFFB8A038); // golden sand
    case Type.GROUND:
      return const Color(0xFFE0C068); // soft brown
    case Type.ICE:
      return const Color(0xFF98D8D8); // icy teal
    case Type.DRAGON:
      return const Color(0xFF7038F8); // royal purple
    case Type.DARK:
      return const Color(0xFF705848); // dark coffee
    case Type.GHOST:
      return const Color(0xFF705898); // haunted indigo
    case Type.STEEL:
      return const Color(0xFFB8B8D0); // metallic blue-gray
    default:
      return const Color(0xFF68A090); // default teal-gray
  }
}
