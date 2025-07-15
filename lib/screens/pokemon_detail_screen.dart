import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pokemon_application/models/pokemon_model.dart';
import 'package:pokemon_application/utils/responisve.dart';

class PokemonDetailScreen extends StatefulWidget {
  final Pokemon pokemon;
  final Color color;
  const PokemonDetailScreen({
    super.key,
    required this.pokemon,
    required this.color,
  });

  @override
  State<PokemonDetailScreen> createState() => _PokemonDetailScreenState();
}

class _PokemonDetailScreenState extends State<PokemonDetailScreen> {
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

    return Scaffold(
      backgroundColor: widget.color,
      body: Stack(
        children: [
          /// Back Button
          Positioned(
            left: 10,
            top: 15,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Get.back(),
            ),
          ),

          /// Favorite Icon
          Positioned(
            right: 10,
            top: 15,
            child: IconButton(
              icon: const Icon(
                Icons.favorite_border_outlined,
                color: Colors.white,
              ),
              onPressed: () {},
            ),
          ),

          /// Pokémon Name
          Positioned(
            top: 50,
            left: 25,
            child: Text(
              widget.pokemon.name,
              style: const TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),

          /// Pokémon Types
          Positioned(
            top: 105,
            left: 25,
            child: Wrap(
              spacing: 8,
              children: widget.pokemon.type
                  .map(
                    (type) => Chip(
                      label: Text(
                        type.name,
                        style: const TextStyle(color: Colors.white),
                      ),
                      backgroundColor: widget.color.withOpacity(0.8),
                    ),
                  )
                  .toList(),
            ),
          ),

          /// Pokeball Background
          Positioned(
            bottom: Get.height * 0.53,
            right: -30,
            child: Image.asset(
              "assets/images/pokeball.png",
              width: 180,
              height: 180,
              fit: BoxFit.cover,
            ),
          ),

          /// Pokémon Image

          /// Details Container
          Positioned(
            bottom: 0,
            child: Container(
              width: Get.width,
              height: Get.height * 0.55,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    offset: const Offset(0, -2),
                    blurRadius: 10,
                  ),
                ],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 30),

                  _infoRow("Name:", widget.pokemon.name),
                  const SizedBox(height: 20),

                  _infoRow("Height:", widget.pokemon.height),
                  const SizedBox(height: 20),

                  _infoRow("Weight:", widget.pokemon.weight),
                  const SizedBox(height: 20),

                  _infoRow("Spawn Time:", widget.pokemon.spawnTime),
                  const SizedBox(height: 20),

                  const Text(
                    "Weaknesses:",
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.blueGrey,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),

                  Wrap(
                    spacing: 6,
                    children: widget.pokemon.weaknesses.map((weakness) {
                      return Chip(
                        label: Text(
                          weakness.name,
                          style: const TextStyle(color: Colors.white),
                        ),
                        backgroundColor: Colors.redAccent.shade200,
                        visualDensity: VisualDensity.compact,
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: isMobile ? Get.height * 0.45 : Get.height * 0.4,
            right: isMobile ? 150 : 500,
            child: Hero(
              tag: 'pokemon_image_${widget.pokemon.id}',
              child: CachedNetworkImage(
                imageUrl: widget.pokemon.spriteUrl,
                width: imageSize,
                height: imageSize,
                fit: BoxFit.cover,
                placeholder: (context, url) =>
                    const CircularProgressIndicator(),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Reusable row widget for displaying title + value
  Widget _infoRow(String title, dynamic value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            color: widget.color.withOpacity(0.8),
            fontWeight: FontWeight.w600,
          ),
        ),
        Text(
          value.toString(),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
      ],
    );
  }
}
