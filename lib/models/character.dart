import 'package:rick_morty/models/place.dart';

/// Clase Character
class RMCharacter {
  RMCharacter({
    this.id,
    this.name,
    this.status,
    this.species,
    this.image,
    this.gender,
    this.origin,
    this.location,
    this.episode,
  });

  /// ID
  String? id;

  /// Nombre
  String? name;

  /// Estado
  String? status;

  /// Especie
  String? species;

  /// Imagen
  String? image;

  /// Género
  String? gender;

  /// Origen
  RMPlace? origin;

  /// Ubicación
  RMPlace? location;

  /// Episodios
  List<String>? episode;

  factory RMCharacter.fromJson(Map<String, dynamic> json) => RMCharacter(
        id: json['id'] as String?,
        name: json['name'] as String?,
        status: json['status'] as String?,
        species: json['species'] as String?,
        image: json['image'] as String?,
        gender: json['gender'] as String?,
        origin: json['origin'] == null
            ? null
            : RMPlace.fromJson(json['origin'] as Map<String, dynamic>),
        location: json['location'] == null
            ? null
            : RMPlace.fromJson(json['location'] as Map<String, dynamic>),
        episode: (json['episode'] as List<dynamic>?)
            ?.map((e) => e as String)
            .toList(),
      );
}
