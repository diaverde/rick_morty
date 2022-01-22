// -------------------------------------------------------------------
// -----------------Datos globales de configuración-------------------
// -------------------------------------------------------------------

/// Clase para conexión a servicios
class Config {
  /// URL de API de Rick and Morty
  static String apiEndpoint = 'https://rickandmortyapi.com/api/';

  /// URL para información de personajes
  static String get characterURL => apiEndpoint + 'character';

  /// URL para información de ubicaciones
  static String get locationURL => apiEndpoint + 'location';

  /// URL para información de episodios
  static String get episodeURL => apiEndpoint + 'episode';
}
