/// Clase Location
class RMLocation {
  RMLocation({
    this.id,
    this.name,
    this.residents,
  });

  /// ID
  int? id;

  /// Nombre
  String? name;

  /// Residentes
  List<String>? residents;

  factory RMLocation.fromJson(Map<String, dynamic> json) => RMLocation(
        id: json['id'] as int,
        name: json['name'] as String?,
        residents: (json['residents'] as List<dynamic>?)
            ?.map((e) => e as String)
            .toList(),
      );
}
