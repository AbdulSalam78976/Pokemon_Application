import 'dart:core';

class Pokedex {
  List<Pokemon> pokemon;

  Pokedex({required this.pokemon});

  factory Pokedex.fromJson(Map<String, dynamic> json) {
    var list = json['pokemon'] as List;
    List<Pokemon> pokemons = list.map((i) => Pokemon.fromJson(i)).toList();
    return Pokedex(pokemon: pokemons);
  }
}

class Pokemon {
  int id;
  String num;
  String name;
  String img;
  List<Type> type;
  String height;
  String weight;
  String candy;
  int? candyCount;
  Egg egg;
  double spawnChance;
  double avgSpawns;
  String spawnTime;
  List<double>? multipliers;
  List<Type> weaknesses;
  List<Evolution>? nextEvolution;
  List<Evolution>? prevEvolution;

  Pokemon({
    required this.id,
    required this.num,
    required this.name,
    required this.img,
    required this.type,
    required this.height,
    required this.weight,
    required this.candy,
    this.candyCount,
    required this.egg,
    required this.spawnChance,
    required this.avgSpawns,
    required this.spawnTime,
    this.multipliers,
    required this.weaknesses,
    this.nextEvolution,
    this.prevEvolution,
  });

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    return Pokemon(
      id: json['id'],
      num: json['num'],
      name: json['name'],
      img: (json['img'] as String).replaceFirst('http://', 'https://'),
      type: (json['type'] as List).map((e) => typeFromString(e)).toList(),
      height: json['height'],
      weight: json['weight'],
      candy: json['candy'],
      candyCount: json['candy_count'],
      egg: eggFromString(json['egg']),
      spawnChance: (json['spawn_chance']).toDouble(),
      avgSpawns: (json['avg_spawns']).toDouble(),
      spawnTime: json['spawn_time'],
      multipliers: json['multipliers'] != null
          ? List<double>.from(json['multipliers'].map((e) => e.toDouble()))
          : null,
      weaknesses: (json['weaknesses'] as List)
          .map((e) => typeFromString(e))
          .toList(),
      nextEvolution: json['next_evolution'] != null
          ? (json['next_evolution'] as List)
                .map((e) => Evolution.fromJson(e))
                .toList()
          : null,
      prevEvolution: json['prev_evolution'] != null
          ? (json['prev_evolution'] as List)
                .map((e) => Evolution.fromJson(e))
                .toList()
          : null,
    );
  }

  String get spriteUrl =>
      'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/$id.png';
}

class Evolution {
  String num;
  String name;

  Evolution({required this.num, required this.name});

  factory Evolution.fromJson(Map<String, dynamic> json) {
    return Evolution(num: json['num'], name: json['name']);
  }
}

// Enum helpers

enum Type {
  BUG,
  DARK,
  DRAGON,
  ELECTRIC,
  FAIRY,
  FIGHTING,
  FIRE,
  FLYING,
  GHOST,
  GRASS,
  GROUND,
  ICE,
  NORMAL,
  POISON,
  PSYCHIC,
  ROCK,
  STEEL,
  WATER,
}

Type typeFromString(String type) {
  return Type.values.firstWhere(
    (e) => e.name.toUpperCase() == type.toUpperCase(),
    orElse: () => Type.NORMAL,
  );
}

enum Egg { NOT_IN_EGGS, OMANYTE_CANDY, THE_10_KM, THE_2_KM, THE_5_KM }

Egg eggFromString(String egg) {
  switch (egg) {
    case "Not in Eggs":
      return Egg.NOT_IN_EGGS;
    case "Omanyte Candy":
      return Egg.OMANYTE_CANDY;
    case "10 km":
      return Egg.THE_10_KM;
    case "2 km":
      return Egg.THE_2_KM;
    case "5 km":
      return Egg.THE_5_KM;
    default:
      return Egg.NOT_IN_EGGS;
  }
}
