/// Clase Place (para procesar ubicación y lugar de origen)
class RMPlace {
  RMPlace({
    this.name,
    this.url,
  });

  /// Nombre
  String? name;

  /// URL
  String? url;

  factory RMPlace.fromJson(Map<String, dynamic> json) => RMPlace(
        name: json['name'] as String?,
        url: json['url'] as String?,
      );
}
