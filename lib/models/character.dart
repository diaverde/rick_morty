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
  int? id;

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
  String? origin;

  /// Ubicación
  String? location;

  /// Episodios
  List<String>? episode;

  factory RMCharacter.fromJson(Map<String, dynamic> json) => RMCharacter(
        id: json['id'] as int,
        name: json['name'] as String?,
        status: json['status'] as String?,
        species: json['species'] as String?,
        image: json['image'] as String?,
        gender: json['gender'] as String?,
        origin: json['origin']['name'] as String?,
        location: json['location']['name'] as String?,
        episode: (json['episode'] as List<dynamic>?)
            ?.map((e) => e as String)
            .toList(),
      );
}
