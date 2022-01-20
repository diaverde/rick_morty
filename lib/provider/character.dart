// ----------------------------------------------------
// ------Modelo de Datos de Spotify para Provider------
// ----------------------------------------------------

import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

/// Estados de carga
enum LoadStatus {
  /// En espera
  idle,

  /// Cargando
  loading,

  /// Cargado
  loaded,

  /// Error genérico
  error
}

/// Modelo para manejo de estado de personajes
class CharacterModel extends ChangeNotifier {
  List<dynamic> listOfSearchResults = [];

  /// Reiniciar todas las variables de este modelo
  void resetAll() {}
}
