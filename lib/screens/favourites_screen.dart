import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pokemon_application/models/pokemon_model.dart';

import 'package:pokemon_application/utils/responisve.dart';

class FavouritesScreen extends StatefulWidget {
  final List<Pokemon> favourites;

  const FavouritesScreen({super.key, required this.favourites});

  @override
  State<FavouritesScreen> createState() => _FavouritesScreenState();
}

class _FavouritesScreenState extends State<FavouritesScreen> {
  late List<Pokemon> favList;

  @override
  void initState() {
    super.initState();
    favList = List.from(widget.favourites); // Create a mutable copy
  }

  void removeFromFavorites(Pokemon pokemon) {
    setState(() {
      favList.remove(pokemon);
    });

    // Optional: Show feedback
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${pokemon.name} removed from favourites'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = Responsive.isMobile(context);
    final isTablet = Responsive.isTablet(context);
    final isDesktop = Responsive.isDesktop(context);

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Stack(
          children: [
            /// Background Pokéball Watermark
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

            /// Title & Back Button
            Positioned(
              top: 10,
              left: 10,
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back, color: Colors.grey),
                    onPressed: () => Get.back(),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Favourites',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.redAccent.shade400,
                      letterSpacing: 1.2,
                    ),
                  ),
                ],
              ),
            ),

            /// Grid of Favourite Pokémon
            Padding(
              padding: const EdgeInsets.only(top: 70),
              child: favList.isEmpty
                  ? const Center(
                      child: Text(
                        'No favourites added yet!',
                        style: TextStyle(fontSize: 18, color: Colors.grey),
                      ),
                    )
                  : GridView.builder(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: isMobile
                            ? 2
                            : isTablet || isDesktop
                            ? 3
                            : 4,
                        crossAxisSpacing: 18,
                        mainAxisSpacing: 18,
                        childAspectRatio: 0.85,
                      ),
                      itemCount: favList.length,
                      itemBuilder: (context, index) {
                        final pokemon = favList[index];
                        return GestureDetector(
                          onTap: () {
                            // TODO: Navigate to detail screen
                          },
                          child: Stack(
                            children: [
                              _PokemonCard(pokemon: pokemon),
                              Positioned(
                                top: 6,
                                right: 6,
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.favorite,
                                    color: Colors.redAccent,
                                    size: 24,
                                  ),
                                  onPressed: () => removeFromFavorites(pokemon),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
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
    Responsive.isMobile(context);
    final isTablet = Responsive.isTablet(context);
    final isDesktop = Responsive.isDesktop(context);
    final double imageSize = isDesktop
        ? 500
        : isTablet
        ? 300
        : 100;

    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(22)),
      color: _getTypeColor(pokemon.type.first),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          /// Background Pokéball
          Positioned.fill(
            child: Align(
              alignment: Alignment.center,
              child: Image.asset(
                'assets/images/pokeball.png',
                width: imageSize / 2,
                height: imageSize / 2,
                fit: BoxFit.contain,
              ),
            ),
          ),

          /// Pokémon Number
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

          /// Pokémon Image
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
                      'Image load error for URL: ${pokemon.spriteUrl} - Error: ${error.toString()}',
                    );
                    return const Icon(Icons.error);
                  },
                ),
              ),
            ),
          ),

          /// Name and Types
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

/// Color Mapping Based on Type
Color _getTypeColor(Type type) {
  switch (type) {
    case Type.GRASS:
      return const Color(0xFF78C850);
    case Type.FIRE:
      return const Color(0xFFF08030);
    case Type.WATER:
      return const Color(0xFF6890F0);
    case Type.ELECTRIC:
      return const Color(0xFFF8D030);
    case Type.POISON:
      return const Color(0xFFA040A0);
    case Type.BUG:
      return const Color(0xFFA8B820);
    case Type.NORMAL:
      return const Color(0xFFA8A878);
    case Type.FLYING:
      return const Color(0xFFA890F0);
    case Type.FAIRY:
      return const Color(0xFFEE99AC);
    case Type.PSYCHIC:
      return const Color(0xFFF85888);
    case Type.ROCK:
      return const Color(0xFFB8A038);
    case Type.GROUND:
      return const Color(0xFFE0C068);
    case Type.ICE:
      return const Color(0xFF98D8D8);
    case Type.DRAGON:
      return const Color(0xFF7038F8);
    case Type.DARK:
      return const Color(0xFF705848);
    case Type.GHOST:
      return const Color(0xFF705898);
    case Type.STEEL:
      return const Color(0xFFB8B8D0);
    default:
      return const Color(0xFF68A090);
  }
}
